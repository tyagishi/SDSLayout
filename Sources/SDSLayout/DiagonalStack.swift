//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/02/19
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI
import SDSSwiftExtension
import SDSCGExtension
import OSLog

extension OSLog {
    //static var logger = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "diagonalstack")
    static var logger = Logger(.disabled)
}


extension ProposedViewSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

struct LayoutInfo: LayoutValueKey {
    static let defaultValue: String = ""
}

public struct DiagonalStack: Layout {
    var hSpacing: CGFloat? = nil
    var vSpacing: CGFloat? = nil
    
    var cache: DiagonalStackCache
    
    public init(hSpacing: CGFloat? = nil, vSpacing: CGFloat? = nil) {
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.cache = DiagonalStackCache()
    }
    
    public class DiagonalStackCache {
        var sizeThatFit: [ProposedViewSize: CGSize] = [:]
        var locDic: [String: CGVector] = [:]
    }
    
    public typealias Cache = DiagonalStackCache
    public func makeCache(subviews: Subviews) -> DiagonalStackCache {
        return self.cache
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) -> CGSize {
        var overAllSize: CGSize = .zero
        var viewIterator = PairIterator(subviews)

        while let (current, next) = viewIterator.next() {
            let currentSize = current.sizeThatFits(proposal)
            overAllSize.width  += currentSize.width
            overAllSize.height += currentSize.height
            
            if let next = next {
                if let hSpacing = hSpacing { overAllSize.width += hSpacing
                } else { overAllSize.width  += current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { overAllSize.height += vSpacing
                } else { overAllSize.height += current.spacing.distance(to: next.spacing, along: .vertical) }
            }
        }
        OSLog.logger.debug("sizeThatFits returns \(overAllSize.debugDescription)")
        cache.sizeThatFit[proposal] = overAllSize
        return overAllSize
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) {
        var pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var offset: CGVector = CGVector(dx: 0, dy: 0)
        var viewIterator = PairIterator(subviews)

        while let (current, next) = viewIterator.next() {
            current.place(at: pos + offset, anchor: .topLeading, proposal: proposal)
            if current[LayoutInfo.self] != "" {
                cache.locDic[current[LayoutInfo.self]] = offset
            }
         
            OSLog.logger.debug("palce at \(pos.debugDescription)")

            let currentSize = current.sizeThatFits(proposal)
            offset.dx += currentSize.width
            offset.dy += currentSize.height
            
            if let next = next {
                if let hSpacing = hSpacing { offset.dx += hSpacing
                } else { offset.dx += current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { offset.dy += vSpacing
                } else { offset.dy += current.spacing.distance(to: next.spacing, along: .vertical) }
            }
        }
    }
}


