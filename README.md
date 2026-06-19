# TaskFlow

iOS-приложение для управления задачами. Написано на **UIKit без storyboard** (programmatic UI) с использованием замыканий (closures) и асинхронного кода (async/await + actor).

## Технологии

- **UIKit** — вся вёрстка кодом через `NSLayoutConstraint` / `UIStackView`
- **Swift Concurrency** — `actor`, `async`/`await`, `Task { }`
- **Closures** — передача данных между экранами

## Экраны

| Экран | Описание |
|---|---|
| Сегодня | Задачи на сегодня, pull-to-refresh, свайп для удаления |
| Все задачи | Полный список с фильтром: Все / Активные / Готово |
| Категории | Список категорий → детальный экран по категории |
| Статистика | Прогресс-бар + 4 карточки с показателями |
| Настройки | Переключение тёмной/светлой темы, сброс, «О приложении» |
| Новая задача | Модальный экран, возврат данных через closure |

## Структура проекта

```
TaskFlow/
├── Models/
│   └── File.swift                   # TaskItem, Priority
├── Services/
│   └── TaskService.swift            # actor — хранилище задач, async API
├── Views/
│   └── TaskTableViewCell.swift      # кастомная ячейка UITableView
├── ViewControllers/
│   ├── MainTabBarController.swift
│   ├── TodayViewController.swift
│   ├── AllTasksViewController.swift
│   ├── CategoriesViewController.swift
│   ├── StatsViewController.swift
│   ├── SettingsViewController.swift
│   └── AddTaskViewController.swift
├── AppDelegate.swift
└── SceneDelegate.swift
```

## Как запустить

1. Открыть `TaskFlow.xcodeproj` в Xcode 15+
2. Выбрать симулятор iPhone (iOS 16+)
3. `Cmd+R`
