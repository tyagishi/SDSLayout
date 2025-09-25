//
//  HFlowSameSizeGridTests.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2025/09/25.
//

import XCTest
import SwiftUI
@testable import SDSLayout

final class HFlowSameSizeGridTests: XCTestCase {

    @MainActor
    func test_18View_4column() throws {
        let sut = HFlowSameSizeGrid(num: 4, sizePolicy: .square)
        let view = sut {
            ForEach(0..<18, id: \.self) { value in
                Color.standardColors[loop: value]
                    .frame(width: 20, height: 20)
                    .layoutValue(key: LayoutDebugViewKey.self, value: value.formatted())
            }
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 80, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["0"], CGVector(dx:  0, dy:  0))
        XCTAssertEqual(sut.cache.locDic["1"], CGVector(dx: 20, dy:  0))
        XCTAssertEqual(sut.cache.locDic["3"], CGVector(dx: 60, dy:  0))
        XCTAssertEqual(sut.cache.locDic["16"], CGVector(dx:  0, dy: 80))
        XCTAssertEqual(sut.cache.locDic["17"], CGVector(dx: 20, dy: 80))
    }
}
