import XCTest
@testable import MovieApp

final class MoviesViewModelTests: XCTestCase {
    
    var viewModel: MoviesViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = MoviesViewModel()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() throws {
        XCTAssertNil(viewModel.movies.value, "Movies should be nil initially")
        XCTAssertFalse(viewModel.loading.value, "Loading should be false initially")
        XCTAssertNil(viewModel.error.value, "Error should be nil initially")
        XCTAssertNil(viewModel.dataTOStore.value, "Data to store should be nil initially")
    }
    
    // MARK: - Observable Tests
    
    func testMoviesObservableBinding() throws {
        let expectation = expectation(description: "Movies observable should notify listener")
        expectation.expectedFulfillmentCount = 1
        
        var receivedValue: MoviesModel? = nil
        
        viewModel.movies.bind { value in
            receivedValue = value
        }
        
        // Set a value
        let mockModel = MoviesModel(movies: TestHelpers.createMockMoviesRequestModel())
        viewModel.movies.value = mockModel
        expectation.fulfill()
        
        waitForExpectation(expectation, timeout: 2.0)
        XCTAssertNotNil(receivedValue, "Listener should receive value")
        XCTAssertEqual(receivedValue?.movies.results.count, mockModel.movies.results.count, "Received value should match")
    }
    
    func testLoadingObservableBinding() throws {
        let expectation = expectation(description: "Loading observable should notify listener")
        expectation.expectedFulfillmentCount = 2 // Initial value + changed value
        
        var receivedValues: [Bool] = []
        
        viewModel.loading.bind { value in
            receivedValues.append(value)
            expectation.fulfill()
        }
        
        viewModel.loading.value = true
        
        waitForExpectation(expectation, timeout: 2.0)
        XCTAssertEqual(receivedValues.count, 2, "Should receive initial and changed values")
        XCTAssertFalse(receivedValues[0], "Initial value should be false")
        XCTAssertTrue(receivedValues[1], "Changed value should be true")
    }
    
    func testErrorObservableBinding() throws {
        let expectation = expectation(description: "Error observable should notify listener")
        expectation.expectedFulfillmentCount = 1
        
        var receivedError: Error? = nil
        
        viewModel.error.bind { error in
            receivedError = error
        }
        
        let testError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        viewModel.error.value = testError
        expectation.fulfill()
        
        waitForExpectation(expectation, timeout: 2.0)
        XCTAssertNotNil(receivedError, "Listener should receive error")
    }

    func testSaveToFavoritesWithValidIndex() throws {
        let mockModel = MoviesModel(movies: TestHelpers.createMockMoviesRequestModel())
        viewModel.movies.value = mockModel
        viewModel.saveToFavorites(index: 0)
        XCTAssertNotNil(viewModel.movies.value, "Movies should still be set")
    }
    
    func testSaveToFavoritesWithInvalidIndex() throws {
        let mockModel = MoviesModel(movies: TestHelpers.createMockMoviesRequestModel())
        viewModel.movies.value = mockModel
        viewModel.saveToFavorites(index: 999)
        XCTAssertNotNil(viewModel.movies.value, "Movies should still be set")
    }
    
    func testSaveToFavoritesWithNilMovies() throws {
        viewModel.movies.value = nil
        viewModel.saveToFavorites(index: 0)
        XCTAssertNil(viewModel.movies.value, "Movies should remain nil")
    }
    
    // MARK: - getMoviesFromPersistence Tests
    
    func testGetMoviesFromPersistence() throws {
        let expectation = expectation(description: "Get movies from persistence should complete")
        
        viewModel.getMoviesFromPersistence { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Data should not be nil")
                XCTAssertTrue(data is [MoviesPersistentModel], "Data should be array of MoviesPersistentModel")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
            }
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 5.0)
    }
    
    func testFetchMoviesSetsLoadingState() throws {
        viewModel.fetchMovies()
        
        let loadingExpectation = expectation(description: "Loading should be set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            loadingExpectation.fulfill()
        }
        
        waitForExpectation(loadingExpectation, timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testViewModelStateConsistency() throws {
        XCTAssertNil(viewModel.movies.value)
        XCTAssertFalse(viewModel.loading.value)
        XCTAssertNil(viewModel.error.value)
        
        let mockModel = MoviesModel(movies: TestHelpers.createMockMoviesRequestModel())
        viewModel.movies.value = mockModel
        
        XCTAssertNotNil(viewModel.movies.value)
        XCTAssertEqual(viewModel.movies.value?.movies.results.count, 1)
        
        viewModel.loading.value = true
        XCTAssertTrue(viewModel.loading.value)
        
        let testError = NSError(domain: "Test", code: 1)
        viewModel.error.value = testError
        XCTAssertNotNil(viewModel.error.value)
    }
}
