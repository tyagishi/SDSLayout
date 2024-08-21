//
//  RotationalStack.swift
//
//  Created by : Tomoaki Yagishita on 2024/03/26
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI
import SDSSwiftExtension
import SDSCGExtension
import OSLog

public struct RotationalStack: Layout {
    let angle: Angle
    let maxNum: Int
    var cache: RotationalStackCache
    
    public init(angle: Angle = .degrees(10), maxNum: Int = 3) {
        self.angle = angle
        self.maxNum = maxNum
        self.cache = RotationalStackCache()
    }
    
    public class RotationalStackCache {
        var sizeThatFit: [ProposedViewSize: CGSize] = [:]
        var locDic: [String: CGVector] = [:]
    }
    
    public typealias Cache = RotationalStackCache
    public func makeCache(subviews: Subviews) -> RotationalStackCache {
        return self.cache
    }
    
    func rotateAngle(for index: Int) -> Angle {
        if index == 0 { return .degrees(0) }
        let even = (index % 2 == 0)
        if even { return .degrees(-10) }
        return .degrees(10)
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout RotationalStackCache) -> CGSize {
        let overAllRect: CGRect = CGRect(origin: .zero, size: .zero)
        // let processViewNum = max(subviews.count, maxNum)
        
//        for index in 0..<processViewNum {
//            // let currentView = subviews[index]
//            // let currentSize = currentView.sizeThatFits(proposal)
//            // rotate
//            // align origin
//            let currentViewRect = CGRect(origin: .zero, size: .zero)
//            
//            overAllRect = overAllRect.union(currentViewRect) //CGRectUnion(overAllRect, currentViewRect)
//        }

        cache.sizeThatFit[proposal] = overAllRect.size
        return overAllRect.size
    }
    
    // Issues to be solved
    // - in case place is not called for subviews, those view will appear at center of bounds... (no way to hide/skip placing subviews)
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout RotationalStackCache) {
//        var pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
//        var offset: CGVector = CGVector(dx: 0, dy: 0)
//        var viewIterator = PairIterator(subviews)

//        let maxOffset = CGVector(dx: maxWidth ?? .infinity, dy: maxHeight ?? .infinity)
//
//        while let (current, next) = viewIterator.next() {
//            current.place(at: pos + offset, anchor: .topLeading, proposal: proposal)
//            if current[LayoutInfo.self] != "" {
//                cache.locDic[current[LayoutInfo.self]] = offset
//            }
//         
//            OSLog.dStack.debug("palce at \(pos.debugDescription)")
//
//            let currentSize = current.sizeThatFits(proposal)
//            offset.dx += currentSize.width
//            offset.dy += currentSize.height
//            
//            var spacing: CGSize = .zero
//            if let next = next {
//                if let hSpacing = hSpacing { spacing.width = hSpacing
//                } else { spacing.width  = current.spacing.distance(to: next.spacing, along: .horizontal) }
//                if let vSpacing = vSpacing { spacing.height = vSpacing
//                } else { spacing.height = current.spacing.distance(to: next.spacing, along: .vertical) }
//            }
//            
//            // check layout-ability of next element
//            if let next = next {
//                let nextOffset = next.sizeThatFits(proposal).expand(offset.cgSize()).expand(spacing).cgVector()
//                
//                if maxOffset.dx < nextOffset.dx ||
//                    maxOffset.dy < nextOffset.dy {
//                    // too large, ignore following views
//                    OSLog.dStack.debug("skip following views because of max-size")
//                    return
//                }
//            }
//            offset.dx += spacing.width
//            offset.dy += spacing.height
//        }
    }
}
