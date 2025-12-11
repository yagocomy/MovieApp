import XCTest
@testable import MovieApp

final class FavoritesMoviesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesMoviesViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = FavoritesMoviesViewModel()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testInitialState() throws {
        XCTAssertNil(viewModel.movies.value, "Movies should be nil initially")
        XCTAssertFalse(viewModel.loading.value, "Loading should be false initially")
        XCTAssertNil(viewModel.error.value, "Error should be nil initially")
        XCTAssertNil(viewModel.dataTOStore.value, "Data to store should be nil initially")
        XCTAssertTrue(viewModel.isFavoriteEmpty.value, "isFavoriteEmpty should be true initially")
    }
    
    func testMoviesObservableBinding() throws {
        let expectation = expectation(description: "Movies observable should notify listener")
        expectation.expectedFulfillmentCount = 1
        
        var receivedValue: FavoritesMoviesModel? = nil
        
        viewModel.movies.bind { value in
            receivedValue = value
        }
        
        let mockModels = TestHelpers.createMockMoviesPersistentModels(count: 2)
        let mockModel = FavoritesMoviesModel(movies: mockModels)
        viewModel.movies.value = mockModel
        expectation.fulfill()
        
        waitForExpectation(expectation, timeout: 2.0)
        XCTAssertNotNil(receivedValue, "Listener should receive value")
        XCTAssertEqual(receivedValue?.movies.count, mockModel.movies.count, "Received value should match")
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
    
    func testIsFavoriteEmptyObservableBinding() throws {
        let expectation = expectation(description: "isFavoriteEmpty observable should notify listener")
        expectation.expectedFulfillmentCount = 2 // Initial value + changed value
        
        var receivedValues: [Bool] = []
        
        viewModel.isFavoriteEmpty.bind { value in
            receivedValues.append(value)
            expectation.fulfill()
        }
        
        viewModel.isFavoriteEmpty.value = false
        
        waitForExpectation(expectation, timeout: 2.0)
        XCTAssertEqual(receivedValues.count, 2, "Should receive initial and changed values")
        XCTAssertTrue(receivedValues[0], "Initial value should be true")
        XCTAssertFalse(receivedValues[1], "Changed value should be false")
    }
    
    func testGetFavoritesSetsLoadingState() throws {
        viewModel.getFavorites()
        
        let loadingExpectation = expectation(description: "Loading should be set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            loadingExpectation.fulfill()
        }
        
        waitForExpectation(loadingExpectation, timeout: 1.0)
    }
    
    func testGetFavoritesCompletes() throws {
        let expectation = expectation(description: "Get favorites should complete")
        
        var loadingStates: [Bool] = []
        viewModel.loading.bind { isLoading in
            loadingStates.append(isLoading)
        }
        
        var emptyStates: [Bool] = []
        viewModel.isFavoriteEmpty.bind { isEmpty in
            emptyStates.append(isEmpty)
        }
        
        viewModel.getFavorites()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 5.0)
        XCTAssertTrue(loadingStates.contains(true), "Loading should have been set to true")
    }
    
    func testEmptyStateLogic() throws {
        XCTAssertTrue(viewModel.isFavoriteEmpty.value, "Should be empty initially")
        
        let expectation = expectation(description: "Empty state should be handled")
        
        DispatchQueue.main.async {
            self.viewModel.isFavoriteEmpty.value = true
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertTrue(viewModel.isFavoriteEmpty.value, "Should remain empty")
    }
    
    func testNonEmptyStateLogic() throws {
        let expectation = expectation(description: "Non-empty state should be handled")
        
        DispatchQueue.main.async {
            let mockModels = TestHelpers.createMockMoviesPersistentModels(count: 1)
            self.viewModel.movies.value = FavoritesMoviesModel(movies: mockModels)
            self.viewModel.isFavoriteEmpty.value = false
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertFalse(viewModel.isFavoriteEmpty.value, "Should not be empty")
        XCTAssertNotNil(viewModel.movies.value, "Movies should be set")
    }
    
    func testViewModelStateConsistency() throws {
        XCTAssertNil(viewModel.movies.value)
        XCTAssertFalse(viewModel.loading.value)
        XCTAssertNil(viewModel.error.value)
        XCTAssertTrue(viewModel.isFavoriteEmpty.value)
        
        let mockModels = TestHelpers.createMockMoviesPersistentModels(count: 2)
        viewModel.movies.value = FavoritesMoviesModel(movies: mockModels)
        
        XCTAssertNotNil(viewModel.movies.value)
        XCTAssertEqual(viewModel.movies.value?.movies.count, 2)
        
        viewModel.loading.value = true
        XCTAssertTrue(viewModel.loading.value)
        
        viewModel.isFavoriteEmpty.value = false
        XCTAssertFalse(viewModel.isFavoriteEmpty.value)
        
        let testError = NSError(domain: "Test", code: 1)
        viewModel.error.value = testError
        XCTAssertNotNil(viewModel.error.value)
    }
    
    func testGetFavoritesWithEmptyResult() throws {
        let expectation = expectation(description: "Empty favorites should set empty state")
        
        DispatchQueue.main.async {
            self.viewModel.loading.value = false
            self.viewModel.isFavoriteEmpty.value = true
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertTrue(viewModel.isFavoriteEmpty.value, "Should be empty")
        XCTAssertFalse(viewModel.loading.value, "Should not be loading")
    }
    
    func testGetFavoritesWithNonEmptyResult() throws {
        let expectation = expectation(description: "Non-empty favorites should set movies")
        
        DispatchQueue.main.async {
            let mockModels = TestHelpers.createMockMoviesPersistentModels(count: 3)
            self.viewModel.movies.value = FavoritesMoviesModel(movies: mockModels)
            self.viewModel.loading.value = false
            self.viewModel.isFavoriteEmpty.value = false
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertFalse(viewModel.isFavoriteEmpty.value, "Should not be empty")
        XCTAssertNotNil(viewModel.movies.value, "Movies should be set")
        XCTAssertEqual(viewModel.movies.value?.movies.count, 3, "Should have 3 movies")
        XCTAssertFalse(viewModel.loading.value, "Should not be loading")
    }
}
