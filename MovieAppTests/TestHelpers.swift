import Foundation
import XCTest
@testable import MovieApp

/// Helper utilities for unit tests
struct TestHelpers {
    
    /// Creates a mock MoviesRequestModel for testing
    static func createMockMoviesRequestModel() -> MoviesRequestModel {
        let mockResult = Results(
            adult: false,
            backdropPath: "/backdrop.jpg",
            genreIDS: [1, 2, 3],
            id: 123,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            overview: "This is a test movie overview",
            popularity: 8.5,
            posterPath: "/poster.jpg",
            releaseDate: "2024-01-01",
            title: "Test Movie",
            video: false,
            voteAverage: 8.5,
            voteCount: 1000
        )
        
        return MoviesRequestModel(
            page: 1,
            results: [mockResult],
            totalPages: 10,
            totalResults: 200
        )
    }
    
    /// Creates a mock MoviesPersistentModel for testing
    static func createMockMoviesPersistentModel() -> MoviesPersistentModel {
        let mockResult = ResultPersistent(
            adult: false,
            backdropPath: "/backdrop.jpg",
            genreIDS: [1, 2, 3],
            id: 123,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            overview: "This is a test movie overview",
            popularity: 8.5,
            posterPath: "/poster.jpg",
            releaseDate: "2024-01-01",
            title: "Test Movie",
            video: false,
            voteAverage: 8.5,
            voteCount: 1000
        )
        
        return MoviesPersistentModel(
            id: UUID().uuidString,
            page: 1,
            results: mockResult,
            totalPages: 10,
            totalResults: 200
        )
    }
    
    /// Creates multiple mock MoviesPersistentModel instances
    static func createMockMoviesPersistentModels(count: Int) -> [MoviesPersistentModel] {
        return (0..<count).map { index in
            let mockResult = ResultPersistent(
                adult: false,
                backdropPath: "/backdrop\(index).jpg",
                genreIDS: [1, 2, 3],
                id: 123 + index,
                originalLanguage: "en",
                originalTitle: "Test Movie \(index)",
                overview: "This is test movie \(index) overview",
                popularity: 8.5 + Double(index),
                posterPath: "/poster\(index).jpg",
                releaseDate: "2024-01-\(String(format: "%02d", index + 1))",
                title: "Test Movie \(index)",
                video: false,
                voteAverage: 8.5 + Double(index),
                voteCount: 1000 + index
            )
            
            return MoviesPersistentModel(
                id: UUID().uuidString,
                page: 1,
                results: mockResult,
                totalPages: 10,
                totalResults: 200
            )
        }
    }
}

/// XCTestCase extension for async testing helpers
extension XCTestCase {
    
    /// Waits for an expectation with a timeout
    func waitForExpectation(
        _ expectation: XCTestExpectation,
        timeout: TimeInterval = 5.0,
        description: String = "Expectation timeout"
    ) {
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, description)
    }
    
    /// Creates an expectation that can be fulfilled after async operations
    func expectations(description: String) -> XCTestExpectation {
        return expectation(description: description)
    }
}
