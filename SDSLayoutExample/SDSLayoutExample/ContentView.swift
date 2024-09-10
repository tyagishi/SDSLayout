//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/10
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSLayout

struct ContentView: View {
    var body: some View {
        VStack {
            RelativeHStack(hSpacing: 0) {
                HStack {
                    Text("Hello, world!")
                    Text("Hello, world!")
                        .frame(maxWidth: .infinity)
                }
                .layoutValue(key: LayoutHRatio.self, value: .ratio(0.5))
                .border(.red)
                Text("Hello, world!")
                    .frame(maxWidth: .infinity)
                    .layoutValue(key: LayoutHRatio.self, value: .ratio(0.5))
                    .border(.blue)
            }
            Color.yellow
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
