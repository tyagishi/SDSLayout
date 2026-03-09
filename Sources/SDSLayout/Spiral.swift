//
//  Spiral.swift
//  SDSLayoutExample
//
//  Created by Tomoaki Yagishita on 2026/03/07.
//

import Foundation
import SwiftUI

public struct Spiral: Layout {
    let viewNumForLoop: (Int) -> Int?
    let calcRadius: (Int) -> Double
    
    public init(radius: @escaping (Int) -> Double, viewNumForLoop: @escaping (Int) -> Int?) {
        self.calcRadius = radius
        self.viewNumForLoop = viewNumForLoop
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let loopRange = findLoopRange(subviews.count)
        let maxRadius = max(calcRadius(loopRange.lowerBound), calcRadius(loopRange.upperBound+1))
        return CGSize(width: maxRadius*2, height: maxRadius*2)
    }
    
    func findLoopRange(_ subviewNum: Int) -> Range<Int> {
        var subviewNum = subviewNum
        var loopIndex = 0
        var maxRadius = 0.0
        
        while(subviewNum > 0) {
            guard let viewNumInCurrentLoop = viewNumForLoop(loopIndex) else { break }
            subviewNum -= viewNumInCurrentLoop
            maxRadius = max(maxRadius, calcRadius(loopIndex))
            loopIndex += 1
        }
        return 0..<loopIndex
    }
    
    func radiusDuringLoop(index: Int, _ startRadius: Double,_ endRadius: Double, viewNum: Int) -> Double {
        return (endRadius - startRadius) / Double(viewNum)  * Double(index) + startRadius
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var loopIndex = 0
        var startIndex = 0
        var viewNumInLoop = viewNumForLoop(loopIndex) ?? 0
        while (viewNumInLoop > 0) {
            let startRadius = calcRadius(loopIndex)
            let endRadius = calcRadius(loopIndex+1)

            for indexInLoop in 0..<viewNumInLoop {
                if subviews.count <= startIndex+indexInLoop { break }
                let currentRadius = radiusDuringLoop(index: indexInLoop, startRadius, endRadius, viewNum: viewNumInLoop)
                let angle = Angle.degrees(360.0 / Double(viewNumInLoop)).radians
                var point = CGPoint(x: 0, y: -currentRadius)
                    .applying(CGAffineTransform(rotationAngle: -angle * Double(indexInLoop)))
                // Shift the vector to the middle of the region.
                point.x += bounds.midX
                point.y += bounds.midY

                subviews[indexInLoop+startIndex].place(at: point, anchor: .center, proposal: .unspecified)
            }
            startIndex += viewNumInLoop
            viewNumInLoop = viewNumForLoop(loopIndex+1) ?? 0
            loopIndex += 1
            guard startIndex < subviews.count else { break }
        }
    }
}
