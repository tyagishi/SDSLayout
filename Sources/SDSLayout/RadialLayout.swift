//
//  RadialLayout.swift
//
//  Created by Tomoaki Yagishita on 2025/05/18.
//

import SwiftUI

enum LayoutMode {
    case greedy
    case fixed(_ radius: Double)
    
    init(radius: Double?) {
        if let radius = radius {
            self = .fixed(radius)
        } else {
            self = .greedy
        }
    }
}

public struct RadialLayout: Layout {
    let layoutMode: LayoutMode

    public init(radius: Double? = nil) {
        self.layoutMode = LayoutMode(radius: radius)
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void ) -> CGSize {
        switch layoutMode {
        case .greedy:
            return proposal.replacingUnspecifiedDimensions()
        case .fixed(let radius):
            let maxViewSize = subviews.maxElementSize(proposal: proposal)
            return CGSize(width: (radius + maxViewSize.width)*2, height: (radius + maxViewSize.height)*2)
        }
    }

    /// Places the stack's subviews in a circle.
    /// - Tag: placeSubviewsRadial
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                              subviews: Subviews, cache: inout Void ) {
        let radius: Double
        switch layoutMode {
        case .greedy:
            radius = min(bounds.size.width, bounds.size.height) / 3.0
        case .fixed(let givenRadius):
            radius =  givenRadius
        }

        // The angle between views depends on the number of views.
        let angle = Angle.degrees(360.0 / Double(subviews.count)).radians
        
        for (index, subview) in subviews.enumerated() {
            // Find a vector with an appropriate size and rotation.
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(rotationAngle: angle * Double(index)))
            
            // Shift the vector to the middle of the region.
            point.x += bounds.midX
            point.y += bounds.midY
            
            // Place the subview.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
