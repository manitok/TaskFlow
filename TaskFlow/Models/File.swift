import Foundation
import UIKit

struct TaskItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var taskDescription: String?
    var dueDate: Date?
    var isCompleted: Bool
    var category: String
    var priority: Priority

    init(title: String,
         taskDescription: String? = nil,
         dueDate: Date? = nil,
         category: String = "Общее",
         priority: Priority = .medium) {

        self.id = UUID()
        self.title = title
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.isCompleted = false
        self.category = category
        self.priority = priority
    }
}

enum Priority: String, Codable, CaseIterable {
    case low = "Низкий"
    case medium = "Средний"
    case high = "Высокий"

    var color: UIColor {
        switch self {
        case .low: return .systemGreen
        case .medium: return .systemOrange
        case .high: return .systemRed
        }
    }
}
