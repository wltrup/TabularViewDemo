import UIKit
import TabularView

class ItemCell: TabularViewCell {

    static let reuseId = "ItemCell"

    let label = UILabel()

    override func configure <CId: ColumnIdType>
        (cellKind: CellKind, rowIndex: RowIndex, columnId: CId, data: Any?) {
        label.text = (data as? String)

        switch columnId as! ColumnId {
        case .name:
            label.textAlignment = .left
        default:
            label.textAlignment = .right
        }

        switch cellKind {
        case .cell:
            if rowIndex.isMultiple(of: 2) {
                backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
            } else {
                backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
            }
        case .footer:
            label.textAlignment = .center
            backgroundColor = .systemGray3
        case .header:
            break
        }

    }

    override func widthOfRenderedContent <CId: ColumnIdType> (
        cellKind: CellKind, rowIndex: RowIndex, columnId: CId, data: Any?) -> CGFloat {
        label.text?.size(withAttributes: [.font: label.font!]).width ?? 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension ItemCell {

    func configure() {

        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 0.75

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])

    }

}
