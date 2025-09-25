//
//  HFlowSameSizeGrid.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2025/09/13.
//

import SwiftUI
import SDSCGExtension
import SDSSwiftExtension

public struct HFlowSameSizeGrid: SpacableLayout {
    let rowItemNum: Int
    let initialPadding: Int
    public var hSpacing: CGFloat? = 0
    public var vSpacing: CGFloat? = 0
    
    public enum SizePolicy {
        case widthHeightEach
        case square
        
        public func size(_ size: CGSize) -> CGSize {
            switch self {
            case .widthHeightEach: return size
            case .square:
                let maxValue = max(size.width, size.height)
                return CGSize(width: maxValue, height: maxValue)
            }
        }
    }
    let sizePolicy: SizePolicy
    
    public typealias Cache = LayoutDebugCache
    var cache: Cache

    public init(num: Int, initialPadding: Int = 0, hSpacing: CGFloat = 0, vSpacing: CGFloat = 0, sizePolicy: SizePolicy = .widthHeightEach) {
        guard num > 0 else { fatalError("HFlowGrid: num must be greater than 0") }
        guard initialPadding < num else { fatalError("invalid initialPadding value")}
        self.rowItemNum = num
        self.initialPadding = initialPadding
        self.sizePolicy = sizePolicy
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        
        self.cache = Cache()
    }
    
    public func makeCache(subviews: Subviews) -> Cache {
        return self.cache
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        // basically each item should be calced based on ideal size
        let itemMaxSize = subviews.map({ $0.sizeThatFits(.unspecified) }).reduce(CGSize.zero, {(result, size) in result.bigger(size) })
        let useSize = sizePolicy.size(itemMaxSize)
        let width = useSize.width * CGFloat(rowItemNum) + (hSpacing ?? 0) * (CGFloat(rowItemNum) - 1)
        let columnItemNum = Int((subviews.count-1+initialPadding) / rowItemNum) + 1
        let height = useSize.height * CGFloat(columnItemNum) + (vSpacing ?? 0) * (CGFloat(columnItemNum) - 1)
        
        let size = CGSize(width: width, height: height)
        cache.sizeThatFit[proposal] = size
        return size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let itemMaxSize = subviews.map({ $0.sizeThatFits(.unspecified) }).reduce(CGSize.zero, {(result, size) in result.bigger(size) })
        let useSize = sizePolicy.size(itemMaxSize)

        var posX = bounds.minX + (useSize.width + (hSpacing ?? 0)) * CGFloat(initialPadding)
        var posY = bounds.minY
        var rowIndex = initialPadding
        
        for subview in subviews {
            let loc = CGPoint(x: posX, y: posY)
            if subview[LayoutDebugViewKey.self] != "" {
                cache.locDic[subview[LayoutDebugViewKey.self]] = loc.diffVectorFrom(bounds.LUpoint())
            }
            subview.place(at: loc, anchor: .topLeading, proposal: proposal)
            rowIndex += 1
            posX += useSize.width + (hSpacing ?? 0)
            if rowIndex == rowItemNum {
                rowIndex = 0
                posX = bounds.minX
                posY += useSize.height + (vSpacing ?? 0)
            }
        }
    }
}
