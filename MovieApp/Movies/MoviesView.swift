import UIKit
import MovieAppUI

protocol MoviesViewDelegate: AnyObject {
    func didPressLike(isLike: Bool, index: Int)
}

final class MoviesView: UIView {
    
    // MARK: - Data
    var data: MoviesRequestModel? = nil {
        didSet {
            filteredResults = data?.results ?? []
            moviesTableView.reloadData()
        }
    }
    
    private var filteredResults: [Results] = []
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar filmes"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bouncesVertically = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private var index: Int = 0
    weak var delegate: MoviesViewDelegate?
    private var isExpanded: Bool = false
    
    
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
        addSubview(searchBar)
        addSubview(moviesTableView)
        
        searchBar.delegate = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 40),

            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            moviesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            moviesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Messages
    func showMessage() {
        moviesTableView.setEmptyMessage("Oops, it seems there is no movies today. Try Again later ;(")
    }
}

// MARK: - TableView DataSource & Delegate
extension MoviesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: MovieTableViewCell.identifier
                ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let item = filteredResults[indexPath.row]
        
        cell.setupData(
            image: item.posterPath,
            title: item.title,
            description: item.overview,
            index: indexPath.row,
            expanded: item.isExpanded
        )
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        filteredResults[indexPath.row].isExpanded.toggle()

        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - Cell Delegate
extension MoviesView: MovieTableViewCellDelegate {
    func didPressLike(isLiked: Bool, index: Int) {
        delegate?.didPressLike(isLike: isLiked, index: index)
    }
}

// MARK: - SearchBar Delegate
extension MoviesView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let allResults = data?.results else { return }
        
        if searchText.isEmpty {
            filteredResults = allResults
        } else {
            filteredResults = allResults.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        moviesTableView.reloadData()
    }
}
