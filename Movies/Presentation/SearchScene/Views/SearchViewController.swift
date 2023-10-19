//
//  SearchViewController.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//
// TODO: Draft

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

    private let noDataLabel = UILabel().configure {
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

    private let checkedActionSheetKey = "checked"
    private let cellToScreenHeightRatio: CGFloat = 1/3
    private let mediumPadding = Constants.StyleDefaults.mediumPadding
    private let viewModel: SearchViewModelProtocol
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
        reloadData()
    }

    // MARK: - Actions

    @objc private func refreshControlReload() {
        reloadData(reloadAll: true)
    }

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: nil,
                                      message: LocalizedKey.sortOptionsTitle.localizedString,
                                      preferredStyle: .actionSheet)
        SortOption.allCases.forEach { option in
            let action = UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.viewModel.selectSorting(option: option)
                self?.tableView.reloadData()
            }
            if option == viewModel.selectedSorting {
                action.setValue(true, forKey: checkedActionSheetKey)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: LocalizedKey.sortOptionsCancelButton.localizedString, style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Reload

    // TODO: fix?
    private func reloadData(reloadAll: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        viewModel.getMovies(reloadAll: reloadAll) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
                self?.setupNoDataLabel()
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
        refreshControl.addTarget(self, action: #selector(refreshControlReload), for: .valueChanged)
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
        view.addSubview(noDataLabel)
        noDataLabel.center(inView: tableView)
        noDataLabel.anchor(left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingLeft: mediumPadding,
                           paddingRight: mediumPadding)
    }

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
    }

    private func setupSortingButton() {
        navigationItem.rightBarButtonItem = sortButton
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToMovieDetail(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.movies.count - 1
        if indexPath.row == lastIndex && !isLoading {
            reloadData()
        }
    }
}

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
        viewModel.setSearchString(string: searchBar.text ?? "")
        reloadData()
    }
}
