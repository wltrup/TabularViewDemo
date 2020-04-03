import UIKit
import TabularView

class HeaderCell: TabularViewSortSupportingCell<ColumnId> {

    static let reuseId = "HeaderCell"

    private let button = UIButton(type: .custom)
    private let imageView = UIImageView()

    override func configure <CId: ColumnIdType>
        (cellKind: CellKind, rowIndex: RowIndex, columnId: CId, data: Any?) {

        super.configure(cellKind: cellKind, rowIndex: rowIndex, columnId: columnId, data: data)
        button.setTitle(data as? String, for: .normal)

        switch sortState {
        case .sortedAscending:
            imageView.isHidden = false
            imageView.image = UIImage.init(systemName: "arrow.up")
        case .sortedDescending:
            imageView.isHidden = false
            imageView.image = UIImage.init(systemName: "arrow.down")
        case .unknown:
            imageView.image = nil
            imageView.isHidden = true
        }

    }

    override func widthOfRenderedContent <CId: ColumnIdType> (
        cellKind: CellKind, rowIndex: RowIndex, columnId: CId, data: Any?) -> CGFloat {
        let title = button.titleLabel?.text
        let font = (button.titleLabel?.font)!
        let titleW = title?.size(withAttributes: [.font: font]).width ?? 0
        let imgW = imageView.bounds.size.width
        return titleW + 5 + imgW
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

private extension HeaderCell {

    @IBAction func buttonTapped() {
        requestSort()
    }

    func configure() {

        backgroundColor = .clear

        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let metrics = UIFontMetrics(forTextStyle: .title3)
        button.titleLabel?.font = metrics.scaledFont(for: font)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        let imgConf = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        imageView.preferredSymbolConfiguration = imgConf
        imageView.tintColor = .label

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5

        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(imageView)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        containerView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
        containerView.layer.borderColor = UIColor.label.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([

            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -0),

            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

        ])

    }

}
