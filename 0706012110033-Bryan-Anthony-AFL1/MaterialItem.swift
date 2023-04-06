//
//  materialitem.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation

//Struct material inherit from item protocol
struct MaterialItem: Equatable, Item {
    let name: String
    var owned: Int
    let price: Int
}

//Array material
var materials: [MaterialItem] = [
    MaterialItem(name: "Troll Claw", owned: 1, price: 2),
    MaterialItem(name: "Troll Rusty Dagger", owned: 0, price: 5),
    MaterialItem(name: "Troll Staff", owned: 0, price: 10),
    MaterialItem(name: "Golem Core", owned: 0, price: 20),
    MaterialItem(name: "Adamontium Stone", owned: 0, price: 50),
    MaterialItem(name: "Ordinary Rock", owned: 0, price: 1)
]

//sell material
func sellMaterial(index: Int, materials: inout [MaterialItem],coins : inout Int) {
    guard index < materials.count else {
        print("Invalid index")
        return
    }
    
    let item = materials[index]
    if item.owned > 0 {
        coins += item.price
        materials[index].owned -= 1
        print("You have sold a \(item.name)")
    } else {
        print("You don't have any of this material to sell.")
    }
}
