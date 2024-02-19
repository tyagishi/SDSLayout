//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/02/19
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI
import SDSSwiftExtension

public struct DiagonalStack: Layout {
    var hSpacing: CGFloat? = nil
    var vSpacing: CGFloat? = nil

    public init(hSpacing: CGFloat? = nil, vSpacing: CGFloat? = nil) {
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        var overAllSize: CGSize = .zero
        var viewIterator = PairIterator(subviews)

        while let (current, next) = viewIterator.next() {
            let currentSize = current.sizeThatFits(proposal)
            print("currentSize \(currentSize)")
            overAllSize.width  += currentSize.width
            overAllSize.height += currentSize.height
            
            if let next = next {
                if let hSpacing = hSpacing { overAllSize.width += hSpacing
                } else { overAllSize.width  += current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { overAllSize.height += vSpacing
                } else { overAllSize.height += current.spacing.distance(to: next.spacing, along: .vertical) }
            }
        }
        print("sizeThatFits returns \(overAllSize)")
        
        return overAllSize
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var viewIterator = PairIterator(subviews)

        while let (current, next) = viewIterator.next() {
            current.place(at: pos, anchor: .topLeading, proposal: proposal)
            
            let currentSize = current.sizeThatFits(proposal)
            pos.x += currentSize.width
            pos.y += currentSize.height
            
            if let next = next {
                if let hSpacing = hSpacing { pos.x += hSpacing
                } else { pos.x += current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { pos.y += vSpacing
                } else { pos.y += current.spacing.distance(to: next.spacing, along: .vertical) }
            }
        }
    }
    
}
