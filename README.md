# TabularViewDemo
![](https://img.shields.io/badge/platforms-iOS/iPadOS%2013%20-red)
[![Xcode](https://img.shields.io/badge/Xcode-11-blueviolet.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)](https://swift.org)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/wltrup/TabularViewDemo)
![GitHub](https://img.shields.io/github/license/wltrup/TabularViewDemo)

## What

**TabularViewDemo** is an Xcode project for iOS/iPadOS (13.0 and above) showcasing my [**TabularView**](https://github.com/wltrup/TabularView) Swift package, a package to display tabular data in a view, in a manner similar to how `UICollectionView` can display unidimensional data in a grid.

The package supports multiple columns, each with their own optional header and optional footer, indexed by an enumeration type, that *you* define, rather than an integer, so your code is clearer about which column or columns it refers to. There's also built-in support for sorting rows by a selected column.

The design philosophy is inspired heavily by how `UICollectionView` works. There are separate data source and delegate protocols (in fact, *two* delegate protocols, one for layout and another for sorting), and the data source is managed using the new (as of 2019) `UICollectionView` [*Diffable Data Source*](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) API.

There are some video screen captures illustrating

- [how to show and hide headers and footers](/TabularView_hiding_HFs.mov)
- [how to change the gap between columns](/TabularView_inter_cols_gap.mov)
- [how to change individual column widths](/TabularView_col_widths.mov)
- [how to sort data by selecting a column](/TabularView_sorting.mov)
- [scrolling performance](/TabularView_scrolling_perf.mov)

but they're too large to display inline, so here's a screenshot of the demo app instead:

<p align="center">
<img src="/TabularView.png" alt="A screen shot of the demo app for the TabularView package" width="417">
</p>

## Author

Wagner Truppel, trupwl@gmail.com

## License

**TabularViewDemo** is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
