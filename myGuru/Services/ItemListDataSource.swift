//
//  ItemListDataSource.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxDataSources
import RxCocoa
import UIKit

class ItemListDataSource {
    private weak var favoriteButtonRelay: PublishRelay<Int>?

    init(favoriteButtonRelay: PublishRelay<Int>) {
        self.favoriteButtonRelay = favoriteButtonRelay
    }

    func create() -> RxTableViewSectionedReloadDataSource<SectionOfItems> {
        return RxTableViewSectionedReloadDataSource<SectionOfItems>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self = self else { return UITableViewCell() }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ItemTableViewCell.identifier,
                    for: indexPath
                ) as? ItemTableViewCell else {
                    fatalError("Unable to dequeue ItemTableViewCell")
                }

                cell.configure(with: item)

                if let relay = self.favoriteButtonRelay {
                    cell.bindFavoriteButton(to: relay, indexPath: indexPath.row)
                }

                return cell
            }
        )
    }
}
