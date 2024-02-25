//
//  DiagonalStackTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/02/19
//  © 2024  SmallDeskSoftware
//

import XCTest
import SwiftUI
@testable import SDSLayout

@MainActor
final class DiagonalStackTests: XCTestCase {
    
    func test_oneView() async throws {
        let sut = DiagonalStack()
        let view = sut {
            Color.blue.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "blue30")
        }
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[.unspecified], CGSize(width: 30, height: 30))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
    }
    
    func test_twoView_spacingPlus() async throws {
        let sut = DiagonalStack(hSpacing: 40, vSpacing: 40)
        let view = sut {
            Color.blue.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "blue30")
            Color.red.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "red30")
        }
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[.unspecified], CGSize(width: 100, height: 100))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red30"], CGVector(dx: 70, dy: 70))
    }
    
    func test_twoView_spacingMinus() async throws {
        let sut = DiagonalStack(hSpacing: -20, vSpacing: -20)
        let view = sut {
            Color.blue.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "blue30")
            Color.red.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "red30")
        }
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[.unspecified], CGSize(width: 40, height: 40))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red30"], CGVector(dx: 10, dy: 10))
    }
    
    func test_twoView_maxSpacingPlus() async throws {
        let sut = DiagonalStack(hSpacing: 20, vSpacing: 20, maxWidth: 100, maxHeight: 100)
        let view = sut {
            Color.blue.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "blue30")
            Color.red.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "red30")
            Color.yellow.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "yellow30")
        }
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[.unspecified], CGSize(width: 80, height: 80))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red30"], CGVector(dx: 50, dy: 50))
        XCTAssertEqual(sut.cache.locDic["yellow30"], nil) // should be not-layouted
    }
    func test_twoView_maxSpacingMinus() async throws {
        let sut = DiagonalStack(hSpacing: -10, vSpacing: -10, maxWidth: 50, maxHeight: 100)
        let view = sut {
            Color.blue.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "blue30")
            Color.red.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "red30")
            Color.yellow.frame(width: 30, height: 30).layoutValue(key: LayoutInfo.self, value: "yellow30")
        }
        let _ = ImageRenderer(content: view).nsImage
        
        XCTAssertEqual(sut.cache.sizeThatFit[.unspecified], CGSize(width: 50, height: 50))
        
        XCTAssertEqual(sut.cache.locDic["blue30"], CGVector(dx: 0, dy: 0))
        XCTAssertEqual(sut.cache.locDic["red30"], CGVector(dx: 20, dy: 20))
        XCTAssertEqual(sut.cache.locDic["yellow30"], nil) // should be not-layouted
    }
}
