//
//  RatioHStackMixTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/09
//  © 2024  SmallDeskSoftware
//

import XCTest
import SwiftUI
@testable import SDSLayout

final class RatioHStackMixTests: XCTestCase {
    @MainActor
    func test_twoView_fixRatio() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .fix(30))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 30, dy: 0))
    }
    @MainActor
    func test_twoView_ratioFix() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .fix(30))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 70, dy: 0))
    }
    
    @MainActor
    func test_twoView_ratioRatioFix() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.yellow
                .layoutValue(key: LayoutDebugViewKey.self, value: "yellow")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .fix(30))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["yellow"], CGVector(dx: 35, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 70, dy: 0))
    }
    
    @MainActor
    func test_twoView_ratioFixRatioFix() async throws {
        let sut = RelativeHStack(hSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.yellow
                .layoutValue(key: LayoutDebugViewKey.self, value: "yellow")
                .layoutValue(key: LayoutHRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutHRatio.self, value: .fix(30))
            Color.green
                .layoutValue(key: LayoutDebugViewKey.self, value: "green")
                .layoutValue(key: LayoutHRatio.self, value: .fix(30))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["yellow"], CGVector(dx: 20, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 40, dy: 0))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 70, dy: 0))
    }

}
