//
//  RatioHStack.swift
//
//  Created by : Tomoaki Yagishita on 2024/08/21
//  © 2024  SmallDeskSoftware
//

import Foundation
import OSLog
import SwiftUI
import SDSSwiftExtension
import SDSCGExtension

extension OSLog {
    // static var log = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "RatioHStack")
    static var log = Logger(.disabled)
}

struct LayoutRatioInfo: LayoutValueKey {
    static let defaultValue: Double = 1.0
}

public struct RatioHStack: Layout {
    let hSpacing: CGFloat?
    
    var cache: DiagonalStackCache
    
    public init(hSpacing: CGFloat? = nil) {
        self.hSpacing = hSpacing
        self.cache = DiagonalStackCache()
    }
    
    public class DiagonalStackCache {
        var sizeThatFit: [ProposedViewSize: CGSize] = [:]
        var locDic: [String: CGVector] = [:]
    }
    
    public typealias Cache = DiagonalStackCache
    public func makeCache(subviews: Subviews) -> DiagonalStackCache {
        return self.cache
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) -> CGSize {
        let size = proposal.replacingUnspecifiedDimensions(by: CGSize(width: 10, height: 10)) // (10,10) is default value
        cache.sizeThatFit[proposal] = size
        return size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) {
        let pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var offset: CGVector = CGVector(dx: 0, dy: 0)

        let totalRatio: Double = subviews.reduce(0.0) { partialResult, subview in
            partialResult + subview[LayoutRatioInfo.self]
        }
        
        var viewIterator = PairIterator(subviews)
        while let (current, _) = viewIterator.next() {
            let currentRatio = current[LayoutRatioInfo.self]

            current.place(at: pos + offset, anchor: .topLeading, proposal: proposal)
            if current[LayoutInfo.self] != "" {
                cache.locDic[current[LayoutInfo.self]] = offset
            }
         
            OSLog.dStack.debug("palce at \(pos.debugDescription)")

            offset.dx += bounds.width * currentRatio / totalRatio
        }
    }
}
