import XCTest

extension XCUIApplication {
    
    /// Waits for the tab bar to appear and be ready for interaction
    func waitForTabBar(timeout: TimeInterval = 10) -> Bool {
        return tabBars.firstMatch.waitForExistence(timeout: timeout)
    }
    
    /// Navigates to the Movies tab
    func navigateToMoviesTab() {
        let moviesTab = tabBars.buttons["Movies"]
        if moviesTab.waitForExistence(timeout: 5) {
            moviesTab.tap()
        }
    }
    
    /// Navigates to the Favorites tab
    func navigateToFavoritesTab() {
        let favoritesTab = tabBars.buttons["Favorites"]
        if favoritesTab.waitForExistence(timeout: 5) {
            favoritesTab.tap()
        }
    }
    
    /// Waits for the movies table to load
    func waitForMoviesTable(timeout: TimeInterval = 15) -> Bool {
        return tables.firstMatch.waitForExistence(timeout: timeout)
    }
    
    /// Gets the first movie cell if available
    func getFirstMovieCell() -> XCUIElement? {
        let tableView = tables.firstMatch
        guard tableView.waitForExistence(timeout: 15) else { return nil }
        
        let cells = tableView.cells
        return cells.count > 0 ? cells.element(boundBy: 0) : nil
    }
    
    /// Clears the search bar text
    func clearSearchBar() {
        let searchBar = searchFields.firstMatch
        guard searchBar.exists else { return }
        
        searchBar.tap()
        
        // Try to find clear button
        let clearButton = buttons["Clear text"]
        if clearButton.exists {
            clearButton.tap()
        } else {
            // Select all and delete
            if let selectAll = menuItems["Select All"].firstMatch as? XCUIElement,
               selectAll.waitForExistence(timeout: 1) {
                selectAll.tap()
                keys["delete"].tap()
            }
        }
    }
}

extension XCUIElement {
    
    /// Waits for element to exist and be hittable
    func waitForHittable(timeout: TimeInterval = 5) -> Bool {
        return waitForExistence(timeout: timeout) && isHittable
    }
    
    /// Scrolls to element if needed (for table views)
    func scrollToElement(in scrollView: XCUIElement) {
        guard !isHittable else { return }
        
        let startCoordinate = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endCoordinate = startCoordinate.withOffset(CGVector(dx: 0, dy: -200))
        startCoordinate.press(forDuration: 0.1, thenDragTo: endCoordinate)
    }
}
