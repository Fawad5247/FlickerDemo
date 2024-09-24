//
//  FlickrViewModelTests.swift
//  FlickerTests
//
//  Created by Fawad Akhtar on 09/24/2024.
//

import XCTest
@testable import Flicker

class FlickrViewModelTests: XCTestCase {
    
    func testSearchWithEmptySearchTerm() {
        let viewModel = FlickrViewModel()
        
        viewModel.searchImages(for: "")
        
        XCTAssertTrue(viewModel.images.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchWithValidSearchTerm() {
        let viewModel = FlickrViewModel()
        let expectation = XCTestExpectation(description: "Search returns images")
        
        viewModel.searchImages(for: "porcupine")
        
        XCTAssertTrue(viewModel.isLoading) // While loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(viewModel.isLoading) // Once loaded
            XCTAssertFalse(viewModel.images.isEmpty) // Check images are loaded
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSearchWithInvalidURL() {
        let viewModel = FlickrViewModel()
        let invalidSearchTerm = "invalid url term %^&*("
        
        viewModel.searchImages(for: invalidSearchTerm)
        
        XCTAssertTrue(viewModel.images.isEmpty)
    }
    
    func testSearchFailureWithNetworkError() {
        // Mock URLSession to simulate network error
        let viewModel = FlickrViewModel()
        let expectation = XCTestExpectation(description: "Network error handled gracefully")
        
        viewModel.searchImages(for: "errorcase")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.images.isEmpty) // No images loaded due to error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
