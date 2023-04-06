//
//  Player.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation


class Player: Character {
    var mana: Int
    var maxMana: Int
    var coin: Int
    var equipment: [EquipmentItem]
    var consumable: [ConsumableItem]
    var material: [MaterialItem]
    
    init(name: String, health: Int = 50, maxHealth: Int = 100, mana: Int = 50, maxMana: Int = 50, coin: Int = 100, equipment: [EquipmentItem], consumable: [ConsumableItem], material: [MaterialItem]) {
        self.mana = mana
        self.maxMana = maxMana
        self.coin = coin
        self.equipment = equipment
        self.consumable = consumable
        self.material = material
        super.init(name: name, health: health, maxHealth: maxHealth)
    }
    //function for user to check their stats
    func checkStats() -> String {
        print("""
            Player name: \(name)
            
            HP: \(health)/\(maxHealth)
            MP: \(mana)/\(maxMana)
            
            Action:
            -Physical Attack. No mana required. Deal 5pt damage.
            -Meteor. Use 15pt of MP. Deal 50pt damage.
            -Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
            
            Items:
            """)
        print("""
            Press [return] to go back:
            """,terminator: "")
        let newChoice = readLine()!.lowercased()
        if newChoice == "" {
            return "out"
        } else {
            return "c"
        }
    }
    func heal(menuOption:String) {
        
            while choice == menuOption {
                let availablePotions = consumable.filter { $0.type == "Potion" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
                
                print("Available Potions:")
                for (index, potion) in availablePotions.enumerated() {
                    print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
                }
                
                print("Choose a potion to use (or [return] to exit):", terminator: "")
                choice = readLine()!.lowercased()
                
                if let potionIndex = Int(choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                    let potion = availablePotions[potionIndex - 1]
                    health = usePotion(potion: potion, health: health, maxHealth: maxHealth, consumable: &consumable)
                }
                
                if choice == "" {
                    choice = "out"
                } else {
                    choice = menuOption
                }
            }
    }
    func manaRecovery(menuOption:String) {
        while choice == menuOption {
            let availableElixirs = consumable.filter { $0.type == "Elixir" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }
            print("Available Elixirs:")
            for (index, elixir) in availableElixirs.enumerated() {
                print("[\(index + 1)] \(elixir.name) (\(elixir.value) MP) (x\(elixir.owned))")
            }
            print("Choose an elixir to use (or [return] to exit):", terminator: "")
            guard let input = readLine()?.lowercased(), !input.isEmpty else {
                choice = "out"
                continue
            }
            choice = input
            if let elixirIndex = Int(choice), elixirIndex > 0 && elixirIndex <= availableElixirs.count {
                let elixir = availableElixirs[elixirIndex - 1]
                mana = useElixir(elixir: elixir, mana: mana, maxMana: maxMana, consumable: &consumable)
            }
            if choice == "" {
                choice = "out"
            } else {
                choice = menuOption
            }
        }
    }
    
    func showInventory() {
            while choice == "i" {
                print("""
                    You open your inventory and you want to search for:
                    [E]quipment
                    [M]aterial
                    [C]onsumable
                    [B]ack
                    Coins:\(coin)
                    Your choice?
                    """)
                choice = readLine()!.lowercased()
                
                if choice == "e" {
                    while choice == "e" {
                        print("Your Equipment List:")
                        for (i, item) in equipment.enumerated() {
                            print("Equipment \(i + 1):")
                            print("\tType: \(item.type)")
                            print("\tName: \(item.name)")
                            print("\tDamage: \(item.damage)")
                            print("\tPrice: \(item.price)")
                            print("\tOwned: \(item.owned)")
                            if item.equipped {
                                print("\tEquipped")
                            } else {
                                print("\tNot Equipped")
                            }
                            print("")
                        }
                        
                        print("Press [return] to go back or choose equipment you want to equip or  unequip:",terminator: "")
                        choice = readLine()!.lowercased()
                        if choice == "" {
                            choice = "i"
                        } else if var ind = Int(choice) {
                            if ind >= 1 && ind <= equipment.count {
                                ind -= 1
                                toggleEquip(index: ind, equipment: &equipment)
                            } else {
                                print("Invalid index")
                            }
                            choice = "e"
                        } else {
                            print("Please choose the right number option!")
                            print("")
                            choice = "e"
                        }
                    }
                } else if choice == "m" {
                    print("Your Material List:")
                    for item in material {
                        print("\(item.name):")
                        print("\tQuantity: \(item.owned)")
                        print("\tPrice: \(item.price)")
                        print("")
                    }
                    choice = "i"
                } else if choice == "c" {
                    let availablePotions = consumable.filter { $0.type == "Potion" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
                    let availableElixirs = consumable.filter { $0.type == "Elixir" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }
                    
                    print("Available Potions:")
                    for (index, potion) in availablePotions.enumerated() {
                        print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
                    }
                    
                    print("Available Elixirs:")
                    for (index, elixir) in availableElixirs.enumerated() {
                        print("[\(index + 1)] \(elixir.name) (\(elixir.value) MP) (x\(elixir.owned))")
                    }
                    choice = "i"
                } else if choice == "b" {
                    choice = "out"
                } else {
                    choice = "i"
                    print("Invalid option!")
                    print("")
                }
            }
        }

}
