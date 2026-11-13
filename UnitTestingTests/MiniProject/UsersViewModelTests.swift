//
//  UsersViewModelTests.swift
//  UnitTesting
//

@testable import UnitTesting
import XCTest

class UsersViewModelTests: XCTestCase {
    var mockService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    // assert that sut.fetchUsers(completion: {}) calls appropriate method of api service
    // use XCAssertEqual, fetchUsersCallsCount
    func test_viewModel_whenFetchUsers_callsApiService() {
        let sut = makeSut()
        sut.fetchUsers{}
        XCTAssertEqual(mockService.fetchUsersCallsCount, 1)
        
        
    }

    // assert that the passed url to api service is correct
    func test_viewModel_whenFetchUsers_passesCorrectUrlToApiService() {
        // TODO: Implement test
        
        let sut = makeSut()
        sut.fetchUsers{}
        XCTAssertEqual(mockService.fetchUsersPassedUrl, "https://jsonplaceholder.typicode.com/users")
    }

    // assert that view model users are updated and error message is nil
    func test_viewModel_fetchUsers_whenSuccess_updatesUsers() {
        
        
        let expectedUsers = [
            User(id: 1, name: "name", username: "surname", email: "user@email.com")
        ]
        mockService.fetchUsersResult = .success(expectedUsers)
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users updates users on main queue")
        sut.fetchUsers {
            expectation.fulfill()
        }

        XCTAssertEqual(sut.users, expectedUsers)
        XCTAssertNil(sut.errorMessage)
    }

    // assert that view model error message is "Unexpected error"
    func test_viewModel_fetchUsers_whenInvalidUrl_updatesErrorMessage() {
        // TODO: Implement test
        
        
        mockService.fetchUsersResult = .failure(.invalidUrl)
        let sut = makeSut()
        let expectation = self.expectation(description: "Invalid URL")
        sut.fetchUsers {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.errorMessage, "Unexpected error")
        XCTAssertTrue(sut.users.isEmpty)
    }

    // assert that view model error message is "Unexpected error"
    func test_viewModel_fetchUsers_whenUnexectedFailure_updatesErrorMessage() {
        // TODO: Implement test
        
        mockService.fetchUsersResult = .failure(.unexpected)
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users sets error message on unexpected error")
        sut.fetchUsers {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.errorMessage, "Unexpected error")
        XCTAssertTrue(sut.users.isEmpty)
    }

    // assert that view model error message is "Error parsing JSON"
    func test_viewModel_fetchUsers_whenParsingFailure_updatesErrorMessage() {
        // TODO: Implement test
        
        mockService.fetchUsersResult = .failure(.parsingError)
        
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users sets error message on parsingError")
        sut.fetchUsers {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.errorMessage, "Error parsing JSON")
        XCTAssertTrue(sut.users.isEmpty)
    }

    // fetch users with successful result and after calling clear() assert users are empty
    func test_viewModel_clearUsers() {
        // TODO: Implement test
        
        
        let expectedUsers = [
            User(id: 1, name: "name", username: "surname", email: "user@email.com")
        ]
        
        mockService.fetchUsersResult = .success(expectedUsers)
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users updates users on main queue")
        sut.fetchUsers {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.users, expectedUsers)
        
        
        XCTAssertFalse(sut.users.isEmpty)
        sut.clearUsers()
        XCTAssertTrue(sut.users.isEmpty)
        
    }

    private func makeSut() -> UsersViewModel {
        UsersViewModel(apiService: mockService)
    }
}
