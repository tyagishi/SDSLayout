//
//  HFlowGrid.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2025/09/13.
//

import SwiftUI
import SDSSwiftExtension

public struct HFlowGrid: SpacableLayout {
    let rowItemNum: Int
    public var hSpacing: CGFloat? = 0
    public var vSpacing: CGFloat? = 0

    public init(num: Int, hSpacing: CGFloat = 0, vSpacing: CGFloat = 0) {
        guard num > 0 else { fatalError("HFlowGrid: num must be greater than 0") }
        self.rowItemNum = num
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // basically each item should be calced based on ideal size
        let itemMaxSize = subviews.map({ $0.sizeThatFits(.unspecified) }).reduce(CGSize.zero, {(result, size) in result.bigger(size) })
        let width = itemMaxSize.width * CGFloat(rowItemNum) + (hSpacing ?? 0) * (CGFloat(rowItemNum) - 1)
        let columnItemNum = Int((subviews.count-1) / rowItemNum) + 1
        let height = itemMaxSize.height * CGFloat(columnItemNum) + (vSpacing ?? 0) * (CGFloat(columnItemNum) - 1)
        return CGSize(width: width, height: height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let itemMaxSize = subviews.map({ $0.sizeThatFits(.unspecified) }).reduce(CGSize.zero, {(result, size) in result.bigger(size) })

        var posX = bounds.minX
        var posY = bounds.minY
        var rowIndex = 0
        
        for subview in subviews {
            subview.place(at: CGPoint(x: posX, y: posY), anchor: .topLeading, proposal: proposal)
            rowIndex += 1
            posX += itemMaxSize.width + (hSpacing ?? 0)
            if rowIndex == rowItemNum {
                rowIndex = 0
                posX = bounds.minX
                posY += itemMaxSize.height + (vSpacing ?? 0)
            }
        }
    }
}
