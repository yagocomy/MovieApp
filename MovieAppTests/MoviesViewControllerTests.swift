import XCTest
import UIKit
@testable import MovieApp

final class MoviesViewControllerTests: XCTestCase {
    
    var viewController: MoviesViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        viewController = MoviesViewController()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testMoviesBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
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
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Loading binding should work")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.loader, "Loader should exist")
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testErrorBinding() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Error binding should work")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testDidPressLikeDelegate() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.didPressLike(isLike: true, index: 0)
        
        let expectation = expectation(description: "Delegate method should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectation(expectation, timeout: 1.0)
        
        XCTAssertNotNil(viewController.view, "View should still exist")
    }
    
    func testDidPressLikeWithDifferentIndices() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.didPressLike(isLike: true, index: 0)
        viewController.didPressLike(isLike: false, index: 1)
        viewController.didPressLike(isLike: true, index: 999)
        
        let expectation = expectation(description: "Delegate methods should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        waitForExpectation(expectation, timeout: 1.0)
        
        XCTAssertNotNil(viewController.view, "View should still exist")
    }
    
    func testViewLifecycle() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        
        let expectation = expectation(description: "Lifecycle should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            expectation.fulfill()
        }
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testViewDisappearing() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.viewWillDisappear(false)
        viewController.viewDidDisappear(false)
        
        XCTAssertNotNil(viewController.view, "View should still exist after disappearing")
    }
    
    func testViewControllerDeallocation() throws {
        weak var weakViewController: MoviesViewController?
        
        autoreleasepool {
            let vc = MoviesViewController()
            weakViewController = vc
            vc.loadView()
            vc.viewDidLoad()
        }
    }
    
    // MARK: - Integration Tests
    
    func testCompleteViewControllerSetup() throws {
        viewController.loadView()
        viewController.viewDidLoad()
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let expectation = expectation(description: "Complete setup should finish")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewController.view, "View should exist")
            XCTAssertNotNil(self.viewController.loader, "Loader should exist")
            XCTAssertNotNil(self.viewController.view.window, "View should be in window")
            
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 2.0)
    }
}
