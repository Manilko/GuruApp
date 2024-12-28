//
//  FavoritesView.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

protocol FavoritesViewProtocol: UIView {
    var tableView: UITableView { get }
    var deleteAllButton: UIButton { get }
    var emptyLabel: UILabel { get }
}

class FavoritesView: UIView, FavoritesViewProtocol {
    
    // MARK: - Properties
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Naming.headerFavoritesView
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Naming.deleteAllButtonTitle, for: .normal)
        button.setTitleColor(.favoritePink, for: .normal)
        button.isHidden = true
        return button
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Naming.emptyLabelText
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        addSubview(headerLabel)
        addSubview(tableView)
        addSubview(deleteAllButton)
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 64),
            
            deleteAllButton.widthAnchor.constraint(equalToConstant: 100),
            deleteAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteAllButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2),
            deleteAllButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: deleteAllButton.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),

            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
