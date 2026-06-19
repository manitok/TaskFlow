import UIKit

class SettingsViewController: UIViewController {

    private struct Row {
        let icon: String
        let title: String
        let tint: UIColor
        let action: () -> Void
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let headerView = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()

    private lazy var rows: [Row] = [
        Row(icon: "bell.fill", title: "Уведомления", tint: .systemRed, action: { [weak self] in
            self?.showAlert(title: "Уведомления", message: "Скоро добавим напоминания.")
        }),
        Row(icon: "moon.fill", title: "Тема", tint: .systemIndigo, action: { [weak self] in
            self?.toggleTheme()
        }),
        Row(icon: "arrow.clockwise.circle.fill", title: "Сбросить демо-данные", tint: .systemOrange, action: { [weak self] in
            self?.showAlert(title: "Готово", message: "Перезапустите приложение, чтобы увидеть свежие данные.")
        }),
        Row(icon: "info.circle.fill", title: "О приложении", tint: .systemBlue, action: { [weak self] in
            self?.showAlert(title: "TaskFlow", message: "Учебный проект.\nКодовая вёрстка, closures, async/await.")
        })
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Настройки"
        view.backgroundColor = .systemGroupedBackground

        setupHeader()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableHeaderView = headerView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupHeader() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)

        avatarView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarView.tintColor = .systemBlue
        avatarView.contentMode = .scaleAspectFit
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "Гость"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Локальный профиль"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(avatarView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
    }

    private func toggleTheme() {
        guard let window = view.window else { return }
        let current = window.overrideUserInterfaceStyle
        window.overrideUserInterfaceStyle = current == .dark ? .light : .dark
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = row.title
        config.image = UIImage(systemName: row.icon)
        config.imageProperties.tintColor = row.tint
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rows[indexPath.row].action()
    }
}
