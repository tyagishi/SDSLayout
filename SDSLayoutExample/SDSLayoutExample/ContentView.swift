//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/10
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSLayout

struct ContentView: View {
    @State private var showGuide = false
    var body: some View {
        VStack {
            RelativeHStack(hSpacing: 0) {
                Text("Hello, world!").font(.largeTitle)
                .layoutValue(key: LayoutHRatio.self, value: .ratio(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.yellow)
                .overlay {
                    VStack {
                        Spacer()
                        Divider().frame(height: 15).foregroundStyle(.red)
                            .overlay {
                                Text("ratio(0.7)").fixedSize()
                            }
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                Color.white
                    .layoutValue(key: LayoutHRatio.self, value: .fix(100))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.yellow)
                    .overlay {
                        VStack {
                            Spacer()
                            Divider().frame(height: 15).foregroundStyle(.red)
                                .overlay {
                                    Text("fix(100)").fixedSize()
                                }
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                Text("Hello, world!")
                    .layoutValue(key: LayoutHRatio.self, value: .ratio(0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.yellow)
                    .overlay {
                        VStack {
                            Spacer()
                            Divider().frame(height: 15).foregroundStyle(.red)
                                .overlay {
                                    Text("ratio(0.3)").fixedSize()
                                }
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
            }
            RelativeVStack(vSpacing: 0) {
                Text("Hello, world largeTitle!").font(.largeTitle)
                    .layoutValue(key: LayoutVRatio.self, value: .ratio(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.yellow)
                    .overlay {
                        HStack {
                            Spacer()
                            Divider().frame(width: 15).foregroundStyle(.red)
                                .overlay {
                                    Text("ratio(0.5)").fixedSize()
                                }
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                Text("Hello, world body!")
                    .layoutValue(key: LayoutVRatio.self, value: .ratio(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        HStack {
                            Spacer()
                            Divider().frame(width: 15).foregroundStyle(.red)
                                .overlay {
                                    Text("ratio(0.5)").fixedSize()
                                }
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
            }.border(.green)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

