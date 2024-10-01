//
//  RelativeVStackTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/01
//  © 2024  SmallDeskSoftware
//

import XCTest
import SwiftUI
@testable import SDSLayout

@MainActor
final class RelativeVStackTests: XCTestCase {
    func test_oneView_Pushout() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue30")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue30"], ProposedViewSize(width: 100, height: 100))
    }

    func test_oneView_Pull() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Text("Hello world")
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue30")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue30"], ProposedViewSize(width: 100, height: 100))
    }

    
    func test_twoView_Pushout() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue"], ProposedViewSize(width: 100, height: 50))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 0, dy: 50))
        XCTAssertEqual(sut.cache.proposal["red"], ProposedViewSize(width: 100, height: 50))
    }
    
    func test_twoView_PushPull() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
            Text("Hello world")
                .layoutValue(key: LayoutDebugViewKey.self, value: "hello")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue"], ProposedViewSize(width: 100, height: 50))
        XCTAssertEqual(sut.cache.locDic["hello"], CGVector(dx: 0, dy: 50))
        XCTAssertEqual(sut.cache.proposal["hello"], ProposedViewSize(width: 100, height: 50))
    }

    func test_twoView_PullPull() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Text("Hello world1")
                .layoutValue(key: LayoutDebugViewKey.self, value: "1")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
            Text("Hello world2")
                .layoutValue(key: LayoutDebugViewKey.self, value: "2")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["1"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["1"], ProposedViewSize(width: 100, height: 50))
        XCTAssertEqual(sut.cache.locDic["2"], CGVector(dx: 0, dy: 50))
        XCTAssertEqual(sut.cache.proposal["2"], ProposedViewSize(width: 100, height: 50))
    }
    
    func test_threeView() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
            Color.red
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(2.0))
            Color.green
                .layoutValue(key: LayoutDebugViewKey.self, value: "green")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue"], ProposedViewSize(width: 100, height: 25))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 0, dy: 25))
        XCTAssertEqual(sut.cache.proposal["red"], ProposedViewSize(width: 100, height: 50))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 0, dy: 75))
        XCTAssertEqual(sut.cache.proposal["green"], ProposedViewSize(width: 100, height: 25))
    }
    func test_threeView_text() async throws {
        let sut = RelativeVStack(vSpacing: 0)
        let view = sut {
            Color.blue
                .layoutValue(key: LayoutDebugViewKey.self, value: "blue")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
            Text("A")
                .layoutValue(key: LayoutDebugViewKey.self, value: "red")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(2.0))
            Color.green
                .layoutValue(key: LayoutDebugViewKey.self, value: "green")
                .layoutValue(key: LayoutVRatio.self, value: .ratio(1.0))
        }.frame(width: 100, height: 100)
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[ProposedViewSize(width: 100, height: 100)], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.proposal["blue"], ProposedViewSize(width: 100, height: 25))
        XCTAssertEqual(sut.cache.locDic["red"], CGVector(dx: 0, dy: 25))
        XCTAssertEqual(sut.cache.proposal["red"], ProposedViewSize(width: 100, height: 50))
        XCTAssertEqual(sut.cache.locDic["green"], CGVector(dx: 0, dy: 75))
        XCTAssertEqual(sut.cache.proposal["green"], ProposedViewSize(width: 100, height: 25))
    }
}
