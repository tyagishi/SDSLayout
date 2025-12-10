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
    public enum SameDirection {
        case sameWidth, sameHeight, sameWidthSameHeight
        
        var careWidth: Bool {
            switch self {
            case .sameWidth, .sameWidthSameHeight: return true
            case .sameHeight:                      return false
            }
        }
        var careHeight: Bool {
            switch self {
            case .sameWidth:                         return false
            case .sameHeight, .sameWidthSameHeight:  return true
            }
        }
    }
    
    let hSpacing: CGFloat?
    let sameDirection: SameDirection
    
    public init(alignment: VerticalAlignment? = nil, hSpacing: CGFloat? = nil, sameDirection: SameDirection = .sameWidthSameHeight) {
        self.hSpacing = hSpacing
        self.sameDirection = sameDirection
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidthHeight = maxWidthHeightOfViews(proposal: .unspecified, subviews: subviews)

        var totalWidth: CGFloat = 0

        if sameDirection.careWidth {
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

        var viewIterator = PairIterator(subviews)
        var baseLoc = CGPoint(x: bounds.minX, y: bounds.minY + maxWidthHeight.height / 2.0)
        while let (current, next) = viewIterator.next() {
            let sizeProposal = proposedViewSizeForPlace(subview: current, maxSize: maxWidthHeight)
            current.place(at: baseLoc, anchor: .leading, proposal: sizeProposal)
            let viewSize = current.sizeThatFits(.unspecified)

            baseLoc.x += sameDirection.careWidth ? maxWidthHeight.width : viewSize.width
            
            guard let next = next else { continue }
            let spacing = spacingBetween(current, next, along: .horizontal)
            baseLoc.x += spacing
        }
    }
    
    func proposedViewSizeForPlace(subview: LayoutSubview, maxSize: CGSize) -> ProposedViewSize {
        let viewSize = subview.sizeThatFits(.unspecified)
        let width = sameDirection.careWidth ? maxSize.width : viewSize.width
        let height = sameDirection.careHeight ? maxSize.height : viewSize.height
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
