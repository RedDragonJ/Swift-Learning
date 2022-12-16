import SwiftUI
import PlaygroundSupport

let apiData = "https://raw.githubusercontent.com/RedDragonJ/APISimulation/master/MyJSON"

// DataModel layer
struct EmployeeResponse: Decodable {
    let employees: [Employee]
}

struct Employee: Codable, Identifiable, Hashable {
    var id: String
    var fullName: String
    var phoneNumber: String
    var email: String
    var biography: String
    var imageURL: URL
    var employeeType: Kind
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case email = "email_address"
        case biography
        case imageURL = "image_URL"
        case employeeType = "employee_type"
    }
    
    enum Kind: String, Codable {
        case fullTime = "FULL_TIME"
        case partTime = "PART_TIME"
    }
}

// Network layer
protocol NetworkInterface {
    func fetchData(url: URL) async throws -> Data
}

class NetworkSession: NetworkInterface {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .ephemeral)) {
        self.urlSession = urlSession
    }
    
    func fetchData(url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

// Image cache layer
protocol ImageRepoInterface {
    func getImage(url: URL) async throws -> UIImage?
    func fetchImage(url: URL) async throws -> UIImage?
}

class ImageRepo: ImageRepoInterface {
    private var urlSession: URLSession
    private let cache: URLCache
    
    init(urlSession: URLSession = URLSession(configuration: .ephemeral), cache: URLCache = URLCache.shared) {
        self.urlSession = urlSession
        self.cache = cache
    }
    
    func getImage(url: URL) async throws -> UIImage? {
        
        let request = URLRequest(url: url)
        
        if let cachedData = cache.cachedResponse(for: request)?.data, let image = UIImage(data: cachedData) {
            return image
        } else {
            return try await fetchImage(url: url)
        }
    }
    
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let image = UIImage(data: data)
        
        saveToCache(url: url, response: response, data: data)
                
        return image
    }
    
    func saveToCache(url: URL, response: URLResponse, data: Data) {
        let request = URLRequest(url: url)
        let cachedURLResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedURLResponse, for: request)
    }
}

// ViewModel layer
class ViewModel: ObservableObject {
    
    private var networkSession: NetworkInterface
    private var imageRepo: ImageRepoInterface
    
    @Published var employees: [Employee]? = []
    
    init(networkSession: NetworkInterface = NetworkSession(), imageRepo: ImageRepoInterface = ImageRepo()) {
        self.networkSession = networkSession
        self.imageRepo = imageRepo
    }
    
    @MainActor
    func getAPIData() async throws {
        guard let url = URL(string: apiData) else {
            throw URLError(.badURL)
        }
        
        let responseData = try await networkSession.fetchData(url: url)
        let employeeResponse = try JSONDecoder().decode(EmployeeResponse.self, from: responseData)
        employees = employeeResponse.employees
    }
    
    @MainActor
    func getImage(_ url: URL) async throws -> UIImage {
        if let image = try await imageRepo.getImage(url: url) {
            return image
        } else {
            return UIImage(systemName: "person.crop.circle.badge.exclamationmark")!
        }
    }
}

////////////////////// TEST

struct MainList: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if let employees = viewModel.employees {
                List(employees) { employee in
                    MainCell(viewModel: viewModel, employee: employee)
                }
            }
        }
        .task {
            await processAPIData()
        }
        .refreshable {
            await processAPIData()
        }
    }
    
    func processAPIData() async {
        do {
            try await viewModel.getAPIData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct MainCell: View {
    
    @ObservedObject var viewModel: ViewModel
    let employee: Employee
    
    @State var image = UIImage()
    
    var body: some View {
        HStack {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(80 / 2)
            
            VStack(alignment: .leading) {
                Text(employee.fullName)
                    .font(.headline)
                Text(employee.biography)
                    .font(.caption)
            }
        }
        .task {
            do {
                image = try await viewModel.getImage(employee.imageURL)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(MainList())
