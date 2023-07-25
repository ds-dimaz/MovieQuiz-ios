import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        
        let array = [0, 1, 2, 3, 4]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        
        let array = [0, 1, 2, 3, 4]
        
        let value = array[safe: 2]
        
        XCTAssertNotEqual(value, 2)
    }
}

