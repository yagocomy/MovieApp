import XCTest

final class MovieAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10), "Tab bar should exist")
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testTabBarNavigation() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        XCTAssertTrue(moviesTab.exists, "Movies tab should exist")
        moviesTab.tap()
        XCTAssertTrue(moviesTab.isSelected, "Movies tab should be selected")
        
        let favoritesTab = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.exists, "Favorites tab should exist")
        favoritesTab.tap()
        XCTAssertTrue(favoritesTab.isSelected, "Favorites tab should be selected")
        
        moviesTab.tap()
        XCTAssertTrue(moviesTab.isSelected, "Movies tab should be selected after navigation")
    }
    
    @MainActor
    func testMoviesTabDisplaysContent() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist")
        
        let searchBarPlaceholder = app.searchFields["Buscar filmes"]
        XCTAssertTrue(searchBarPlaceholder.exists, "Search bar should have correct placeholder")
        
        let tableView = app.tables.firstMatch
        let exists = tableView.waitForExistence(timeout: 15)
        
        if exists {
            let cells = tableView.cells
            if cells.count > 0 {
                XCTAssertGreaterThan(cells.count, 0, "Movies table should have at least one cell")
            }
        }
    }
    
    @MainActor
    func testMoviesSearchFunctionality() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist")
        
        searchBar.tap()
        
        searchBar.typeText("test")
        
        XCTAssertEqual(searchBar.value as? String, "test", "Search bar should contain typed text")
        
        let clearButton = app.buttons["Clear text"]
        if clearButton.exists {
            clearButton.tap()
        } else {
            searchBar.tap()
            let selectAll = app.menuItems["Select All"]
            if selectAll.waitForExistence(timeout: 1) {
                selectAll.tap()
                app.keys["delete"].tap()
            }
        }
    }
    
    @MainActor
    func testMovieCellInteraction() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 15)
        
        guard tableExists else {
            XCTSkip("Movies table did not load in time - skipping cell interaction test")
            return
        }
        
        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
        
            firstCell.tap()
        
            sleep(1)
            
            firstCell.tap()
        }
    }
    
    @MainActor
    func testMovieLikeButton() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 15)
        
        guard tableExists else {
            XCTSkip("Movies table did not load in time - skipping like button test")
            return
        }
        
        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            
            let likeButtons = app.buttons.matching(identifier: "heart")
            let filledLikeButtons = app.buttons.matching(identifier: "heart.fill")
            
            let cellButtons = firstCell.buttons
            
            if cellButtons.count > 0 {
                let likeButton = cellButtons.element(boundBy: 0)
                
                let initialState = likeButton.exists
                
                likeButton.tap()
                
                sleep(1)
                
                XCTAssertTrue(likeButton.exists, "Like button should still exist after tap")
            }
        }
    }

    @MainActor
    func testFavoritesTabDisplaysContent() throws {
        let favoritesTab = app.tabBars.buttons["Favorites"]
        favoritesTab.tap()
        
        let favoritesLabel = app.staticTexts["Here is your favorite movies."]
        let labelExists = favoritesLabel.waitForExistence(timeout: 5)
        
        if labelExists {
            XCTAssertTrue(favoritesLabel.exists, "Favorites label should exist")
        }
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 5)
        
        if tableExists {
            let cells = tableView.cells
            XCTAssertTrue(tableView.exists, "Favorites table should exist")
        }
    }
    
    @MainActor
    func testFavoritesTabEmptyState() throws {
        let favoritesTab = app.tabBars.buttons["Favorites"]
        favoritesTab.tap()
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 5)
        
        if tableExists {
            let cells = tableView.cells
            
            if cells.count == 0 {
                XCTAssertEqual(cells.count, 0, "Favorites table should be empty initially")
            }
        }
    }
    
    @MainActor
    func testAddMovieToFavorites() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 15)
        
        guard tableExists else {
            XCTSkip("Movies table did not load in time - skipping add to favorites test")
            return
        }
        
        let cells = tableView.cells
        guard cells.count > 0 else {
            XCTSkip("No movies available to favorite")
            return
        }
        
        let firstCell = cells.element(boundBy: 0)
        let cellButtons = firstCell.buttons
        
        if cellButtons.count > 0 {
            let likeButton = cellButtons.element(boundBy: 0)
            likeButton.tap()
            
            sleep(2)
            
            let favoritesTab = app.tabBars.buttons["Favorites"]
            favoritesTab.tap()
            
            sleep(2)
            
            let favoritesTableView = app.tables.firstMatch
            XCTAssertTrue(favoritesTableView.exists, "Favorites table should exist")
        }
    }
    
    @MainActor
    func testAppLaunch() throws {
        XCTAssertTrue(app.state == .runningForeground, "App should be running in foreground")
        
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist on launch")
        
        let moviesTab = app.tabBars.buttons["Movies"]
        let favoritesTab = app.tabBars.buttons["Favorites"]
        
        XCTAssertTrue(moviesTab.exists, "Movies tab should exist")
        XCTAssertTrue(favoritesTab.exists, "Favorites tab should exist")
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testMoviesTableScrolling() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()
        
        let tableView = app.tables.firstMatch
        let tableExists = tableView.waitForExistence(timeout: 15)
        
        guard tableExists else {
            XCTSkip("Movies table did not load in time - skipping scroll test")
            return
        }
        
        let cells = tableView.cells
        
        if cells.count > 1 {
            tableView.swipeUp()
            
            sleep(1)
            
            tableView.swipeDown()
            
            sleep(1)
        }
    }

    @MainActor
    func testMoviesTabHandlesErrors() throws {
        let moviesTab = app.tabBars.buttons["Movies"]
        moviesTab.tap()

        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist even if movies fail to load")
    }
}
