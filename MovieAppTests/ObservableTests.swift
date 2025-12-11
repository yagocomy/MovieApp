import XCTest
@testable import MovieApp

final class ObservableTests: XCTestCase {
    var observableText: Observable<String?>!
    var observableValue: Observable<Int>!
    var observableBool: Observable<Bool>!
    var observableComplexType: Observable<AnyObject>!

    override func setUp() {
        super.setUp()
        observableText = Observable("test")
        observableValue = Observable(0)
        observableBool = Observable(false)
        observableComplexType = Observable(NSObject())
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testInitializationWithValue() throws {
        XCTAssertEqual(observableText.value, "test", "Observable should initialize with provided value")
    }
    
    func testInitializationWithNil() throws {
        observableText.value = nil
        XCTAssertNil(observableText.value, "Observable should initialize with nil")
    }
    
    func testInitializationWithInt() throws {
        observableValue.value = 42
        XCTAssertEqual(observableValue.value, 42, "Observable should work with Int")
    }
    
    func testInitializationWithBool() throws {
        observableBool.value = true
        XCTAssertTrue(observableBool.value, "Observable should work with Bool")
    }
    
    // MARK: - Value Setting Tests
    
    func testSettingValue() throws {
        observableText.value = "initial"
        observableText.value = "updated"
        XCTAssertEqual(observableText.value, "updated", "Observable should update value")
    }
    
    func testSettingValueMultipleTimes() throws {
        observableValue.value = 1
        observableValue.value = 2
        observableValue.value = 3
        XCTAssertEqual(observableValue.value, 3, "Observable should hold latest value")
    }
    
    // MARK: - Binding Tests
    
    func testBindingIsCalledOnInitialValue() throws {
        let expectation = expectation(description: "Binding should be called with initial value")
        
        observableText.value = "initial"
        
        observableText.bind { value in
            XCTAssertEqual(value, "initial", "Binding should receive initial value")
        }
        
        expectation.fulfill()
        
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testBindingIsCalledOnValueChange() throws {
        let expectation = expectation(description: "Binding should be called on value change")
        expectation.expectedFulfillmentCount = 2 // Initial + changed
        
        var receivedValues: [String] = []
        
        observableText.value = "initial"
        
        observableText.bind { value in
            receivedValues.append(value ?? "")
            expectation.fulfill()
        }
        
        observableText.value = "updated"
        
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertEqual(receivedValues.count, 2, "Binding should be called twice")
        XCTAssertEqual(receivedValues[0], "initial", "First value should be initial")
        XCTAssertEqual(receivedValues[1], "updated", "Second value should be updated")
    }
    
    func testBindingIsCalledMultipleTimes() throws {
        let expectation = expectation(description: "Binding should be called multiple times")
        expectation.expectedFulfillmentCount = 4 // Initial + 3 changes
        
        var callCount = 0
        
        observableValue.value = 0
        observableValue.bind { _ in
            callCount += 1
            expectation.fulfill()
        }
        
        observableValue.value = 1
        observableValue.value = 2
        observableValue.value = 3
        
        waitForExpectation(expectation, timeout: 1.0)
        XCTAssertEqual(callCount, 4, "Binding should be called 4 times")
    }
    
    func testBindingWithNilValue() throws {
        let expectation = expectation(description: "Binding should handle nil values")
        
        observableText.value = nil
        observableText.bind { value in
            XCTAssertNil(value, "Binding should receive nil")
            expectation.fulfill()
        }
        
        waitForExpectation(expectation, timeout: 1.0)
    }
    
    func testObservableWithStruct() throws {
        struct TestStruct {
            let id: Int
            let name: String
        }
        
        observableComplexType.value = TestStruct(id: 0, name: "") as AnyObject
        
        XCTAssertTrue((observableComplexType.value as? TestStruct) != nil)
    }
}
