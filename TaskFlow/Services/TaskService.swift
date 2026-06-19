import Foundation

actor TaskService {
    static let shared = TaskService()

    private var tasks: [TaskItem] = []

    private init() {
        tasks = TaskService.makeMockTasks()
    }

    // MARK: - Async/Await API

    func fetchAllTasks() async -> [TaskItem] {
        try? await Task.sleep(nanoseconds: 400_000_000)
        return tasks
    }

    func fetchTodayTasks() async -> [TaskItem] {
        try? await Task.sleep(nanoseconds: 300_000_000)
        let calendar = Calendar.current
        return tasks.filter { task in
            guard let due = task.dueDate else { return false }
            return calendar.isDateInToday(due)
        }
    }

    func fetchTasks(category: String) async -> [TaskItem] {
        try? await Task.sleep(nanoseconds: 200_000_000)
        return tasks.filter { $0.category == category }
    }

    func add(_ task: TaskItem) async {
        try? await Task.sleep(nanoseconds: 150_000_000)
        tasks.append(task)
    }

    func update(_ task: TaskItem) async {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    func toggleCompletion(id: UUID) async {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func delete(id: UUID) async {
        tasks.removeAll { $0.id == id }
    }

    func allCategories() async -> [String] {
        let set = Set(tasks.map { $0.category })
        return set.sorted()
    }

    func stats() async -> TaskStats {
        let total = tasks.count
        let completed = tasks.filter { $0.isCompleted }.count
        let high = tasks.filter { $0.priority == .high }.count
        let categories = Set(tasks.map { $0.category }).count
        return TaskStats(total: total,
                         completed: completed,
                         highPriority: high,
                         categoriesCount: categories)
    }

    // MARK: - Mock seed

    private static func makeMockTasks() -> [TaskItem] {
        let today = Date()
        let tomorrow = today.addingTimeInterval(86_400)
        let inThreeDays = today.addingTimeInterval(86_400 * 3)

        return [
            TaskItem(title: "Купить продукты",
                     taskDescription: "Молоко, хлеб, яйца",
                     dueDate: today,
                     category: "Дом",
                     priority: .medium),
            TaskItem(title: "Подготовить презентацию",
                     taskDescription: "Слайды к митингу",
                     dueDate: today,
                     category: "Работа",
                     priority: .high),
            TaskItem(title: "Тренировка",
                     dueDate: tomorrow,
                     category: "Спорт",
                     priority: .low),
            TaskItem(title: "Прочитать книгу",
                     dueDate: inThreeDays,
                     category: "Учёба",
                     priority: .medium)
        ]
    }
}

struct TaskStats {
    let total: Int
    let completed: Int
    let highPriority: Int
    let categoriesCount: Int

    var completionRate: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
}
