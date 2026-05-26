//
//  AlternativeGrid.swift
//  SDSLayout
//
//  Created by Tomoaki Yagishita on 2026/05/26.
//

import Foundation
import SwiftUI
import OSLog

extension OSLog {
    // static var log = Logger(subsystem: "com.smalldesksoftware.sdslayout", category: "AlternateGrid")
    static fileprivate let log = Logger(.disabled)
}

struct AlternativeLayoutGenerationKey: LayoutValueKey {
    static let defaultValue: Int? = nil
}
extension View {
    public func alternativeLayoutGeneration(_ value: Int?) -> some View {
        layoutValue(key: AlternativeLayoutGenerationKey.self, value: value)
    }
}

/// Tree(Grid) Layout
/// generationNum: tree-depth 0..<generationNum>
public struct AlternativeGrid: Layout {
    public typealias Cache = Void
    let generationNum: Int
    let widthPolicy: WidthPolicy

    public enum WidthPolicy {
        case all
        case eachColumn
    }
    
    public init(generationNum: Int, widthPolicy: WidthPolicy = .all) {
        self.generationNum = generationNum
        self.widthPolicy = widthPolicy
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = subviews.maxElementSize(proposal: proposal)
        var elementMaxNum: Int = 0
        for gen in 0..<generationNum {
            let genViewNum = num(for: gen, subviews: subviews)
            elementMaxNum = max(elementMaxNum, genViewNum)
        }

        switch widthPolicy {
        case .all:
            let size = CGSize(width: maxSize.width * CGFloat(generationNum), height: maxSize.height * CGFloat(elementMaxNum))
            return size
        case .eachColumn:
            let dic = maxSizeEachGen(proposal: proposal, subviews)
            let widthSum = dic.values.map({ $0.width }).reduce(0.0, +)
            // find maxHeight
            let height = dic.values.map({ $0.height }).max() ?? 0.0
            let size = CGSize(width: widthSum, height: height * CGFloat(elementMaxNum))
            return size
        }
        
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let baseLoc = bounds.LUpoint()
        if widthPolicy == .all {
            let maxSize = subviews.maxElementSize(proposal: proposal)
            for gen in 0..<generationNum {
                let verticalOffset = maxSize.height * 0.5 * CGFloat(gen % 2)
                for (index, subview) in generationViews(gen, subviews).enumerated() {
                    let vec = CGVector(dx: CGFloat(gen) * maxSize.width + maxSize.width * 0.5,
                                       dy: verticalOffset + maxSize.height * CGFloat(index) + maxSize.height * 0.5)
                    subview.place(at: baseLoc.move(vec),
                                  anchor: .center,
                                  proposal: proposal)
                }
            }
            return
        }
        let dic = maxSizeEachGen(proposal: proposal, subviews)
        let height = dic.values.map({ $0.height }).max() ?? 0.0
        for gen in 0..<generationNum {
            let verticalOffset = height * 0.5 * CGFloat(gen % 2)
            for (index, subview) in generationViews(gen, subviews).enumerated() {
                let widthOffset = widthOffsetForGen(gen, sizeDic: dic)
                let vec = CGVector(dx: widthOffset + dic[gen, default: .zero].width * 0.5,
                                   dy: verticalOffset + height * CGFloat(index) + height * 0.5)
                subview.place(at: baseLoc.move(vec),
                              anchor: .center,
                              proposal: proposal)
            }
        }
        return

    }
    
    func widthOffsetForGen(_ gen: Int, sizeDic: [Int: CGSize]) -> CGFloat {
        var width = 0.0
        for index in 0..<gen {
            width += sizeDic[index, default: .zero].width
        }
        return width
    }
    
    func generationViews(_ gen: Int, _ subviews: Subviews) -> [LayoutSubview] {
        return subviews.filter({ $0[TreeLayoutGenerationKey.self] == gen})
    }
    
    func maxSizeEachGen(proposal: ProposedViewSize, _ subviews: Subviews) -> [Int: CGSize] {
        var dic: [Int: CGSize] = [:]
        for gen in 0..<generationNum {
            let views = generationViews(gen, subviews)
            let maxSize = views.maxElementSize(proposal: proposal)
            dic[gen] = maxSize
        }
        return dic
    }
    
    func num(for gen: Int, subviews: Subviews ) -> Int {
        return subviews.filter({ $0[TreeLayoutGenerationKey.self] == gen}).count
    }
}
