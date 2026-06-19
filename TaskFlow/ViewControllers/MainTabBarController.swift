import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let today = wrapInNav(
            TodayViewController(),
            title: "Сегодня",
            systemImage: "calendar"
        )

        let all = wrapInNav(
            AllTasksViewController(),
            title: "Все",
            systemImage: "list.bullet"
        )

        let categories = wrapInNav(
            CategoriesViewController(),
            title: "Категории",
            systemImage: "folder"
        )

        let stats = wrapInNav(
            StatsViewController(),
            title: "Статистика",
            systemImage: "chart.bar.fill"
        )

        let settings = wrapInNav(
            SettingsViewController(),
            title: "Настройки",
            systemImage: "gearshape.fill"
        )

        viewControllers = [today, all, categories, stats, settings]

        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }

    private func wrapInNav(_ vc: UIViewController, title: String, systemImage: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: systemImage), tag: 0)
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
}
