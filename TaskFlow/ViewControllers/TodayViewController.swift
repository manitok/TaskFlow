import UIKit

class TodayViewController: UIViewController {

    private var tasks: [TaskItem] = []
    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)
    private let emptyLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task { await loadTasks() }
    }

    private func setupUI() {
        title = "Сегодня"
        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = "На сегодня задач нет\nТапните + чтобы добавить"
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)

        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func loadTasks() async {
        activityIndicator.startAnimating()
        let result = await TaskService.shared.fetchTodayTasks()
        tasks = result.sorted { $0.priority.sortIndex > $1.priority.sortIndex }
        activityIndicator.stopAnimating()
        emptyLabel.isHidden = !tasks.isEmpty
        tableView.reloadData()
    }

    @objc private func refreshTriggered() {
        Task {
            await loadTasks()
            refreshControl.endRefreshing()
        }
    }

    @objc private func addTaskTapped() {
        let addVC = AddTaskViewController()

        addVC.onTaskAdded = { [weak self] newTask in
            guard let self = self else { return }
            Task {
                await TaskService.shared.add(newTask)
                await self.loadTasks()
            }
        }

        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension TodayViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }

        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.onToggleCompletion = { [weak self] in
            guard let self = self else { return }
            Task {
                await TaskService.shared.toggleCompletion(id: task.id)
                await self.loadTasks()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            Task {
                await TaskService.shared.delete(id: task.id)
                await self.loadTasks()
                completion(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

private extension Priority {
    var sortIndex: Int {
        switch self {
        case .high: return 2
        case .medium: return 1
        case .low: return 0
        }
    }
}
