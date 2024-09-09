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
    // static var dStack = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "diagonalstack")
    static var dStack = Logger(.disabled)
}

public struct DiagonalStack: Layout {
    let hSpacing: CGFloat?
    let vSpacing: CGFloat?
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?
    
    var cache: DiagonalStackCache
    
    public init(hSpacing: CGFloat? = nil, vSpacing: CGFloat? = nil,
                maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
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
        
        let maxSize = CGSize(width: maxWidth ?? .infinity, height: maxHeight ?? .infinity)

        while let (current, next) = viewIterator.next() {
            let currentSize = current.sizeThatFits(proposal)
            
            overAllSize.width  += currentSize.width
            overAllSize.height += currentSize.height
            
            var spacing: CGSize = .zero
            if let next = next {
                if let hSpacing = hSpacing { spacing.width = hSpacing
                } else { spacing.width  = current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { spacing.height = vSpacing
                } else { spacing.height = current.spacing.distance(to: next.spacing, along: .vertical) }
            }
            
            // check layout-ability of next element
            if let next = next {
                let nextSize = next.sizeThatFits(proposal).expand(overAllSize).expand(spacing)
                
                if maxSize.width < nextSize.width ||
                    maxSize.height < nextSize.height {
                    // too large, ignore following views
                    OSLog.dStack.debug("sizeThatFits returns \(overAllSize.debugDescription) with ommiting views")
                    cache.sizeThatFit[proposal] = overAllSize
                    return overAllSize
                }
            }
            
            overAllSize = overAllSize.expand(spacing)
        }
        OSLog.dStack.debug("sizeThatFits returns \(overAllSize.debugDescription)")
        cache.sizeThatFit[proposal] = overAllSize
        return overAllSize
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout DiagonalStackCache) {
        let pos: CGPoint = CGPoint(x: bounds.minX, y: bounds.minY)
        var offset: CGVector = CGVector(dx: 0, dy: 0)
        var viewIterator = PairIterator(subviews)

        let maxOffset = CGVector(dx: maxWidth ?? .infinity, dy: maxHeight ?? .infinity)

        while let (current, next) = viewIterator.next() {
            current.place(at: pos + offset, anchor: .topLeading, proposal: proposal)
            if current[LayoutDebugViewKey.self] != "" {
                cache.locDic[current[LayoutDebugViewKey.self]] = offset
            }
         
            OSLog.dStack.debug("palce at \(pos.debugDescription)")

            let currentSize = current.sizeThatFits(proposal)
            offset.dx += currentSize.width
            offset.dy += currentSize.height
            
            var spacing: CGSize = .zero
            if let next = next {
                if let hSpacing = hSpacing { spacing.width = hSpacing
                } else { spacing.width  = current.spacing.distance(to: next.spacing, along: .horizontal) }
                if let vSpacing = vSpacing { spacing.height = vSpacing
                } else { spacing.height = current.spacing.distance(to: next.spacing, along: .vertical) }
            }
            
            // check layout-ability of next element
            if let next = next {
                let nextOffset = next.sizeThatFits(proposal).expand(offset.cgSize()).expand(spacing).cgVector()
                
                if maxOffset.dx < nextOffset.dx ||
                    maxOffset.dy < nextOffset.dy {
                    // too large, ignore following views
                    OSLog.dStack.debug("skip following views because of max-size")
                    return
                }
            }
            offset.dx += spacing.width
            offset.dy += spacing.height
        }
    }
}
