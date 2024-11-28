//
//  LayoutVRatio.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/01
//  © 2024  SmallDeskSoftware
//

import Foundation
import OSLog
import SwiftUI
import SDSSwiftExtension
import SDSCGExtension

extension OSLog {
    // static var log = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "RelativeVStack")
    fileprivate static var log = Logger(.disabled)
}

public struct LayoutVRatio: LayoutValueKey {
    public static let defaultValue: RatioSpec = .natural
}

/// layout along specified ratio / fixed size
///  ```
///  RalativeVStack {
///     Color1.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///     Color2.layoutValue(key: LayoutRatioInfo.self, .ratio(2))
///  }
///  ```
///   will layout Color1 with 1/3 height, Color2 with 2/3 height
///   basically same with
///   ```
///   HStack {
///     GeometryReader { geomProxy in
///       Color1.frame(height: geomProxy.size.height / 3.0)
///       Color2.frame(height: geomProxy.size.height * 2.0 / 3.0)
///     }
///   }
///   ```
///  you can specify fixed size
///  ```
///  RalativeVStack {
///     Color1.layoutValue(key: LayoutRatioInfo.self, .fix(30))
///     Color2.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///     Color3.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///  }
///  ```
///  then Color1 will have fixed 30pt height, then Color2 and Color3 share the rest space 1:1
///  fix will be allocated first, then ratio will share the rest
///
///
public struct RelativeVStack: SpacableLayout {
    let vSpacing: CGFloat?
    
    var cache: Cache
    
    public init(vSpacing: CGFloat? = nil) {
        self.vSpacing = vSpacing
        self.cache = RelativeVStackCache()
    }
    
    public class RelativeVStackCache {
        var sizeThatFit: [ProposedViewSize: CGSize] = [:]
        var locDic: [String: CGVector] = [:]
        var proposal: [String: ProposedViewSize] = [:]
    }
    
    public typealias Cache = RelativeVStackCache
    public func makeCache(subviews: Subviews) -> Cache {
        return self.cache
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        switch proposal {
        case .zero:
            cache.sizeThatFit[proposal] = CGSize.zero
            return CGSize.zero
        case .unspecified, .infinity:
            break
        default:
            cache.sizeThatFit[proposal] = proposal.replacingUnspecifiedDimensions()
            return proposal.replacingUnspecifiedDimensions()
        }

        let (totalRatio, totalPoint) = totalRaioPoint(subviews, proposal: proposal)
        let spacingInTotal = totalSpacing(subviews, along: .vertical)
        let availableSpaceForRatio = proposal.replacingUnspecifiedDimensions().height - totalPoint - spacingInTotal

        // try to find max Coeff which convert ratio to Point, ex: 20% = 340 point -> 1% = 17 point (i.e. coeff = 17)
        //    iff 20%=340Point, 10%=300Point, use 1%=30Point (coeff = 30)
        let maxCoeffRatioToPointValue = availableSpaceForRatio / totalRatio

        var size: CGSize = .zero
        subviews.forEach { subview in
            let subviewSize = subview.sizeThatFits(proposal)
            var viewHeight = subviewSize.height
            switch subview[LayoutVRatio.self] {
            case .ratio(let ratio):
                viewHeight = ratio * maxCoeffRatioToPointValue
            case .fix(let point):
                viewHeight = point
            case .natural:
                viewHeight = subviewSize.height
            }
            size.width = max(size.width, subviewSize.width)
            size.height += size.height + viewHeight
        }

        var viewIterator = PairIterator(subviews)
        while let (current, next) = viewIterator.next() {
            guard let next = next else { continue }
            let spaceToNext = spacingBetween(current, next, along: .vertical)
            size.height += spaceToNext
        }
        
        cache.sizeThatFit[proposal] = size
        return size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var offset: CGVector = CGVector(dx: 0, dy: 0)

        let (totalRatio, totalPoint) = totalRaioPoint(subviews, proposal: proposal)
        let spacingInTotal = totalSpacing(subviews, along: .vertical)
        let availableSpaceForRatio = proposal.replacingUnspecifiedDimensions().height - totalPoint - spacingInTotal
        
        // try to find max Coeff which convert ratio to Point, ex: 20% = 340 point -> 1% = 17 point (i.e. coeff = 17)
        //    iff 20%=340Point, 10%=300Point, use 1%=30Point (coeff = 30)
        let maxCoeffRatioToPointValue = availableSpaceForRatio / totalRatio

        var viewIterator = PairIterator(subviews)
        while let (current, next) = viewIterator.next() {
            //let currentRatio = current[LayoutRatioInfo.self]
            let subviewSize = current.sizeThatFits(proposal)
            var viewHeight: CGFloat = 0
            switch current[LayoutVRatio.self] {
            case .ratio(let ratio):
                viewHeight = ratio * maxCoeffRatioToPointValue
            case .fix(let point):
                viewHeight = point
            case .natural:
                viewHeight = subviewSize.height
            }

            let proposalForCurrent = ProposedViewSize(width: bounds.width, height: viewHeight)
            let centerVector = CGVector(dx: bounds.width / 2.0, dy: viewHeight / 2.0)
            current.place(at: pos.move(offset).move(centerVector), anchor: .center, proposal: proposalForCurrent)
            if current[LayoutDebugViewKey.self] != "" {
                cache.locDic[current[LayoutDebugViewKey.self]] = offset
                cache.proposal[current[LayoutDebugViewKey.self]] = proposalForCurrent
            }
            
            offset.dy += viewHeight

            if let next = next {
                let spacing = spacingBetween(current, next, along: .vertical)
                offset.dy += spacing
            }
            OSLog.dStack.debug("palce at \(pos.debugDescription)")
        }
    }
    
    // for sizeThatFit
    func maxCoeffRatioToPoint(_ subviews: Subviews, proposal: ProposedViewSize, availableWidth: CGFloat) -> CGFloat { // 1% = return point
        var maxValue: CGFloat = 0
        
        for subview in subviews {
            guard let ratio = ratio(for: subview) else { continue }
            let subviewSize = subview.sizeThatFits(proposal)
            let localUnit = subviewSize.width / ratio
            
            maxValue = max(localUnit, maxValue)
        }
        return maxValue
    }
    
    // common
    func ratio(for subview: LayoutSubview) -> CGFloat? {
        switch subview[LayoutVRatio.self] {
        case .ratio(let ratio):
            return ratio
        default:
            return nil
        }
    }

    func fix(for subview: LayoutSubview) -> CGFloat? {
        switch subview[LayoutVRatio.self] {
        case .fix(let point):
            return point
        default:
            return nil
        }
    }

    func natural(for subview: LayoutSubview, proposal: ProposedViewSize) -> CGFloat? {
        switch subview[LayoutVRatio.self] {
        case .natural:
            return subview.sizeThatFits(proposal).height
        default:
            return nil
        }
    }
    
    func totalRaioPoint(_ subviews: Subviews, proposal: ProposedViewSize) -> (totalRatio: CGFloat, totalPoint: CGFloat) {
        let totalRatio: CGFloat = subviews.reduce(0.0) { partialResult, subview in
            switch subview[LayoutVRatio.self] {
            case .ratio(let ratio):
                return partialResult + ratio
            case .fix, .natural:
                return partialResult
            }
        }

        let totalFix: CGFloat = subviews.reduce(0.0) { partialResult, subview in
            switch subview[LayoutVRatio.self] {
            case .ratio:
                return partialResult
            case .fix(let point):
                return partialResult + point
            case .natural:
                return partialResult + subview.sizeThatFits(proposal).height
            }
        }
        return (totalRatio, totalFix)
    }
}
