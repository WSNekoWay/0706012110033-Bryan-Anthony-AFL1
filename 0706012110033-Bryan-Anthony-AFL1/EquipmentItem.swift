//
//  EquipmentItem.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation


//struct equipment inherit from item protocol
struct EquipmentItem: Equatable, Item {
    let name: String
    let type: String
    let damage: Int
    let price: Int
    var owned: Int
    var equipped: Bool
}
//Array equipment
var equipments: [EquipmentItem] = [
    EquipmentItem(name: "Old Rusty Sword", type: "Hand", damage: 15, price: 10, owned: 1, equipped: true),
    EquipmentItem(name: "Newbie Luck", type: "Accessory", damage: 300, price: 0, owned: 1, equipped: true),
    EquipmentItem(name: "Mask of Madness", type: "Head", damage: 100, price: 50, owned: 1, equipped: true),
    EquipmentItem(name: "Zeus Lightning", type: "Hand", damage: 300, price: 500, owned: 0, equipped: false),
    EquipmentItem(name: "Hades Armor", type: "Armor", damage: 200, price: 400, owned: 0, equipped: false),
    EquipmentItem(name: "King's Sword Legacy", type: "Hand", damage: 100, price: 150, owned: 0, equipped: false),
    EquipmentItem(name: "Zephyr Boots", type: "Boots", damage: 250, price: 500, owned: 0, equipped: false),
    EquipmentItem(name: "Peasant Armor", type: "Armor", damage: 50, price: 20, owned: 0, equipped: false),
    EquipmentItem(name: "Knight Boots", type: "Boots", damage: 100, price: 40, owned: 0, equipped: false),
]

//buyEquipment function
func buyEquipment(index: Int, player: inout Player, equipment: inout [EquipmentItem]) {
    guard index < equipment.count else {
        print("Invalid index")
        return
    }
    
    let item = equipment[index]
    if player.coin >= item.price {
        player.coin -= item.price
        equipment[index].owned += 1
        print("You have bought a \(item.name)")
    } else {
        print("You don't have enough coins to buy this equipment.")
    }
}

//sell equipment in blacksmith function
func sellEquipment(index: Int, player: inout Player, equipment: inout [EquipmentItem]) {
    
    if equipment[index].owned > 0 {
        
        let salePrice = equipment[index].price
        player.coin += salePrice
        
        equipment[index].owned -= 1
        if equipment[index].owned == 0{
            equipment[index].equipped = false
        }
        
       
        print("You have successfully sold the \(equipment[index].name) for \(salePrice) coins.")
    } else {
       
        print("You don't own the \(equipment[index].name) and cannot sell it.")
    }
}
//function for user equiping their equipment
func toggleEquip(index: Int, equipment: inout [EquipmentItem]) {
    if index >= 0 && index < equipment.count {
        let selected = equipment[index]
        let type = selected.type
        let owned = equipment.filter { $0.type == type && ($0.owned != 0) }
        
        let equipped = equipment.filter { $0.type == type && $0.equipped }
        
        if owned.count > 0 {
            equipment[index].equipped = !equipment[index].equipped
            
            if equipped.count > 0 && equipped[0].name != selected.name {
                let equippedIndex = equipment.firstIndex(of: equipped[0])!
                equipment[equippedIndex].equipped = false
            }
        }else{
            print("Invalid input!")
        }
    }
    else{
        print("Invalid input!")
    }
}
