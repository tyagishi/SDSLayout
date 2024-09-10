//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/08/21
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI

extension ProposedViewSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

struct LayoutDebugViewKey: LayoutValueKey {
    static let defaultValue: String = ""
}
