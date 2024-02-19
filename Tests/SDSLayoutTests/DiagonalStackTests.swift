//
//  DiagonalStackTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/02/19
//  © 2024  SmallDeskSoftware
//

import XCTest
import SwiftUI
@testable import SDSLayout

final class DiagonalStackTests: XCTestCase {

    func test_oneViewWithoutSpacingSpecification() throws {
        let sut = DiagonalStack {
            Color.blue.frame(width: 30, height: 30)
        }
        // no idea: how to test Layout?
        
        XCTAssertNotNil(sut)
    }

}
