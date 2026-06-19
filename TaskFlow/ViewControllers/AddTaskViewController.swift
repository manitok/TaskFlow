import UIKit

class AddTaskViewController: UIViewController {

    // Closure для возврата задачи в родительский экран
    var onTaskAdded: ((TaskItem) -> Void)?

    private let titleTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let categoryTextField = UITextField()
    private let prioritySegmented = UISegmentedControl(items: Priority.allCases.map { $0.rawValue })
    private let datePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }

    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }

    private func setupUI() {
        title = "Новая задача"
        view.backgroundColor = .systemBackground

        titleTextField.placeholder = "Название задачи"
        titleTextField.borderStyle = .roundedRect

        descriptionTextField.placeholder = "Описание (необязательно)"
        descriptionTextField.borderStyle = .roundedRect

        categoryTextField.placeholder = "Категория (например, Работа)"
        categoryTextField.borderStyle = .roundedRect

        prioritySegmented.selectedSegmentIndex = 1

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact

        let dateRow = UIStackView(arrangedSubviews: [makeLabel("Дата:"), datePicker])
        dateRow.axis = .horizontal
        dateRow.spacing = 12
        dateRow.alignment = .center

        let priorityRow = UIStackView(arrangedSubviews: [makeLabel("Приоритет:"), prioritySegmented])
        priorityRow.axis = .vertical
        priorityRow.spacing = 6
        priorityRow.alignment = .fill

        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            descriptionTextField,
            categoryTextField,
            priorityRow,
            dateRow,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTask() {
        guard let titleText = titleTextField.text, !titleText.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Введите название задачи")
            return
        }

        let priority = Priority.allCases[prioritySegmented.selectedSegmentIndex]
        let category = categoryTextField.text?.isEmpty == false ? categoryTextField.text! : "Общее"

        let newTask = TaskItem(
            title: titleText,
            taskDescription: descriptionTextField.text,
            dueDate: datePicker.date,
            category: category,
            priority: priority
        )

        onTaskAdded?(newTask)
        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
