import UIKit

class ViewController: UITabBarController {
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            try await KeyAccess.loadAPIKeys()
            setupTabs()
        }
    }
    
    private func setupTabs() {
        let moviesViewController = UINavigationController(rootViewController: MoviesViewController())
        let favoriteMoviesViewController = UINavigationController(rootViewController: FavoritesMoviesViewController())
        
        moviesViewController.tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "movieclapper"),
            selectedImage: UIImage(systemName: "movieclapper.fill")
        )
        
        favoriteMoviesViewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        
        viewControllers = [moviesViewController, favoriteMoviesViewController]
    }
}
