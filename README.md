# SDSLayout
custom layouts which conform to SwiftUI.Layout

## TreeGrid
Tree style layout
each node has same width/height (maximum width/ maximum height)
can specify generation(start from 0) using layoutValue
![TreeGrid](https://github.com/user-attachments/assets/2040ccdd-c470-4df1-aaac-065dc3fa9bed)

```
    @ViewBuilder
    var treeGrid: some View {
        VStack {
            TreeGrid(generationNum: 4){
                Rectangle().fill(.blue).frame(width: 100, height: 100)
                    .overlay { Text("0-0") }
                    .treeLayoutGeneration(0)
                Rectangle().fill(.red).frame(width: 100, height: 100)
                    .overlay { Text("0-1") }
                    .treeLayoutGeneration(0)
                Rectangle().fill(.green).frame(width: 100, height: 100)
                    .overlay { Text("0-2") }
                    .treeLayoutGeneration(0)
                Rectangle().fill(.yellow).frame(width: 100, height: 100)
                    .overlay { Text("0-3") }
                    .treeLayoutGeneration(0)
                Rectangle().fill(.orange).frame(width: 100, height: 100)
                    .overlay { Text("1-0") }
                    .treeLayoutGeneration(1)
                Rectangle().fill(.cyan).frame(width: 100, height: 100)
                    .overlay { Text("1-1") }
                    .treeLayoutGeneration(1)
                Rectangle().fill(.brown).frame(width: 100, height: 100)
                    .overlay { Text("1-2") }
                    .treeLayoutGeneration(1)
                Rectangle().fill(.blue).frame(width: 100, height: 100)
                    .overlay { Text("2-0") }
                    .treeLayoutGeneration(2)
                Rectangle().fill(.red).frame(width: 100, height: 100)
                    .overlay { Text("2-1") }
                    .treeLayoutGeneration(2)
                Rectangle().fill(.orange).frame(width: 100, height: 100)
                    .overlay { Text("3-0") }
                    .treeLayoutGeneration(3)
            }
        }.border(.red)
    }
```

## SameSizeHStack
HStack which use max/adequate size for width (and/or) height
![SameSizeHStack](https://github.com/user-attachments/assets/3a70ba64-4199-483c-abf7-ab781ab39a3f)

```
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
```

## RelativeHStack/ RelativeVStack
Width/Height control with available space ratio or fixed points
![RelativeHStack/RelativeVStackImage](https://github.com/user-attachments/assets/7a1c5fe6-e506-4922-9516-6802a73da2aa)
```
struct ContentView: View {
    var body: some View {
        VStack {
            RelativeHStack(hSpacing: 0) {
                Text("Hello, world!").font(.largeTitle)
                .layoutValue(key: LayoutHRatio.self, value: .ratio(0.7))
                Color.white
                    .layoutValue(key: LayoutHRatio.self, value: .fix(100))
                Text("Hello, world!")
                    .layoutValue(key: LayoutHRatio.self, value: .ratio(0.3))
            }
            RelativeVStack(vSpacing: 0) {
                Text("Hello, world largeTitle!").font(.largeTitle)
                    .layoutValue(key: LayoutVRatio.self, value: .ratio(0.5))
                Text("Hello, world body!")
                    .layoutValue(key: LayoutVRatio.self, value: .ratio(0.5))
            }.border(.green)
        }
        .padding()
    }
}
```

## FlexHFlow
horizontal flow layout

## HFlowSameSizeGrid
```swift
    HFlowSameSizeGrid(num: 5, initialPadding: 4, hSpacing: 5, vSpacing: 20) {
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
```

## DiagnoalStack
layout views along diagonal direction

![DiagonalStack](https://github.com/tyagishi/SDSLayout/assets/6419800/915982a3-85e6-4c85-8a56-9fdee5e11c74)

```
struct ContentView: View {
    @State private var colors: [Color] = [.red, .blue, .purple, .orange, .yellow]
    
    var body: some View {
        VStack {
            Text("DiagonalStack() note: border(.red)")
            DiagonalStack() {
                ForEach(colors.indices, id: \.self) { index in
                    colors[index].frame(width: 25, height: 25)
                }
            }
            .border(.red)

            Text("DiagonalStack(hSpacing: -20, vSpacing: -20) note: border(.yellow)")
            DiagonalStack(hSpacing: -20, vSpacing: -20) {
                ForEach(colors.indices, id: \.self) { index in
                    colors[index].frame(width: 25, height: 25)
                }
            }
            .border(.yellow)

        }
        .padding()
    }
}

```
