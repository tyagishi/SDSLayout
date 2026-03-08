//
//  SpiralTests.swift
//  SDSLayoutExampleTests
//
//  Created by Tomoaki Yagishita on 2026/03/07.
//

import Testing
@testable import SDSLayout
@testable import SDSLayoutExample

struct SpiralTests {

    @Test func test_loopRange_notJust() async throws {
        let elementsInRotation = [6, 12, 18]
        let sut = Spiral(radius: { index in return 15.0+Double(index)*20.0 }, viewNumForLoop: { index in return elementsInRotation[index] })
        let loopRange = sut.findLoopRange(20)
        #expect(loopRange == 0..<3) //0: 0..<6, 1: 6..<18, 2: 18..<20
    }
    @Test func test_loopRange_just() async throws {
        let elementsInRotation = [6, 12, 18]
        let sut = Spiral(radius: { index in return 15.0+Double(index)*20.0 }, viewNumForLoop: { index in return elementsInRotation[index] })
        let loopRange = sut.findLoopRange(18)
        #expect(loopRange == 0..<2)
    }

}
