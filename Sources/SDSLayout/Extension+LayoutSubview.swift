//
//  Extension+LayoutSubview.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2026/02/20.
//

import Foundation
import SwiftUI

extension BidirectionalCollection where Element == LayoutSubview {
    public func maxElementSize(proposal: ProposedViewSize) -> CGSize {
        var size = CGSize.zero
        for child in self {
            let childSize = child.sizeThatFits(proposal)
            size = size.bigger(childSize)
        }
        return size
    }
}
