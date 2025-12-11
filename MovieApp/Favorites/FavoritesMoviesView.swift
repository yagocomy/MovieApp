import UIKit
import MovieAppUI

protocol FavoritesMoviesViewDelegate: AnyObject {
    func didPressLike(isLike: Bool, index: Int)
}

final class FavoritesMoviesView: UIView {
    
    // MARK: - Data
    var data: [MoviesPersistentModel]? = nil {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    // MARK: - UI
    
    private let favoritesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Here is your favorite movies."
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.bouncesVertically = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    weak var delegate: MoviesViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(favoritesLabel)
        addSubview(moviesTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favoritesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            favoritesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            favoritesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            moviesTableView.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 16),
            moviesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func showMessage() {
        moviesTableView.setEmptyMessage("Oops, something went wrong!!!")
    }
    
    func showEmptyMessage(hideMessage: Bool) {
        moviesTableView.setEmptyMessage("You haven't favorited any movies yet.", showMessage: hideMessage)
    }
}

extension FavoritesMoviesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else {
            return 0
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.hideLikeButton = true
        
        cell.setupData(
            image: data![indexPath.row].results.posterPath,
            title: data![indexPath.row].results.title,
            description: data![indexPath.row].results.overview,
            index: indexPath.row,
            expanded: data![indexPath.row].results.isExpanded,
            hideLikeButton: true
        )
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        data![indexPath.row].results.isExpanded.toggle()

        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension FavoritesMoviesView: MovieTableViewCellDelegate {
    func didPressLike(isLiked: Bool, index: Int) {
        delegate?.didPressLike(isLike: isLiked, index: index)
    }
}
