import UIKit
import TabularView

class FooterCell: TabularViewCell {

    static let reuseId = "FooterCell"

    private let label = UILabel()

    override func configure <CId: ColumnIdType>
        (cellKind: CellKind, rowIndex: RowIndex, columnId: CId, data: Any?) {

        label.text = data as? String

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

private extension FooterCell {

    func configure() {

        backgroundColor = .clear

        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let metrics = UIFontMetrics(forTextStyle: .title3)
        label.font = metrics.scaledFont(for: font)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)

        containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        containerView.layer.borderColor = UIColor.label.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([

            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -0),

            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),

        ])

    }

}
