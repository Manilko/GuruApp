//
//  ItemListView.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

protocol ItemListViewProtocol: UIView {
    var tableView: UITableView { get }
    var removeAllFavoritesButton: UIButton { get }
}

class ItemListView: UIView, ItemListViewProtocol {

    // MARK: - Properties
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.headerItemView
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let removeAllFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.removeFavoritesButtonTitle, for: .normal)
        button.setTitleColor(Asset.Colors.favoritePink1.color, for: .normal)
        button.isHidden = true
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white

        addSubview(headerLabel)
        addSubview(tableView)
        addSubview(removeAllFavoritesButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 64),
            
            removeAllFavoritesButton.widthAnchor.constraint(equalToConstant: 100),
            removeAllFavoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            removeAllFavoritesButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2),
            removeAllFavoritesButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: removeAllFavoritesButton.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120)
        ])

    }
}
