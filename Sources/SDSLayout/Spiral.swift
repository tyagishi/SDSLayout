//
//  Spiral.swift
//  SDSLayoutExample
//
//  Created by Tomoaki Yagishita on 2026/03/07.
//

import Foundation
import SwiftUI

public struct Spiral: Layout {
    let variousAngle: Bool
    let viewNumForLoop: (Int) -> Int?
    let calcRadius: (Int) -> Double
    
    public init(radius: @escaping (Int) -> Double,
                variousAngle: Bool = false,
                viewNumForLoop: @escaping (Int) -> Int?) {
        self.calcRadius = radius
        self.variousAngle = variousAngle
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
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var loopIndex = 0
        var startIndex = 0
        var viewNumInLoop = viewNumForLoop(loopIndex) ?? 0
        while (viewNumInLoop > 0) {
            let startRadius = calcRadius(loopIndex)
            let endRadius = calcRadius(loopIndex+1)
            
            let (radii, angles) = placeRadiiAngles(startRadius, endRadius, viewNumInLoop)
            for indexInLoop in 0..<viewNumInLoop {
                if subviews.count <= startIndex+indexInLoop { break }
                var point = CGPoint(x: 0, y: -1 * radii[indexInLoop])
                    .applying(CGAffineTransform(rotationAngle: -1 * angles[indexInLoop].radians))
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
    
    func placeRadiiAngles(_ startRadius: Double,_ endRadius: Double,_ viewNum: Int) -> (radii: [Double], angles: [Angle]) {
        var radii: [Double] = []
        var angles: [Angle] = []
        let stepAngle = Angle(degrees: 360.0 / Double(viewNum))
        var currentAngle = Angle(degrees: 0)
        for index in 0..<viewNum {
            let radius = (endRadius - startRadius) * Double(index) / Double(viewNum) + startRadius
            radii.append(radius)
            angles.append(currentAngle)
            currentAngle += stepAngle
        }
        return (radii, angles)
    }
}
