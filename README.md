# SDSLayout
custom layouts which conform to SwiftUI.Layout

## RelativeHStack/ RelativeVStack
Width/Height control with available space ratio or fixed points

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
