# SDSLayout

Layout collection for SwiftUI

## FlexHFlow

initially try to place stuffs along horizontal.
but if stuffs overflow given width, move to next line.

```
FlexHFlow {
   Text("1")
   Text("12345")
   Text("3456")
   Text("98876545")
   Text("1234")
}
.frame(width: 120)
```

### option
now alignment option can be specified.

```
FlexHFlow(alignment: .center) { // .leading/.center/.trailing   default: .leading
   Text("1")
   Text("12345")
   Text("3456")
   Text("98876545")
   Text("1234")
}
.frame(width: 120)
```

