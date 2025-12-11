//
//  SameSizeHStack.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2025/12/09.
//

import SwiftUI
import SDSSwiftExtension

/// layout elements with same size (width/height/both) horizontally
///
/// SameSizeHStack(hSpacing: 8, sameDirection: .sameWidthSameHeight) {
///   Text("Hello").frame(maxWidth: .infinity, maxHeight: .infinity)
///   Text("Hi").frame(maxWidth: .infinity, maxHeight: .infinity)
/// }
/// note: currently alignment is not supported, layout with .center alignment
///
public struct SameSizeHStack: SpacableLayout {
    public enum SameSize {
        case width, height, widthAndHeight
        
        var careWidth: Bool {
            switch self {
            case .width, .widthAndHeight: return true
            case .height:                 return false
            }
        }
        var careHeight: Bool {
            switch self {
            case .width:                    return false
            case .height, .widthAndHeight:  return true
            }
        }
    }
    
    let hSpacing: CGFloat?
    let sameSize: SameSize
    let alignment: VerticalAlignment
    
    public init(alignment: VerticalAlignment = .center, hSpacing: CGFloat? = nil, sameSize: SameSize = .widthAndHeight) {
        self.hSpacing = hSpacing
        self.sameSize = sameSize
        self.alignment = alignment
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidthHeight = maxWidthHeightOfViews(proposal: .unspecified, subviews: subviews)

        var totalWidth: CGFloat = 0

        if sameSize.careWidth {
            totalWidth += maxWidthHeight.width * CGFloat(subviews.count) + totalSpacing(subviews, along: .horizontal)
        } else {
            var pairIte = PairIterator(subviews)
            while let (current, next) = pairIte.next() {
                let viewSize = current.sizeThatFits(.unspecified)
                totalWidth += viewSize.width
                guard let next = next else { continue }
                totalWidth += spacingBetween(current, next, along: .horizontal)
            }
        }
        let totalHeight = maxWidthHeight.height
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidthHeight = maxWidthHeightOfViews(proposal: .unspecified, subviews: subviews)
        let maxOffset = subviews.reduce(0.0) { max($0, $1.dimensions(in: .unspecified)[alignment] )}

        var viewIterator = PairIterator(subviews)
        var placePos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        while let (current, next) = viewIterator.next() {
            let layoutViewSize = layoutViewSize(subview: current, maxSize: maxWidthHeight)

            // in case using same height, alignment does not have meaning, so let's ignore
            let layoutAlignment = (sameSize.careHeight) ? .center : alignment
                
            let pos: CGPoint
            let anchor: UnitPoint
            switch layoutAlignment {
            case .top:
                pos = placePos
                anchor = .topLeading
            case .center:
                pos = CGPoint(x: placePos.x + layoutViewSize.width / 2.0, y: bounds.midY)
                anchor = .center
            case .firstTextBaseline:
                let baselineOffset = current.dimensions(in: .unspecified)[.firstTextBaseline]
                pos = CGPoint(x: placePos.x + layoutViewSize.width / 2.0, y: bounds.minY + maxOffset - baselineOffset)
                anchor = .top
            case .lastTextBaseline:
                let baselineOffset = current.dimensions(in: .unspecified)[.lastTextBaseline]
                pos = CGPoint(x: placePos.x + layoutViewSize.width / 2.0, y: bounds.minY + maxOffset - baselineOffset)
                anchor = .top
            case .bottom:
                pos = CGPoint(x: placePos.x, y: bounds.maxY)
                anchor = .bottomLeading
            default:
                pos = CGPoint(x: placePos.x + layoutViewSize.width / 2.0, y: bounds.midY)
                anchor = .center
            }
            current.place(at: pos, anchor: anchor, proposal: ProposedViewSize(layoutViewSize))
            placePos.x += layoutViewSize.width
            
            guard let next = next else { continue }
            let spacing = spacingBetween(current, next, along: .horizontal)
            placePos.x += spacing
        }
    }
    
    func layoutViewSize(subview: LayoutSubview, maxSize: CGSize) -> CGSize {
        let viewSize = subview.sizeThatFits(.unspecified)
        let width = sameSize.careWidth ? maxSize.width : viewSize.width
        let height = sameSize.careHeight ? maxSize.height : viewSize.height
        return CGSize(width: width, height: height)
    }
    
    func proposedViewSizeForPlace(subview: LayoutSubview, maxSize: CGSize) -> ProposedViewSize {
        let viewSize = subview.sizeThatFits(.unspecified)
        let width = sameSize.careWidth ? maxSize.width : viewSize.width
        let height = sameSize.careHeight ? maxSize.height : viewSize.height
        return ProposedViewSize(width: width, height: height)
    }
    
    func maxWidthHeightOfViews(proposal: ProposedViewSize, subviews: Subviews) -> CGSize {
        var maxWidth = CGFloat.zero
        var maxHeight = CGFloat.zero
        
        // find max
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            if maxWidth < size.width { maxWidth = size.width }
            if maxHeight < size.height { maxHeight = size.height }
        }
        return CGSize(width: maxWidth, height: maxHeight)
    }
}

extension SameSizeHStack.SameSize: CustomStringConvertible {
    public var description: String {
        switch self {
        case .width:           "sameWidth"
        case .height:          "sameHeight"
        case .widthAndHeight: "sameWidthHeight"
        }
    }
}
