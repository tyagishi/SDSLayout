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
final class RatioHStackRatioTests: XCTestCase {
    func test_oneView() async throws {
        let sut = RelativeHStack()
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue30")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
    }
    
    func test_twoView() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 50, dy: 0))
    }
    func test_threeView() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(2.0))
            Color.green
                .layoutValue(key: LayoutDebugViewKey.self, value: "green")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 25, dy: 0))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 75, dy: 0))
    }
    func test_threeView_text() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Text("A")
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(2.0))
            Color.green
                .layoutValue(key: LayoutDebugViewKey.self, value: "green")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 25, dy: 0))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 75, dy: 0))
    }
}
