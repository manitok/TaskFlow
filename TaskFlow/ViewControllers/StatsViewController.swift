import UIKit

class StatsViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let totalCard = StatCardView()
    private let completedCard = StatCardView()
    private let highCard = StatCardView()
    private let categoriesCard = StatCardView()
    private let progressLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await loadStats() }
    }

    private func setupUI() {
        title = "Статистика"
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        progressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        progressBar.progressTintColor = .systemBlue
        progressBar.trackTintColor = .systemGray5

        let progressContainer = UIView()
        progressContainer.backgroundColor = .secondarySystemBackground
        progressContainer.layer.cornerRadius = 12
        progressContainer.translatesAutoresizingMaskIntoConstraints = false

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(progressLabel)
        progressContainer.addSubview(progressBar)

        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: progressContainer.topAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -16),

            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])

        let topRow = UIStackView(arrangedSubviews: [totalCard, completedCard])
        topRow.axis = .horizontal
        topRow.spacing = 16
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: [highCard, categoriesCard])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 16
        bottomRow.distribution = .fillEqually

        contentStack.addArrangedSubview(progressContainer)
        contentStack.addArrangedSubview(topRow)
        contentStack.addArrangedSubview(bottomRow)

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadStats() async {
        activityIndicator.startAnimating()
        let stats = await TaskService.shared.stats()
        activityIndicator.stopAnimating()

        totalCard.configure(title: "Всего", value: "\(stats.total)", icon: "tray.full.fill", tint: .systemBlue)
        completedCard.configure(title: "Готово", value: "\(stats.completed)", icon: "checkmark.seal.fill", tint: .systemGreen)
        highCard.configure(title: "Высокий приоритет", value: "\(stats.highPriority)", icon: "flame.fill", tint: .systemRed)
        categoriesCard.configure(title: "Категорий", value: "\(stats.categoriesCount)", icon: "folder.fill", tint: .systemOrange)

        let percent = Int(stats.completionRate * 100)
        progressLabel.text = "Выполнено: \(percent)%"
        progressBar.setProgress(Float(stats.completionRate), animated: true)
    }
}

// MARK: - Card view

final class StatCardView: UIView {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 110),

            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            valueLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, value: String, icon: String, tint: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = tint
        valueLabel.textColor = .label
    }
}
