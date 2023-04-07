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
        
        while game.choice == menuOption {
            let availablePotions = consumable.filter { $0.type == "Potion" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
            
            print("Available Potions:")
            for (index, potion) in availablePotions.enumerated() {
                print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
            }
            
            print("Choose a potion to use (or [return] to exit):", terminator: "")
            game.choice = readLine()!.lowercased()
            
            if let potionIndex = Int(game.choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                let potion = availablePotions[potionIndex - 1]
                health = usePotion(potion: potion, health: health, maxHealth: maxHealth, consumable: &consumable)
            }
            
            if game.choice == "" {
                game.choice = "out"
            } else {
                print("Invalid input!")
                game.choice = menuOption
            }
        }
    }
    func manaRecovery(menuOption:String) {
        while game.choice == menuOption {
            let availableElixirs = consumable.filter { $0.type == "Elixir" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }
            print("Available Elixirs:")
            for (index, elixir) in availableElixirs.enumerated() {
                print("[\(index + 1)] \(elixir.name) (\(elixir.value) MP) (x\(elixir.owned))")
            }
            print("Choose an elixir to use (or [return] to exit):", terminator: "")
            guard let input = readLine()?.lowercased(), !input.isEmpty else {
                game.choice = "out"
                continue
            }
            game.choice = input
            if let elixirIndex = Int(game.choice), elixirIndex > 0 && elixirIndex <= availableElixirs.count {
                let elixir = availableElixirs[elixirIndex - 1]
                mana = useElixir(elixir: elixir, mana: mana, maxMana: maxMana, consumable: &consumable)
            }
            if game.choice == "" {
                game.choice = "out"
            } else {
                print("Invalid input!")
                game.choice = menuOption
            }
        }
    }
    
    func showInventory() {
        while game.choice == "i" {
            print("""
                    You open your inventory and you want to search for:
                    [E]quipment
                    [M]aterial
                    [C]onsumable
                    [B]ack
                    Coins:\(coin)
                    Your choice?
                    """)
            game.choice = readLine()!.lowercased()
            
            if game.choice == "e" {
                while game.choice == "e" {
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
                    game.choice = readLine()!.lowercased()
                    if game.choice == "" {
                        game.choice = "i"
                    } else if var ind = Int(game.choice) {
                        if ind >= 1 && ind <= equipment.count {
                            ind -= 1
                            toggleEquip(index: ind, equipment: &equipment)
                        } else {
                            print("Invalid index")
                        }
                        game.choice = "e"
                    } else {
                        print("Please choose the right number option!")
                        print("")
                        game.choice = "e"
                    }
                }
            } else if game.choice == "m" {
                print("Your Material List:")
                for item in material {
                    print("\(item.name):")
                    print("\tQuantity: \(item.owned)")
                    print("\tPrice: \(item.price)")
                    print("")
                }
                game.choice = "i"
            } else if game.choice == "c" {
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
                game.choice = "i"
            } else if game.choice == "b" {
                game.choice = "out"
            } else {
                game.choice = "i"
                print("Invalid option!")
                print("")
            }
        }
    }
    func townFeature() {
        
        while game.choice == "g" {
            print("""
                Welcome to the town!
                Coins: \(coin)
                From here you can go to:
                [1] Blacksmith
                [2] Alchemist
                [3] Adventure Guild
                Press [return] to go back!
                Your choice?
                """)
            game.choice = readLine()!.lowercased()
            switch game.choice {
            case "1":
                blacksmithFeature()
            case "2":
                alchemistFeature()
            case "3":
                adventureGuildFeature()
            case "":
                game.choice = "out"
            default:
                game.choice = "g"
                print("Invalid input!")
                print("Please input the right option!")
                print("")
            }
        }
    }
    
    func blacksmithFeature() {
        while game.choice == "1" {
            var player = self
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
            print("""
                Coins: \(coin)
                You can:
                [B]uy
                [S]ell
                The equipment or you can press [return] to go back, what do you want to do?
                """)
            game.choice = readLine()!.lowercased()
            switch game.choice {
            case "":
                game.choice = "g"
            case "b":
                print("Enter the index of the equipment to buy:")
                let index = Int(readLine()!)! - 1
                buyEquipment(index: index, player: &player, equipment: &equipment)
                game.choice = "1"
            case "s":
                print("Enter the index of the equipment to sell:")
                let index = Int(readLine()!)! - 1
                sellEquipment(index: index, player: &player, equipment: &equipment)
                game.choice = "1"
            default:
                print("Invalid option.")
                print("")
                game.choice = "1"
            }
        }
    }
    func alchemistFeature() {
        
        while game.choice == "2" {
            print("Available Consumables:")
            var availableConsumables: [(index: Int, item: ConsumableItem)] = []
            for (index, consumable) in consumable.enumerated() {
                availableConsumables.append((index: index, item: consumable))
                print("[\(availableConsumables.count)] \(consumable.name) (\(consumable.effect): \(consumable.value)) (owned: x\(consumable.owned)) - \(consumable.price) gold")
            }
            print("""
                Coins: \(coin)
                You can:
                [B]uy
                [S]ell
                The consumable or you can press [return] to go back, what do you want to do?
                """)
            game.choice = readLine()?.lowercased() ?? ""
            switch game.choice {
            case "":
                game.choice = "g"
            case "b":
                print("Which consumable do you want to buy? (input number or [return] to go back)")
                if let input = readLine(), let index = Int(input), index > 0 && index <= availableConsumables.count {
                    var selectedConsumable = availableConsumables[index - 1].item
                    if coin >= selectedConsumable.price {
                        coin -= selectedConsumable.price
                        selectedConsumable.owned += 1
                        print("You bought 1 \(selectedConsumable.name) for \(selectedConsumable.price) gold.")
                        consumable[availableConsumables[index-1].index] = selectedConsumable
                    } else {
                        print("You don't have enough coins to buy \(selectedConsumable.name).")
                    }
                }
                game.choice = "2"
            case "s":
                print("Which consumable do you want to sell? (input number or [return] to go back)")
                if let input = readLine(), let index = Int(input), index > 0 && index <= availableConsumables.count {
                    var selectedConsumable = availableConsumables[index - 1].item
                    if selectedConsumable.owned > 0 {
                        coin += selectedConsumable.price
                        selectedConsumable.owned -= 1
                        print("You sold 1 \(selectedConsumable.name) for \(selectedConsumable.price) gold.")
                        consumable[availableConsumables[index-1].index] = selectedConsumable
                    } else {
                        print("You don't have any \(selectedConsumable.name) to sell.")
                    }
                }
                game.choice = "2"
            default:
                print("Invalid option.")
                print("")
                game.choice = "2"
            }
        }
    }
    
    func adventureGuildFeature() {
        
        while game.choice == "3" {
            print("Available Adventure Materials:")
            var availableMaterials: [(index: Int, item: MaterialItem)] = []
            
            for (index, material) in material.enumerated() {
                availableMaterials.append((index: index, item: material))
                print("[\(availableMaterials.count)] \(material.name) (owned: x\(material.owned)) - \(material.price) gold")
            }
            print("""
                Coins: \(coin)
                You can:
                [S]ell
                The material or you can press [return] to go back, what do you want to do?
                """)
            game.choice = readLine()?.lowercased() ?? ""
            switch game.choice {
            case "":
                game.choice = "g"
            case "s":
                print("Which material do you want to sell? (input number or [return] to go back)")
                if let input = readLine(), let index = Int(input), index > 0 && index <= availableMaterials.count {
                    var selectedMaterial = availableMaterials[index - 1].item
                    if selectedMaterial.owned > 0 {
                        coin += selectedMaterial.price
                        selectedMaterial.owned -= 1
                        print("You sold 1 \(selectedMaterial.name) for \(selectedMaterial.price) gold.")
                        material[availableMaterials[index-1].index] = selectedMaterial
                    } else {
                        print("You don't have any \(selectedMaterial.name) to sell.")
                    }
                }
                game.choice = "3"
            default:
                game.choice = "3"
                print("Invalid option.")
                print("")
            }
        }
        
        
    }
}
