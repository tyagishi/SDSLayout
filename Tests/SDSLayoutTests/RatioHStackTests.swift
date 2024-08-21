//
//  RatioHStackTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/08/21
//  © 2024  SmallDeskSoftware
//

import XCTest
import SwiftUI
@testable import SDSLayout

@MainActor
final class RatioHStackTests: XCTestCase {
    func test_oneView() async throws {
        let sut = RatioHStack()
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutInfo.self, value: "blue30")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
    }
    
    func test_twoView() async throws {
        let sut = RatioHStack()
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutInfo.self, value: "blue")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
            Color.red
                .layoutValue(key: LayoutInfo.self, value: "red")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 50, dy: 0))
    }
    func test_threeView() async throws {
        let sut = RatioHStack()
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutInfo.self, value: "blue")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
            Color.red
                .layoutValue(key: LayoutInfo.self, value: "red")
                .layoutValue(key: LayoutRatioInfo.self, value: 2.0)
            Color.green
                .layoutValue(key: LayoutInfo.self, value: "green")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 25, dy: 0))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 75, dy: 0))
    }
    func test_threeView_text() async throws {
        let sut = RatioHStack()
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutInfo.self, value: "blue")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
            Text("A")
                .layoutValue(key: LayoutInfo.self, value: "red")
                .layoutValue(key: LayoutRatioInfo.self, value: 2.0)
            Color.green
                .layoutValue(key: LayoutInfo.self, value: "green")
                .layoutValue(key: LayoutRatioInfo.self, value: 1.0)
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 25, dy: 0))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 75, dy: 0))
    }
}
