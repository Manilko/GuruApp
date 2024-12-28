//
//  NibCapable.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

protocol NibCapable: AnyObject {
    static var identifier: String { get }
    static func nib() -> UINib
}

extension NibCapable {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
