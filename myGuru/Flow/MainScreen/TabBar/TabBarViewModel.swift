//
//  TabBarViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import RxSwift
import RxCocoa

protocol TabBarViewModelProtocol: AnyObject {
    var input: TabBarViewModel.Input { get }
    var output: TabBarViewModel.Output { get }
}

class TabBarViewModel: TabBarViewModelProtocol {

    struct Input {
        let selectTab: Observable<Int>
    }

    struct Output {
        let tabBarItems: [TabBarItemType]
        let selectedIndex: Observable<Int>
    }

    // MARK: - Properties
    let input: Input
    lazy var output: Output = {
        Output(
            tabBarItems: tabBarItems,
            selectedIndex: selectedIndexSubject.asObservable()
        )
    }()

    private let tabBarItems: [TabBarItemType]
    private let selectedIndexSubject = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    // MARK: - Initializer
    init(tabBarItems: [TabBarItemType]) {
        self.tabBarItems = tabBarItems

        let selectTabSubject = PublishSubject<Int>()
        self.input = Input(selectTab: selectTabSubject)

        selectTabSubject
            .filter { [weak self] index in
                guard let self = self else { return false }
                return index >= 0 && index < self.tabBarItems.count
            }
            .bind(to: selectedIndexSubject)
            .disposed(by: disposeBag)
    }
}
