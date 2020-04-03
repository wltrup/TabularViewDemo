import UIKit
import TabularView

class ViewController: UIViewController {

    @IBOutlet var tabularViewContainer: UIView!

    @IBOutlet var fewerRowsToggler: UISwitch!
    @IBOutlet var hiddenHeadersToggler: UISwitch!
    @IBOutlet var hiddenFootersToggler: UISwitch!
    @IBOutlet var columnWidthsSegmentedControl: UISegmentedControl!
    @IBOutlet var interColumnGapSlider: UISlider!
    @IBOutlet var interColumnGapLabel: UILabel!

    @IBOutlet var col1Slider: UISlider!
    @IBOutlet var col1Label: UILabel!

    @IBOutlet var col2Slider: UISlider!
    @IBOutlet var col2Label: UILabel!

    @IBOutlet var col3Slider: UISlider!
    @IBOutlet var col3Label: UILabel!

    let allCountries = Bundle.main.decode([Country].self, from: "data.json")
    var countries: [Country] = []

    var tabularView: TabularView<Country, ColumnId>!

    var columnWidthsSizingMode: ColumnWidthsSizingMode = .equalWidths {
        didSet {
            guard columnWidthsSizingMode != oldValue else { return }
            updateSegmentedControl()
            updateSlidersStates()
            tabularView?.columnWidthsSizingMode = columnWidthsSizingMode
        }
    }

    var interColumnGap: CGFloat = 5 {
        didSet {
            guard interColumnGap != oldValue else { return }
            updateInterColumnGapSlider()
            tabularView?.interColumnGap = interColumnGap
        }
    }

    var col1: CGFloat = 0.18 {
        didSet {
            guard col1 != oldValue else { return }
            updateColumnWidthSliders()
            tabularView?.setNeedsLayoutUpdate()
        }
    }

    var col2: CGFloat = 0.4 {
        didSet {
            guard col2 != oldValue else { return }
            updateColumnWidthSliders()
            tabularView?.setNeedsLayoutUpdate()
        }
    }

    var col3: CGFloat = 0.7 {
        didSet {
            guard col3 != oldValue else { return }
            updateColumnWidthSliders()
            tabularView?.setNeedsLayoutUpdate()
        }
    }

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        countries = allCountries

        tabularView = .init()
        let tabularView = self.tabularView!

        tabularView.backgroundColor = view.backgroundColor

        tabularView.translatesAutoresizingMaskIntoConstraints = false
        tabularViewContainer.addSubview(tabularView)

        NSLayoutConstraint.activate([
            tabularView.topAnchor.constraint(equalTo: tabularViewContainer.topAnchor),
            tabularView.bottomAnchor.constraint(equalTo: tabularViewContainer.bottomAnchor),
            tabularView.leadingAnchor.constraint(equalTo: tabularViewContainer.leadingAnchor),
            tabularView.trailingAnchor.constraint(equalTo: tabularViewContainer.trailingAnchor),
        ])

        tabularView.register(
            cellClass: ItemCell.self,
            baseReuseIdentifier: ItemCell.reuseId,
            cellKind: .cell,
            columnId: nil
        )

        tabularView.register(
            cellClass: HeaderCell.self,
            baseReuseIdentifier: HeaderCell.reuseId,
            cellKind: .header,
            columnId: nil
        )

        tabularView.register(
            cellClass: FooterCell.self,
            baseReuseIdentifier: FooterCell.reuseId,
            cellKind: .footer,
            columnId: nil
        )

        tabularView.hasHeaders = true
        tabularView.hasFooters = true

        tabularView.dataSource = self
        tabularView.layoutDelegate = self
        tabularView.sortDelegate = self

        setupInitialUIState()

    }

}

// MARK: - IBActions

private extension ViewController {

    @IBAction
    func segmentedControlChangedValue() {

        switch columnWidthsSegmentedControl.selectedSegmentIndex {
        case 0:
            columnWidthsSizingMode = .equalWidths
        case 1:
            columnWidthsSizingMode = .customWidths
        case 2:
            columnWidthsSizingMode = .autoSizedToFitVisibleContent
        case 3:
            columnWidthsSizingMode = .autoSizedToFitAllContent
        default:
            break
        }

    }

    @IBAction
    func togglerDidChangeState(sender: UISwitch) {

        switch sender {
        case fewerRowsToggler:
            if fewerRowsToggler.isOn {
                countries = allCountries.dropLast(170)
            } else {
                countries = allCountries
            }
            tabularView.setNeedsDataReload(animatingDifferences: false)

        case hiddenHeadersToggler:
            tabularView.headersAreHidden = hiddenHeadersToggler.isOn

        case hiddenFootersToggler:
            tabularView.footersAreHidden = hiddenFootersToggler.isOn

        default:
            break
        }

    }

    @IBAction
    func sliderDidChangeValue(sender: UISlider) {

        switch sender {
        case interColumnGapSlider:
            interColumnGap = CGFloat(Int(10 * interColumnGapSlider.value)) / 10
        case col1Slider:
            col1 = CGFloat(col1Slider.value)
        case col2Slider:
            col2 = CGFloat(col2Slider.value)
        case col3Slider:
            col3 = CGFloat(col3Slider.value)
        default:
            break
        }
        
    }

