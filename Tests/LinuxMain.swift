import XCTest

import HTTPTests

var tests = [XCTestCaseEntry]()
tests += HTTPTests.allTests()
XCTMain(tests)
