//
//  SearchViewController.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - UI Elements

    private lazy var sortButton = UIBarButtonItem(image: Constants.SystemImage.sortIcon.image,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapSortButton))

    private let loadingIndicator = UIActivityIndicatorView(style: .large).configure {
        $0.startAnimating()
    }

    private let tableView = UITableView().configure {
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
    }

    private let searchBar = UISearchBar().configure {
        $0.showsCancelButton = true
        $0.placeholder = LocalizedKey.searchPlaceholder.localizedString
        $0.textContentType = .none
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartQuotesType = .no
    }

    private let noSearchResultsLabel = UILabel().configure {
        $0.text = LocalizedKey.noResultsLabel.localizedString
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .systemGray
        $0.isHidden = true
    }

    private let refreshControl = UIRefreshControl().configure {
        $0.attributedTitle = NSAttributedString(string: LocalizedKey.pullToRefresh.localizedString)
    }

    // MARK: - Properties

    weak var coordinator: MainCoordinatorProtocol?
    private let viewModel: SearchViewModelProtocol
    private let checkedActionSheetKey = "checked"
    private let cellToScreenHeightRatio: CGFloat = 1 / 3
    private let mediumPadding = Constants.StyleDefaults.mediumPadding

    private var isLoading = false {
        didSet {
            if isLoading {
                showLoadingIndicator()
            } else {
                setupSortingButton()
            }
        }
    }

    // MARK: - Initialization

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedKey.searchScreenTitle.localizedString
        setupSortingButton()
        setupSearchBar()
        setupTableView()
        setupNoDataLabel()
        setupErrorCallback()
        fetchMovies()
    }

    // MARK: - Actions

    @objc private func refreshTableView() {
        fetchMovies(withReload: true)
    }

    @objc private func didTapSortButton() {
        let alertController = UIAlertController(title: nil,
                                                message: LocalizedKey.sortOptionsTitle.localizedString,
                                                preferredStyle: .actionSheet)
        for (index, option) in viewModel.sortOptions.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.viewModel.selectSortOption(atIndex: index)
                self?.tableView.reloadData()
            }
            if index == viewModel.sortOption.rawValue {
                action.setValue(true, forKey: checkedActionSheetKey)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: LocalizedKey.sortOptionsCancelButton.localizedString,
                                                style: .cancel))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sortButton
        }

        present(alertController, animated: true)
    }

    // MARK: - Reload

    private func fetchMovies(withReload reload: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        viewModel.getMovies(withReload: reload) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.setupNoDataLabel()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
    }

    private func setupErrorCallback() {
        viewModel.onErrorOccurred = { [weak self] error in
            guard let self, let error else { return }
            DispatchQueue.main.async {
                self.tableView.contentOffset = .zero
                self.coordinator?.showAlert(message: error)
            }
        }
    }

    // MARK: - Setup

    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        searchBar.delegate = self
    }

    private func setupTableView() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.safeAreaLayoutGuide.layoutFrame.height * cellToScreenHeightRatio
        view.addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }

    private func setupNoDataLabel() {
        noSearchResultsLabel.isHidden = viewModel.numberOfItems > 0
        view.addSubview(noSearchResultsLabel)
        noSearchResultsLabel.anchor(top: tableView.topAnchor,
                                    left: view.leftAnchor,
                                    bottom: tableView.centerYAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: mediumPadding,
                                    paddingLeft: mediumPadding,
                                    paddingRight: mediumPadding)
    }

    private func setupSortingButton() {
        navigationItem.rightBarButtonItem = sortButton
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.numberOfItems,
              let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SearchTableViewCell,
              let movie = viewModel.movies.safeElement(at: indexPath.row)
        else { return UITableViewCell() }
        cell.configure(with: movie)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getDetailsForMovie(atIndex: indexPath.row) { [weak self] movieDetails in
            guard let self, let movieDetails else { return }
            self.coordinator?.showDetails(for: movieDetails)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.numberOfItems - Int(1 / cellToScreenHeightRatio) * 2
        if indexPath.row == lastIndex && !isLoading && viewModel.canLoadMoreData {
            fetchMovies()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.cancelSearch()
        setupNoDataLabel()
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.contentOffset = .zero
        viewModel.setSearch(query: searchBar.text ?? "")
        fetchMovies()
    }
}