    func setupInitialUIState() {

        fewerRowsToggler.isOn = false
        hiddenHeadersToggler.isOn = false
        hiddenFootersToggler.isOn = false

        columnWidthsSegmentedControl.selectedSegmentIndex = 0

        interColumnGapSlider.minimumValue = 0
        interColumnGapSlider.maximumValue = 50

        col1Slider.minimumValue = 0
        col1Slider.maximumValue = 1

        col2Slider.minimumValue = 0
        col2Slider.maximumValue = 1

        col3Slider.minimumValue = 0
        col3Slider.maximumValue = 1

        updateInterColumnGapSlider()
        updateColumnWidthSliders()
        updateSlidersStates()

    }

    func updateSegmentedControl() {
        columnWidthsSegmentedControl.selectedSegmentIndex =
            columnWidthsSizingMode.rawValue
    }

    func updateSlidersStates() {

        let customWidths = (columnWidthsSizingMode == .customWidths)

        col1Slider.isEnabled = customWidths
        col1Label.isEnabled = customWidths

        col2Slider.isEnabled = customWidths
        col2Label.isEnabled = customWidths

        col3Slider.isEnabled = customWidths
        col3Label.isEnabled = customWidths

    }

    func updateColumnWidthSliders() {

        col1Slider.value = Float(col1)
        col1Label.text = Self.format(col1Slider.value)

        col2Slider.value = Float(col2)
        col2Label.text = Self.format(col2Slider.value)

        col3Slider.value = Float(col3)
        col3Label.text = Self.format(col3Slider.value)

    }

    static func format(_ value: Float, maximumFractionDigits: Int = 2) -> String {
        Self.formatter.maximumFractionDigits = maximumFractionDigits
        return Self.formatter.string(from: NSNumber(value: value)) ?? "(nil)"
    }

    func updateInterColumnGapSlider() {
        interColumnGapSlider.value = Float(interColumnGap)
        let value = interColumnGapSlider.value
        interColumnGapLabel.text = Self.format(value, maximumFractionDigits: 1)
    }

}

// MARK: - TabularViewSortDelegate conformance

extension ViewController: TabularViewSortDelegate {

    func sortRequested <CId: ColumnIdType>
        (for columnId: CId, sortOrder: SortOrder, completion: () -> Void) {

        guard let columnId = columnId as? ColumnId else { return }
        countries = countries.sorted(by: columnId, sortOrder: sortOrder)
        completion()
        
    }

}

// MARK: - TabularViewDataSource conformance

extension ViewController: TabularViewDataSource {

    func tabularViewRowIds <RowData: RowDataType, CId: ColumnIdType>
        (_ tabularView: TabularView<RowData, CId>) -> [RowId] {
        countries.map(\.id)
    }

    func tabularViewCell <RowData: RowDataType, CId: ColumnIdType> (
        _ tabularView: TabularView<RowData, CId>,
        cellKind: CellKind,
        rowIndex: RowIndex,
        columnId: CId,
        indexPath: IndexPath
    ) -> TabularViewCell {

        func cell(_ baseReuseId: String) -> TabularViewCell? {
            tabularView.dequeueReusableCell(
                baseReuseIdentifier: baseReuseId,
                cellKind: cellKind,
                columnId: nil,
                indexPath: indexPath
            )
        }

        let acell: TabularViewCell?
        switch cellKind {
        case .cell:
            acell = cell(ItemCell.reuseId) as? ItemCell
        case .header:
            acell = cell(HeaderCell.reuseId) as? HeaderCell
        case .footer:
            acell = cell(FooterCell.reuseId) as? FooterCell
        }
        
        guard let cell = acell else { fatalError("Unable to dequeue cell") }
        return cell

    }

    func tabularViewDataForCell <RowData: RowDataType, CId: ColumnIdType> (
        _ tabularView: TabularView<RowData, CId>,
        cellKind: CellKind,
        rowIndex: RowIndex,
        columnId: CId
    ) -> Any? {

        guard let columnId = columnId as? ColumnId else { return nil }

        switch cellKind {
        case .cell:
            return countries[rowIndex].data(for: columnId)
        case .header:
            return (columnId.title ?? "nil")
        case .footer:
            return (columnId.title ?? "nil")
        }

    }

}

// MARK: - TabularViewLayoutDelegate conformance

extension ViewController: TabularViewLayoutDelegate {

    func tabularViewColumnWidthDimension <RowData: RowDataType, CId: ColumnIdType> (
        _ tabularView: TabularView<RowData, CId>,
        columnId: CId
    ) -> NSCollectionLayoutDimension {

        guard let columnId = columnId as? ColumnId else { fatalError("Type mismatch.") }

        let total = col1 + col2 + col3

        switch columnId {
        case .name:
            return .fractionalWidth(col1 / total)
        case .population:
            return .fractionalWidth(col2 / total)
        case .landArea:
            return .fractionalWidth(col3 / total)
        }

    }

}
