//
//  APIServiceTests.swift
//  UnitTesting
//

import XCTest
@testable import UnitTesting

final class APIServiceTests: XCTestCase {
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
    }
    
    override func tearDown() {
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: Fetch Users

    // pass some invalid url and assert that method completes with .failure(.invalidUrl)
    // use expectations
    func test_apiService_fetchUsers_whenInvalidUrl_completesWithError() {
        // TODO: Implement test
        
        
        // Arrange:
        let sut = makeSut()
        let expectation = self.expectation(description: "Invalid URL")
        var receivedResult: Result<[User],APIError>?
        
        sut.fetchUsers(urlString: ""){ result in
            receivedResult = result
            expectation.fulfill()
        }
        
       
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.invalidUrl))
        
    }

    // assert that method completes with .success(expectedUsers)
    func test_apiService_fetchUsers_whenValidSuccessfulResponse_completesWithSuccess() throws {
        let response = """
        [
            { "id": 1, "name": "John Doe", "username": "johndoe", "email": "johndoe@gmail.com" },
            { "id": 2, "name": "Jane Doe", "username": "johndoe", "email": "johndoe@gmail.com" }
        ]
        """.data(using: .utf8)
        mockURLSession.mockData = response
        
        
        let data = try XCTUnwrap(response)
        let expectedUsers = try JSONDecoder().decode([User].self, from: data)
        
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch User Succeeds")
        var receivedResult: Result<[User],APIError>?
        
        sut.fetchUsers(urlString: "https://example.com/users"){ result in
            receivedResult = result
            expectation.fulfill()
        }
        
        
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedResult, .success(expectedUsers))
        
        
    }

    // assert that method completes with .failure(.parsingError)
    func test_apiService_fetchUsers_whenInvalidSuccessfulResponse_completesWithFailure() {
        
        // TODO: Implement test
        
        let response = "Invalid JSON".data(using: .utf8)
        mockURLSession.mockData = response
        
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users fails with parsingError")
        var receivedResult: Result<[User],APIError>?
        
        sut.fetchUsers(urlString: "https://example.com/users"){ result in
            receivedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.parsingError))
        
    }

    // assert that method completes with .failure(.unexpected)
    func test_apiService_fetchUsers_whenError_completesWithFailure() {
        // TODO: Implement test
        
       
        mockURLSession.mockError = NSError(domain: "TestError", code: -1)
        
        let sut = makeSut()
        let expectation = self.expectation(description: "Fetch users fails with UnExpected Result")
        var receivedResult: Result<[User],APIError>?
        
        sut.fetchUsers(urlString: "https://example.com/users"){ result in
            receivedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.unexpected))
        
        
    }

    
    
    
    
    
    
    // MARK: Fetch Users Async

    // pass some invalid url and assert that method completes with .failure(.invalidUrl)
    func test_apiService_fetchUsersAsync_whenInvalidUrl_completesWithError() async {
        // TODO: Implement test
        
        
        // Arrange:
        let sut = makeSut()
        
        
        let result = await sut.fetchUsersAsync(urlString: "")
        XCTAssertEqual(result, .failure(.invalidUrl))
        
    }

    // TODO: Implement test
    // add other tests for fetchUsersAsync
    
    func test_apiService_fetchUsersAsync_whenValidSuccessfulResponse_completesWithSuccess() async throws{
        // TODO: Implement test
        
        let response = """
        [
            { "id": 1, "name": "John Doe", "username": "johndoe", "email": "johndoe@gmail.com" },
            { "id": 2, "name": "Jane Doe", "username": "johndoe", "email": "johndoe@gmail.com" }
        ]
        """.data(using: .utf8)
        mockURLSession.mockData = response
        
        let data = try XCTUnwrap(response)
        let expectedUsers = try JSONDecoder().decode([User].self, from: data)
        let sut = makeSut()
        var result = await sut.fetchUsersAsync(urlString: "https://example.com/users")
        
        XCTAssertEqual(result, .success(expectedUsers))
        
    }
    
    
    
    // assert that method completes with .failure(.parsingError)
    func test_apiService_fetchUsersAsync_whenInvalidSuccessfulResponse_completesWithFailure() async {
        
        let response = "Invalid JSON".data(using: .utf8)
        mockURLSession.mockData = response
        
        let sut = makeSut()
        var result = await sut.fetchUsersAsync(urlString: "https://example.com/users")
        
        XCTAssertEqual(result, .failure(.parsingError))
    
        
    }
    
    
    func test_apiService_fetchUsersAsync_whenError_completesWithFailure() async {
        
        mockURLSession.mockError = NSError(domain: "TestError", code: -1)
        
        let sut = makeSut()
        var result = await sut.fetchUsersAsync(urlString: "https://example.com/users")
        
        XCTAssertEqual(result, .failure(.unexpected))
    }


    private func makeSut() -> APIService {
        APIService(urlSession: mockURLSession)
    }
}
