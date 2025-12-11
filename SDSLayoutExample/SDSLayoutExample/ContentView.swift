//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/10
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSLayout

enum DemoLayoutType: String, RawRepresentable, CaseIterable {
    case relative
    case radial
    case flexHFlow
    case hFlowGrid
    case sameSizeHStack
}
extension Color {
    // standard color except .clear.white
    static var standardColors: [Color] {
        [.black, .blue, .brown, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .red, .teal, .yellow]
    }
}

extension VerticalAlignment {
    public var name: String {
        switch self {
        case .top: "top"
        case .center: "center"
        case .bottom: "bottom"
        case .firstTextBaseline: "firstTextBaseline"
        case .lastTextBaseline: "lastTextBaseline"
        default: "default?"
        }
    }
}

struct ContentView: View {
    @State private var showGuide = false
    @State private var demoLayout = DemoLayoutType.sameSizeHStack
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(selection: $demoLayout, content: {
                ForEach(DemoLayoutType.allCases, id: \.self) { layout in
                    Text(layout.rawValue).tag(layout)
                }
            })
        }, detail: {
            switch demoLayout {
            case .relative: relativeLayout
            case .radial: radialLayout
            case .flexHFlow: flexHFlowLayout
            case .hFlowGrid: hFlowGrid
            case .sameSizeHStack: sameSizeHStack
            //default: Text("Not prepared")
            }
        })
    }
    
    @ViewBuilder
    var sameSizeHStack: some View {
        let sizeAdjustments = [SameSizeHStack.SameSize.widthAndHeight, .width, .height]
        let alignments = [VerticalAlignment.top, .center, .firstTextBaseline, .lastTextBaseline, .bottom]
        VStack {
            ForEach(Array(sizeAdjustments.enumerated()), id: \.0) { adjustment in
                HStack {
                    ForEach(Array(alignments.enumerated()), id: \.0) { alignment in
                        VStack {
                            Text("sizeAdjust: " + adjustment.1.description + "\n   alignment: " + alignment.1.name)
                            SameSizeHStack(alignment: alignment.1 , sameSize: adjustment.1) {
                                Text("First\nSecondLongLine")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .border(.blue)
                                Text("OneLine")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .border(.orange)
                            }.padding(3).border(.black)
                        }
                    }
                }
            }.padding(3)
        }
        .padding(5)
    }
    
    @ViewBuilder
    var hFlowGrid: some View {
        HStack {
            HFlowSameSizeGrid(num: 5, initialPadding: 0, hSpacing: 5, vSpacing: 20) {
                ForEach(1..<23, id: \.self) { value in
                    Color.standardColors[loop: value]
                        .frame(width: 50, height: 20)
                        .overlay {
                            Text(value.formatted())
                                .foregroundStyle(Color.standardColors[loop: value] == .black ? .white: .black)
                        }
                }
            }
            .padding(5)
            .border(.green, width: 5)
            HFlowSameSizeGrid(num: 5, initialPadding: 4, hSpacing: 5, vSpacing: 20, sizePolicy: .square) {
                ForEach(1..<23, id: \.self) { value in
                    Color.standardColors[loop: value]
                        .frame(width: 50, height: 20)
                        .overlay {
                            Text(value.formatted())
                                .foregroundStyle(Color.standardColors[loop: value] == .black ? .white: .black)
                        }
                }
            }
            .padding(5)
            .border(.green, width: 5)
        }
    }

    @ViewBuilder
    var flexHFlowLayout: some View {
        FlexHFlow(alignment: .center) {
            ForEach((1000..<1035), id: \.self) { value in
                Text(value.formatted()).font(.largeTitle)
            }
        }.sizeConstraint(.horizontal).border(.red)
        FlexHFlow(alignment: .leading) {
            ForEach((1000..<1025), id: \.self) { value in
                Text(value.formatted()).font(.largeTitle)
            }
        }.sizeConstraint(.horizontal).border(.green)
        FlexHFlow(alignment: .trailing) {
            ForEach((1000..<1045), id: \.self) { value in
                Text(value.formatted()).font(.largeTitle)
            }
        }.sizeConstraint(.horizontal).border(.blue)
    }

    @ViewBuilder
    var radialLayout: some View {
        //let baseSize: CGFloat = 80
        RadialLayout {
            ForEach((1..<10).reversed(), id: \.self) { index in
                borderedNumeric(index)
                    .font(.system(size: (index != 7) ? 20 : 40))
                //Image(systemName: "\(index).square").resizable()
                //  .frame(width: (index == 3) ? baseSize * 5: baseSize)
                //height: (index == 3) ? baseSize*1.8: baseSize)
            }
        }
        .border(.blue)
        .clipped()
        .offset(x: -250)
        .border(.red)
    }
    
    @ViewBuilder
    func borderedNumeric(_ num: Int) -> some View {
        Text(num.formatted())
//            .font(.system(size: 80))
//            .minimumScaleFactor(0.1)
    }

    
    @ViewBuilder
    var relativeLayout: some View {
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

extension View {
    func sizeConstraint(_ axis: Axis.Set) -> some View {
        GeometryReader { geometry in
            switch axis {
            case [.horizontal]:
                self.frame(width: geometry.size.width)
            case [.vertical]:
                self.frame(height: geometry.size.height)
            case [.horizontal, .vertical]:
                self.frame(width: geometry.size.width, height: geometry.size.height)
            default:
                self
            }
        }
    }
}
