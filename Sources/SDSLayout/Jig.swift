//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/08/21
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI

extension ProposedViewSize: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

struct LayoutDebugViewKey: LayoutValueKey {
    static let defaultValue: String? = nil
}

public class LayoutDebugCache {
    var sizeThatFit: [ProposedViewSize: CGSize] = [:]
    var locDic: [String: CGVector] = [:]
    var proposal: [String: ProposedViewSize] = [:]
}

extension Color {
    // standard color except .clear.white
    static var standardColors: [Color] {
        [.black, .blue, .brown, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .red, .teal, .yellow]
    }
}
