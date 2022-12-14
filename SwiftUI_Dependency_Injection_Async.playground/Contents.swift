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

// ViewModel layer
class ViewModel: ObservableObject {
    
    private var networkSession: NetworkInterface
    
    @Published var employees: [Employee]? = []
    
    init(networkSession: NetworkInterface = NetworkSession()) {
        self.networkSession = networkSession
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
}

////////////////////// TEST

struct MainList: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if let employees = viewModel.employees {
                List(employees) { employee in
                    Text(employee.fullName)
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

PlaygroundPage.current.setLiveView(MainList())
