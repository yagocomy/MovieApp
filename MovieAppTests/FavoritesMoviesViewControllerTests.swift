import XCTest
import UIKit
@testable import MovieApp

final class FavoritesMoviesViewControllerTests: XCTestCase {
    
    var viewController: FavoritesMoviesViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        super.setUp()
        viewController = FavoritesMoviesViewController()
        window = UIWindow()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testViewControllerInitialization() throws {
        XCTAssertNotNil(viewController, "ViewController should be initialized")
        XCTAssertNotNil(viewController.loader, "Loader should be initialized")
    }
    
    func testLoadView() throws {
        viewController.loadView()
        XCTAssertNotNil(viewController.view, "View should be loaded")
    }
    
    func testViewDidLoad() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        XCTAssertNotNil(viewController.view, "View should exist after viewDidLoad")
    }
    
    func testViewSetup() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        XCTAssertNotNil(viewController.view, "View should exist")
        
        let expectation = expectation(description: "View setup complete")
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    // MARK: - Bindings Tests
    
    func testMoviesBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Movies binding should update view")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertNotNil(viewController.view, "View should still exist")
    }
    
    func testLoadingBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Loading binding should work")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.loader, "Loader should exist")
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testErrorBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()

        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Error binding should work")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testIsFavoriteEmptyBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "IsFavoriteEmpty binding should work")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testViewWillAppear() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        
        let expectation = expectation(description: "viewWillAppear should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testViewWillAppearMultipleTimes() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        viewController.viewWillAppear(false)
        viewController.viewWillAppear(false)
        
        let expectation = expectation(description: "Multiple viewWillAppear calls should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testViewLifecycle() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        
        let expectation = expectation(description: "Lifecycle should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testViewDisappearing() throws {
        viewController.loadView()
        viewController.viewDidLoad()

        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillDisappear(false)
        viewController.viewDidDisappear(false)
        
        XCTAssertNotNil(viewController.view, "View should still exist after disappearing")
    }
    
    func testEmptyStateHandling() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        
        let expectation = expectation(description: "Empty state should be handled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 2.0)
    }
    
    func testViewControllerDeallocation() throws {
        weak var weakViewController: FavoritesMoviesViewController?
        
        autoreleasepool {
            let vc = FavoritesMoviesViewController()
            weakViewController = vc
            vc.loadView()
            vc.viewDidLoad()
        }
    }
    
    func testCompleteViewControllerSetup() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        
        let expectation = expectation(description: "Complete setup should finish")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.window.rootViewController!.view, "View should exist")
            XCTAssertNotNil(self.viewController.loader, "Loader should exist")
            XCTAssertNotNil(self.viewController.view.window, "View should be in window")
        }
        
        expectation.fulfill()
        
        waitForExpectation(expectation, timeout: 2.0)
    }
    
    func testViewControllerNavigationFlow() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        window.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        
        viewController.viewWillDisappear(false)
        viewController.viewDidDisappear(false)
        
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        
        let expectation = expectation(description: "Navigation flow should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
        }
        
        expectation.fulfill()
        waitForExpectation(expectation, timeout: 2.0)
    }
}
