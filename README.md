# SDSLayout
custom layouts which conform to SwiftUI.Layout

## SameSizeHStack
HStack which use max/adequate size for width (and/or) height
![SameSizeHStack](https://github.com/user-attachments/assets/81adb1d9-d889-4064-8fe9-d2aebe77f319)

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
