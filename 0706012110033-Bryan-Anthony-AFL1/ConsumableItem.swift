//
//  consumableitem.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation

//struct consumable inherit from item protocol
struct ConsumableItem: Equatable, Item {
    let name: String
    let type: String
    let effect: String
    let value: Int
    var owned: Int
    let price: Int
}

//Array consumable
var consumables: [ConsumableItem] = [
    ConsumableItem(name: "Low Grade Potion", type: "Potion", effect: "Heal", value: 10, owned: 0, price: 5),
    ConsumableItem(name: "Mid Grade Potion", type: "Potion", effect: "Heal", value: 20, owned: 20, price: 10),
    ConsumableItem(name: "High Grade Potion", type: "Potion", effect: "Heal", value: 40, owned: 0, price: 20),
    ConsumableItem(name: "Low Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 5, owned: 20, price: 5),
    ConsumableItem(name: "Mid Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 10, owned: 0, price: 10),
    ConsumableItem(name: "High Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 20, owned: 0, price: 20)
]

//function for use to heal him/herself using potion he/she choose
func usePotion(potion: ConsumableItem, health: Int, maxHealth: Int, consumable: inout [ConsumableItem]) -> Int {
    var newHealth = health
    let quantity = potion.owned
    
    guard let potionIndex = consumable.firstIndex(where: { $0.name == potion.name }), quantity > 0 else {
        print("You don't have any \(potion.name) left. Good luck and be careful in your journey!")
        return newHealth
    }
    
    var updatedConsumable = consumable
    updatedConsumable[potionIndex].owned = quantity - 1
    
    repeat {
        print("""
            Your HP is \(newHealth)
            You have \(quantity) Potions (\(potion.name))
            
            Are you sure you want to use 1 potion to heal your wounds? [Y/N]
            """)
        guard let choice = readLine()?.lowercased() else { continue }
        
        if choice == "y" {
            let heal = potion.value
            newHealth = min(newHealth + heal, maxHealth)
            print("You have been healed. Your new HP is \(newHealth).")
            if quantity == 1 {
                print("You have used up all your \(potion.name) potions.")
                
            }
            break
        } else if choice == "n" {
            break
        }
    } while true
    
    consumable = updatedConsumable
    return newHealth
}




//function for user to use elixir to recover mana with elixir that user choose
func useElixir(elixir: ConsumableItem, mana: Int, maxMana: Int, consumable: inout [ConsumableItem]) -> Int {
    var newMana = mana
    let quantity = elixir.owned
    
    guard let elixirIndex = consumable.firstIndex(where: { $0.name == elixir.name }), quantity > 0 else {
        print("You don't have any \(elixir.name) left. Good luck and be careful in your journey!")
        return newMana
    }
    
    var updatedConsumable = consumable
    updatedConsumable[elixirIndex].owned = quantity - 1
    
    repeat {
        print("""
            Your MP is \(newMana)
            You have \(quantity) Elixirs (\(elixir.name))
            
            Are you sure you want to use 1 elixir to restore your mana? [Y/N]
            """)
        guard let choice = readLine()?.lowercased() else { continue }
        
        if choice == "y" {
            let manaRestore = elixir.value
            newMana = min(newMana + manaRestore, maxMana)
            print("Your mana has been restored. Your new MP is \(newMana).")
            if quantity == 1 {
                print("You have used up all your \(elixir.name) elixirs.")
                
            }
            break
        } else if choice == "n" {
            break
        }
    } while true
    
    consumable = updatedConsumable
    return newMana
}

//buyConsumable
func buyConsumable(index: Int, consumable: inout [ConsumableItem], coins: inout Int) {
    guard index < consumable.count else {
        print("Invalid index")
        return
    }
    
    let item = consumable[index]
    if coins >= item.price {
        coins -= item.price
        consumable[index].owned += 1
        print("You have purchased a \(item.name)")
    } else {
        print("You don't have enough gold to buy this consumable item.")
    }
}
//sellConsumable
func sellConsumable(index: Int, consumable: inout [ConsumableItem], coins: inout Int) {
    guard index < consumable.count else {
        print("Invalid index")
        return
    }
    
    let item = consumable[index]
    if item.owned > 0 {
        coins += item.price
        consumable[index].owned -= 1
        print("You have sold a \(item.name)")
    } else {
        print("You don't have any of this consumable item to sell.")
    }
}
