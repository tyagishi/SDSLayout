//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/10
//  © 2022  SmallDeskSoftware
//

import SwiftUI
import SDSFoundationExtension
import SDSSwiftExtension

typealias subviewWithSize = (subview: LayoutSubview, size: CGSize)

public struct FlexHFlow: Layout {
    let alignment: HorizontalAlignment

    public init(alignment: HorizontalAlignment = .center) {
        self.alignment = alignment
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        print("proposal in placeSubviews: \(proposal), bounds: \(bounds)")
        let layoutedSubviews = layoutSubviews(proposal: proposal, subviews: subviews)

        let layoutWidth = proposal.width ?? bounds.width
        let layoutMinX = bounds.minX + (bounds.width - layoutWidth) / 2.0

        var posY = bounds.minY

        var rowIterator = PairIterator(layoutedSubviews)
        while let (currentRow, nextRow) = rowIterator.next() {
            let lineSize = calcLineSize(currentRow)
            posY += lineSize.height * 0.5

            var posX: CGFloat
            switch alignment {
            case .leading:
                posX = layoutMinX
            case .center:
                posX = layoutMinX + max((layoutWidth - lineSize.width)/2.0, 0.0)
            case .trailing:
                posX = layoutMinX + max((layoutWidth - lineSize.width), 0.0)
            default:
                posX = 0
                fatalError("Not supported yet")
            }

            var cellIterator = PairIterator(currentRow)
            while let (currentCell, nextCell) = cellIterator.next() {
                let request: ProposedViewSize
                var adjustLastElement: CGFloat = 0.0
                if currentCell.size.width < proposal.width! {
                    request = ProposedViewSize.unspecified
                } else {
                    request = ProposedViewSize.init(width: proposal.width!, height: nil)
                    let newSize = currentCell.subview.sizeThatFits(request)
                    switch alignment {
                    case .center:
                        adjustLastElement = (proposal.width! - newSize.width)/2.0
                    case .trailing:
                        adjustLastElement = proposal.width! - newSize.width
                    case .leading:
                        break
                    default:
                        break
                    }
                }

                currentCell.subview.place(at: CGPoint(x: posX + adjustLastElement, y: posY), anchor: .leading, proposal: request)
                if let nextCell = nextCell {
                    posX += currentCell.1.width + currentCell.subview.spacing.distance(to: nextCell.subview.spacing, along: .horizontal)
                }
            }
            if let nextRow = nextRow {
                posY += lineSize.height * 0.5 + spacingBetweenLine(current: currentRow, next: nextRow)
            }
        }
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let layoutedSubviews = layoutSubviews(proposal: proposal, subviews: subviews)
        print("proposal in sizeThatFits: \(proposal), then answer \(calcNecessarySize(layoutedSubviews))")
        return calcNecessarySize(layoutedSubviews)
    }

    // regardless of alignment, row set should be always same.
    func layoutSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [[subviewWithSize]] {
        if let layoutWidth = proposal.width,
           layoutWidth > 0 { // even proposal exists, width might be 0, in that case, let's use oneline
            var layoutedSubviews: [[subviewWithSize]] = [] // [row][column]
            var currentRow = 0
            var currentRowWidth = 0.0
            var viewPairIterator = PairIterator(subviews)
            while let (currentSubview, nextSubview) = viewPairIterator.next() {
                let currentSubviewSize = currentSubview.sizeThatFits(.unspecified)
                var spacing:CGFloat = 0.0
                if let nextSubview = nextSubview {
                    spacing = currentSubview.spacing.distance(to: nextSubview.spacing, along: .horizontal)
                }
                if currentRowWidth + currentSubviewSize.width + spacing <= layoutWidth {
                    // add to current line
                    if layoutedSubviews.count <= currentRow { layoutedSubviews.append([]) }
                    layoutedSubviews[currentRow].append((currentSubview, currentSubviewSize))
                    currentRowWidth += (currentSubviewSize.width + spacing)
                } else {
                    // move to next line
                    currentRow += 1
                    layoutedSubviews.append([(currentSubview, currentSubviewSize)])
                    currentRowWidth = currentSubviewSize.width
                }
            }
            return layoutedSubviews
        } else {
            let oneLine = subviews.map({($0, $0.sizeThatFits(.unspecified))})
            return [oneLine]
        }
    }
    func calcNecessarySize(_ layoutedSubviews: [[subviewWithSize]]) -> CGSize {
        var rowWidth = -1.0
        var height = 0.0
        for row in layoutedSubviews {
            let rowSize = calcLineSize(row)
            rowWidth = max(rowWidth, rowSize.width)
            height += rowSize.height
        }
        // care vertical spacing
        if layoutedSubviews.count > 2 {
            _ = layoutedSubviews.indices.dropLast().map({
                height += layoutedSubviews[$0][0].subview.spacing.distance(to: layoutedSubviews[$0 + 1][0].subview.spacing, along: .vertical)
            })
        }
        return CGSize(width: rowWidth, height: height)
    }

    func calcLineSize(_ row: [subviewWithSize]) -> CGSize {
        let rowWidth = row.map({$0.1.width}).reduce(0.0, +)
        var rowSpacing = 0.0
        _ = row.indices.dropLast().map({
            rowSpacing += row[$0].subview.spacing.distance(to: row[$0 + 1].subview.spacing, along: .horizontal)
        })
        let rowHeight = row.map({$0.size.height}).max() ?? 0.0
        return CGSize(width: rowWidth + rowSpacing, height: rowHeight)
    }

    func spacingBetweenLine(current: [subviewWithSize], next: [subviewWithSize]) -> CGFloat {
        return current[0].subview.spacing.distance(to: next[0].subview.spacing, along: .vertical)
    }

}
