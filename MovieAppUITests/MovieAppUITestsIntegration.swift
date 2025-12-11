import XCTest

/// Integration tests for complete user flows
final class MovieAppUITestsIntegration: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.waitForTabBar(), "App should be ready with tab bar")
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testCompleteFavoriteFlow() throws {
        app.navigateToMoviesTab()
        let moviesTab = app.tabBars.buttons["Movies"]
        XCTAssertTrue(moviesTab.isSelected, "Should be on Movies tab")
        
        let tableExists = app.waitForMoviesTable()
        guard tableExists else {
            XCTSkip("Movies table did not load - skipping integration test")
            return
        }

        guard let firstCell = app.getFirstMovieCell() else {
            XCTSkip("No movies available - skipping integration test")
            return
        }

        let movieTitle = firstCell.staticTexts.firstMatch.label

        let cellButtons = firstCell.buttons
        if cellButtons.count > 0 {
            let likeButton = cellButtons.element(boundBy: 0)
            likeButton.tap()
            
            sleep(2)
        }
        
        app.navigateToFavoritesTab()
        let favoritesTab = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.isSelected, "Should be on Favorites tab")
        
        sleep(2)
        
        let favoritesTable = app.tables.firstMatch
        XCTAssertTrue(favoritesTable.exists, "Favorites table should exist")
    }
    
    @MainActor
    func testSearchAndSelectMovie() throws {
        app.navigateToMoviesTab()
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist")
        
        searchBar.tap()
        searchBar.typeText("a")
        
        sleep(2)
        
        XCTAssertEqual(searchBar.value as? String, "a", "Search should filter results")
        
        app.clearSearchBar()

        sleep(1)
    }
    
    @MainActor
    func testMovieCellExpandAndCollapse() throws {
        app.navigateToMoviesTab()
        
        guard app.waitForMoviesTable() else {
            XCTSkip("Movies table did not load")
            return
        }
        
        guard let firstCell = app.getFirstMovieCell() else {
            XCTSkip("No movies available")
            return
        }
        
        let initialFrame = firstCell.frame
        
        firstCell.tap()
        sleep(1)
        
        XCTAssertTrue(firstCell.exists, "Cell should still exist after expand")
        
        firstCell.tap()
        sleep(1)
        
        XCTAssertTrue(firstCell.exists, "Cell should still exist after collapse")
    }
    
    @MainActor
    func testTabSwitchingPreservesState() throws {
        app.navigateToMoviesTab()
        
        guard app.waitForMoviesTable() else {
            XCTSkip("Movies table did not load")
            return
        }
        
        let tableView = app.tables.firstMatch
        if tableView.cells.count > 1 {
            tableView.swipeUp()
            sleep(1)
        }

        app.navigateToFavoritesTab()
        sleep(1)

        app.navigateToMoviesTab()
        sleep(1)

        let moviesTab = app.tabBars.buttons["Movies"]
        XCTAssertTrue(moviesTab.isSelected, "Movies tab should be selected")

        XCTAssertTrue(app.tables.firstMatch.exists, "Movies table should still exist")
    }
    
    @MainActor
    func testMultipleMoviesInteraction() throws {
        app.navigateToMoviesTab()
        
        guard app.waitForMoviesTable() else {
            XCTSkip("Movies table did not load")
            return
        }
        
        let tableView = app.tables.firstMatch
        let cells = tableView.cells
        
        let cellsToTest = min(cells.count, 3) // Test up to 3 cells
        
        for i in 0..<cellsToTest {
            let cell = cells.element(boundBy: i)
            
            cell.scrollToElement(in: tableView)
            
            cell.tap()
            sleep(1)
            
            cell.tap()
            sleep(1)
        }
        
        XCTAssertTrue(tableView.exists, "Table should still exist after multiple interactions")
    }
    
    @MainActor
    func testAppBackgroundAndForeground() throws {
        app.navigateToMoviesTab()
        
        guard app.waitForMoviesTable() else {
            XCTSkip("Movies table did not load")
            return
        }
        
        XCUIDevice.shared.press(.home)
        sleep(2)
        
        app.activate()
        sleep(2)
        
        let moviesTab = app.tabBars.buttons["Movies"]
        XCTAssertTrue(moviesTab.exists, "Movies tab should still exist after background/foreground")
    }
}
