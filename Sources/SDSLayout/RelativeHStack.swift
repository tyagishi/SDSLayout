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

public enum RatioSpec {
    case ratio(_ value: CGFloat)
    case fix(_ point: CGFloat)
}

public struct LayoutHRatio: LayoutValueKey {
    public static let defaultValue: RatioSpec = .ratio(1.0)
}

/// layout along specified ratio / fixed size
///  ```
///  RalativeHStack {
///     Color1.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///     Color2.layoutValue(key: LayoutRatioInfo.self, .ratio(2))
///  }
///  ```
///   will layout Color1 with 1/3 width, Color2 with 2/3 width
///   basically same with
///   ```
///   HStack {
///     GeometryReader { geomProxy in
///       Color1.frame(width: geomProxy.size.width / 3.0)
///       Color2.frame(width: geomProxy.size.width * 2.0 / 3.0)
///     }
///   }
///   ```
///  you can specify fixed size
///  ```
///  RalativeHStack {
///     Color1.layoutValue(key: LayoutRatioInfo.self, .fix(30))
///     Color2.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///     Color3.layoutValue(key: LayoutRatioInfo.self, .ratio(1))
///  }
///  ```
///  then Color1 will have fixed 30pt width, then Color2 and Color3 share the rest space 1:1
///  fix will be allocated first, then ratio will share the rest
///
///
public struct RelativeHStack: Layout {
    let hSpacing: CGFloat?
    
    var cache: DiagonalStackCache
    
    public init(hSpacing: CGFloat? = nil) {
        self.hSpacing = hSpacing
        self.cache = DiagonalStackCache()
    }
    
    public class DiagonalStackCache {
        var sizeThatFit: [ProposedViewSize: CGSize] = [:]
        var locDic: [String: CGVector] = [:]
        var proposal: [String: ProposedViewSize] = [:]
    }
    
    public typealias Cache = DiagonalStackCache
    public func makeCache(subviews: Subviews) -> DiagonalStackCache {
        return self.cache
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) -> CGSize {
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

        let (totalRatio, totalPoint) = totalRaioPoint(subviews)
        let availableSpaceForRatio = proposal.replacingUnspecifiedDimensions().width - totalPoint

        // try to find max Coeff which convert ratio to Point, ex: 20% = 340 point -> 1% = 17 point (i.e. coeff = 17)
        //    iff 20%=340Point, 10%=300Point, use 1%=30Point (coeff = 30)
        let maxCoeffRatioToPointValue = availableSpaceForRatio / totalRatio

        var size: CGSize = .zero
        subviews.forEach { subview in
            let subviewSize = subview.sizeThatFits(proposal)
            var viewWidth = subviewSize.width
            if let ratio = ratio(for: subview) {
                viewWidth = ratio * maxCoeffRatioToPointValue
            } else if let point = fix(for: subview) {
                viewWidth = point
            }
            size.width += size.width + viewWidth
            size.height = max(size.height, subviewSize.height)
        }

        var viewIterator = PairIterator(subviews)
        while let (current, next) = viewIterator.next() {
            guard let next = next else { continue }
            let spaceToNext = spacingBetween(current, next)
            size.width += spaceToNext
        }
        
        cache.sizeThatFit[proposal] = size
        return size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) {
        let pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var offset: CGVector = CGVector(dx: 0, dy: 0)

        let (totalRatio, totalPoint) = totalRaioPoint(subviews)
        let availableSpaceForRatio = proposal.replacingUnspecifiedDimensions().width - totalPoint

        // try to find max Coeff which convert ratio to Point, ex: 20% = 340 point -> 1% = 17 point (i.e. coeff = 17)
        //    iff 20%=340Point, 10%=300Point, use 1%=30Point (coeff = 30)
        let maxCoeffRatioToPointValue = availableSpaceForRatio / totalRatio

        var viewIterator = PairIterator(subviews)
        while let (current, next) = viewIterator.next() {
            //let currentRatio = current[LayoutRatioInfo.self]
            var viewWidth: CGFloat = 0
            if let ratio = ratio(for: current) {
                viewWidth = ratio * maxCoeffRatioToPointValue
            } else if let point = fix(for: current) {
                viewWidth = point
            }

            let proposalForCurrent = ProposedViewSize(width: viewWidth, height: proposal.replacingUnspecifiedDimensions().height)
            current.place(at: pos + offset, anchor: .topLeading, proposal: proposalForCurrent)
            if current[LayoutDebugViewKey.self] != "" {
                cache.locDic[current[LayoutDebugViewKey.self]] = offset
                cache.proposal[current[LayoutDebugViewKey.self]] = proposalForCurrent
            }
            
            offset.dx += viewWidth

            if let next = next {
                let spacing = spacingBetween(current, next)
                offset.dx += spacing
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
        switch subview[LayoutHRatio.self] {
        case .ratio(let ratio):
            return ratio
        case .fix:
            return nil
        }
    }

    func fix(for subview: LayoutSubview) -> CGFloat? {
        switch subview[LayoutHRatio.self] {
        case .ratio:
            return nil
        case .fix(let point):
            return point
        }
    }

    func totalRaioPoint(_ subviews: Subviews) -> (totalRatio: CGFloat, totalPoint: CGFloat) {
        let totalRatio: CGFloat = subviews.reduce(0.0) { partialResult, subview in
            switch subview[LayoutHRatio.self] {
            case .ratio(let ratio):
                return partialResult + ratio
            case .fix:
                return partialResult
            }
        }

        let totalFix: CGFloat = subviews.reduce(0.0) { partialResult, subview in
            switch subview[LayoutHRatio.self] {
            case .ratio:
                return partialResult
            case .fix(let point):
                return partialResult + point
            }
        }
        return (totalRatio, totalFix)
    }
    
    func spacingBetween(_ lhs: LayoutSubview,_ rhs: LayoutSubview) -> CGFloat {
        if let hSpacing = hSpacing {
            return hSpacing
        }
        return lhs.spacing.distance(to: rhs.spacing, along: .horizontal)
    }
    
    func widthFor(_ subview: LayoutSubview,_ totalRatio: CGFloat,_ availableWidth: CGFloat,_ maxRatioOverPoint: CGFloat) -> CGFloat {
        switch subview[LayoutHRatio.self] {
        case .ratio(let ratio):
            return availableWidth * ratio * maxRatioOverPoint
        case .fix(let width):
            return width
        }
    }
}
