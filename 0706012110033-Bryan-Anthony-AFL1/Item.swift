//
//  item.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation

protocol Item {
    var name: String { get }
    var owned: Int { get set }
    var price: Int { get }
}
