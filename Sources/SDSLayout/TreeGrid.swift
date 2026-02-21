//
//  TreeGrid.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2026/02/20.
//

import Foundation
import SwiftUI
import OSLog

extension OSLog {
    // static var tGrid = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "treegrid")
    static var tGrid = Logger(.disabled)
}

struct TreeLayoutGenerationKey: LayoutValueKey {
    static let defaultValue: Int? = nil
}
extension View {
    public func treeLayoutGeneration(_ value: Int?) -> some View {
        layoutValue(key: TreeLayoutGenerationKey.self, value: value)
    }
}

/// Tree(Grid) Layout
/// generationNum: tree-depth 0..<generationNum>
public struct TreeGrid: Layout {
    public typealias Cache = Void
    let generationNum: Int
    
    public init(generationNum: Int) {
        self.generationNum = generationNum
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = subviews.maxElementSize(proposal: proposal)
        var elementMaxNum: Int = 0
        for gen in 0..<generationNum {
            let genViewNum = num(for: gen, subviews: subviews)
            elementMaxNum = max(elementMaxNum, genViewNum)
        }
        
        let size = CGSize(width: maxSize.width * CGFloat(generationNum), height: maxSize.height * CGFloat(elementMaxNum))
        return size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxSize = subviews.maxElementSize(proposal: proposal)
        let baseLoc = bounds.LUpoint()
        for gen in 0..<generationNum {
            let verticalOffset = maxSize.height * 0.5 * CGFloat(gen)
            for (index, subview) in generationViews(gen, subviews).enumerated() {
                let vec = CGVector(dx: CGFloat(gen) * maxSize.width + maxSize.width * 0.5,
                                   dy: verticalOffset + maxSize.height * CGFloat(index) + maxSize.height * 0.5)
                subview.place(at: baseLoc.move(vec),
                              anchor: .center,
                              proposal: proposal)
            }
        }
    }
    
    func generationViews(_ gen: Int, _ subviews: Subviews) -> [LayoutSubview] {
        return subviews.filter({ $0[TreeLayoutGenerationKey.self] == gen})
    }
    
    func num(for gen: Int, subviews: Subviews ) -> Int {
        return subviews.filter({ $0[TreeLayoutGenerationKey.self] == gen}).count
    }
}
