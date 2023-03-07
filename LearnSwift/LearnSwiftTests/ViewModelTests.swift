//
//  ViewModelTests.swift
//  LearnSwiftTests
//
//  Created by James Layton on 3/6/23.
//

import XCTest

final class ViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAPIData_WithUrlString_ReturnError() async {
        // Arrange
        let sampleUrlString = "http://bad url"
        let viewModel = ViewModel()
        
        var errorResult: Error?
        
        // Act
        do {
            try await viewModel.getAPIData(urlString: sampleUrlString)
        } catch let error {
            errorResult = error
        }
        
        // Assert
        XCTAssertNotNil(errorResult)
    }
    
    func testGetAPIData_WithUrlString_ReturnErrorData() async {
        // Arrange
        let sampleUrlString = "failedUrl"
        let viewModel = ViewModel(networkSession: MockNetworkSession())
        
        var errorResult: Error?
        
        // Act
        do {
            try await viewModel.getAPIData(urlString: sampleUrlString)
        } catch let error {
            errorResult = error
        }
        
        // Assert
        XCTAssertNotNil(errorResult)
    }
    
    func testGetAPIData_WithUrlString_ReturnData() async {
        // Arrange
        let sampleUrlString = "successUrl"
        let viewModel = ViewModel(networkSession: MockNetworkSession())
        
        var errorResult: Error?
        
        // Act
        do {
            try await viewModel.getAPIData(urlString: sampleUrlString)
        } catch let error {
            errorResult = error
        }
        
        // Assert
        XCTAssertNil(errorResult)
        XCTAssertTrue(viewModel.items.count > 0)
        XCTAssertEqual(viewModel.items[0].name, "Apple")
    }
}
