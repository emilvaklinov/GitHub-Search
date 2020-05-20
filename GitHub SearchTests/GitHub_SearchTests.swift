//
//  GitHub_SearchTests.swift
//  GitHub SearchTests
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import XCTest
@testable import GitHub_Search

class MockURLSession: URLSession {
    
    private let mockTask: MockTask
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let taskError: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.taskError = error
    }
    
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?(self.data, self.urlResponse, self.taskError)
        }
    }
}


class GitHub_SearchTests: XCTestCase {

    var sut = APIManager?.self
    override func tearDown() {
       
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    

}
