import UIKit

class AllTasksViewController: UIViewController {

    private enum Filter: Int, CaseIterable {
        case all, active, completed

        var title: String {
            switch self {
            case .all: return "Все"
            case .active: return "Активные"
            case .completed: return "Готово"
            }
        }
    }

    private var allTasks: [TaskItem] = []
    private var filtered: [TaskItem] = []
    private var currentFilter: Filter = .all

    private let segmented = UISegmentedControl(items: Filter.allCases.map { $0.title })
    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await loadData() }
    }

    private func setupUI() {
        title = "Все задачи"
        view.backgroundColor = .systemBackground

        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        segmented.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = "Нет задач"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmented)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            segmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadData() async {
        allTasks = await TaskService.shared.fetchAllTasks()
        applyFilter()
    }

    @objc private func filterChanged() {
        currentFilter = Filter(rawValue: segmented.selectedSegmentIndex) ?? .all
        applyFilter()
    }

    private func applyFilter() {
        switch currentFilter {
        case .all: filtered = allTasks
        case .active: filtered = allTasks.filter { !$0.isCompleted }
        case .completed: filtered = allTasks.filter { $0.isCompleted }
        }
        emptyLabel.isHidden = !filtered.isEmpty
        tableView.reloadData()
    }
}

extension AllTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = filtered[indexPath.row]
        cell.configure(with: task)
        cell.onToggleCompletion = { [weak self] in
            guard let self = self else { return }
            Task {
                await TaskService.shared.toggleCompletion(id: task.id)
                await self.loadData()
            }
        }
        return cell
    }
}
