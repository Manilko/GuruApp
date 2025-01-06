//
//  ServiceProvider.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import RxSwift
import RxCocoa

protocol ServiceProviderProtocol {
    var itemService: ItemServiceProtocol { get }
    var dataService: DataServiceProtocol { get }
}

class ServiceProvider: ServiceProviderProtocol {
    
    lazy var itemService: ItemServiceProtocol = {
        ItemService(dataService: dataService)
    }()
   
    lazy var dataService: DataServiceProtocol = {
        DataService.shared
    }()
}
