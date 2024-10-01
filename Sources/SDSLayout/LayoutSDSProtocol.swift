//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/01
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSSwiftExtension

protocol LayoutSDSProtocol: Layout {
    var hSpacing: CGFloat? { get }
    var vSpacing: CGFloat? { get }
}

extension LayoutSDSProtocol {
    public var hSpacing: CGFloat? { return nil }
    public var vSpacing: CGFloat? { return nil }

    public func spacing(along axis: Axis) -> CGFloat? {
        switch axis {
        case .horizontal:  return hSpacing
        case .vertical:    return vSpacing
        }
    }

    public func spacingBetween(_ lhs: LayoutSubview,_ rhs: LayoutSubview, along axis: Axis) -> CGFloat {
        if let spacing = spacing(along: axis) {
            return spacing
        }
        return lhs.spacing.distance(to: rhs.spacing, along: axis)
    }
    
    public func totalSpacing(_ subviews: Subviews, along axis: Axis) -> CGFloat {
        var viewIterator = PairIterator(subviews)
        var totalSpacing: CGFloat = 0.0
        while let (current, next) = viewIterator.next() {
            if let next = next {
                let spacing = spacingBetween(current, next, along: axis)
                totalSpacing += spacing
            }
        }
        return totalSpacing
    }
}
