import UIKit

class TaskTableViewCell: UITableViewCell {

    static let reuseID = "TaskCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priorityLabel = UILabel()
    private let checkButton = UIButton(type: .system)

    var onToggleCompletion: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 1

        categoryLabel.font = UIFont.systemFont(ofSize: 14)
        categoryLabel.textColor = .secondaryLabel

        priorityLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkButton.tintColor = .systemBlue
        checkButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        stack.axis = .vertical
        stack.spacing = 4

        containerView.addSubview(stack)
        containerView.addSubview(priorityLabel)
        containerView.addSubview(checkButton)

        stack.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: priorityLabel.leadingAnchor, constant: -8),

            priorityLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -12),
            priorityLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            checkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 30),
            checkButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func toggleTapped() {
        onToggleCompletion?()
    }

    func configure(with task: TaskItem) {
        let titleText = task.title
        if task.isCompleted {
            let attributed = NSAttributedString(
                string: titleText,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
            titleLabel.attributedText = attributed
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = titleText
            titleLabel.textColor = .label
        }

        categoryLabel.text = task.category
        priorityLabel.text = task.priority.rawValue
        priorityLabel.textColor = task.priority.color

        checkButton.isSelected = task.isCompleted
    }
}
