//
//  TownFeatures.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 06/04/23.
//

import Foundation

func townFeature(player: inout Player) {
    
    while choice == "g" {
        print("""
            Welcome to the town!
            Coins: \(player.coin)
            From here you can go to:
            [1] Blacksmith
            [2] Alchemist
            [3] Adventure Guild
            Press [return] to go back!
            Your choice?
            """)
        choice = readLine()!.lowercased()
        switch choice {
        case "1":
            blacksmithFeature(player: &player)
        case "2":
            alchemistFeature(player: &player)
        case "3":
            adventureGuildFeature(player: &player)
        case "":
            choice = "out"
        default:
            choice = "g"
            print("Invalid input!")
            print("Please input the right option!")
            print("")
        }
    }
}

func blacksmithFeature(player: inout Player) {
    while choice == "1" {
        print("Your Equipment List:")
        for (i, item) in player.equipment.enumerated() {
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
            Coins: \(player.coin)
            You can:
            [B]uy
            [S]ell
            The equipment or you can press [return] to go back, what do you want to do?
            """)
        choice = readLine()!.lowercased()
        switch choice {
        case "":
            choice = "g"
        case "b":
            print("Enter the index of the equipment to buy:")
            let index = Int(readLine()!)! - 1
            buyEquipment(index: index, player: &player, equipment: &player.equipment)
            choice = "1"
        case "s":
            print("Enter the index of the equipment to sell:")
            let index = Int(readLine()!)! - 1
            sellEquipment(index: index, coins: &player.coin, equipment: &player.equipment)
            choice = "1"
        default:
            print("Invalid option.")
            print("")
            choice = "1"
        }
    }
}
func alchemistFeature(player: inout Player) {
    
    while choice == "2" {
        print("Available Consumables:")
        var availableConsumables: [(index: Int, item: ConsumableItem)] = []
        for (index, consumable) in player.consumable.enumerated() {
            availableConsumables.append((index: index, item: consumable))
            print("[\(availableConsumables.count)] \(consumable.name) (\(consumable.effect): \(consumable.value)) (owned: x\(consumable.owned)) - \(consumable.price) gold")
        }
        print("""
            Coins: \(player.coin)
            You can:
            [B]uy
            [S]ell
            The consumable or you can press [return] to go back, what do you want to do?
            """)
        choice = readLine()?.lowercased() ?? ""
        switch choice {
        case "":
            choice = "g"
        case "b":
            print("Which consumable do you want to buy? (input number or [return] to go back)")
            if let input = readLine(), let index = Int(input), index > 0 && index <= availableConsumables.count {
                var selectedConsumable = availableConsumables[index - 1].item
                if player.coin >= selectedConsumable.price {
                    player.coin -= selectedConsumable.price
                    selectedConsumable.owned += 1
                    print("You bought 1 \(selectedConsumable.name) for \(selectedConsumable.price) gold.")
                    player.consumable[availableConsumables[index-1].index] = selectedConsumable
                } else {
                    print("You don't have enough coins to buy \(selectedConsumable.name).")
                }
            }
            choice = "2"
        case "s":
            print("Which consumable do you want to sell? (input number or [return] to go back)")
            if let input = readLine(), let index = Int(input), index > 0 && index <= availableConsumables.count {
                var selectedConsumable = availableConsumables[index - 1].item
                if selectedConsumable.owned > 0 {
                    player.coin += selectedConsumable.price
                    selectedConsumable.owned -= 1
                    print("You sold 1 \(selectedConsumable.name) for \(selectedConsumable.price) gold.")
                    player.consumable[availableConsumables[index-1].index] = selectedConsumable
                } else {
                    print("You don't have any \(selectedConsumable.name) to sell.")
                }
            }
            choice = "2"
        default:
            print("Invalid option.")
            print("")
            choice = "2"
        }
    }
}

func adventureGuildFeature(player: inout Player) {

    while choice == "2" {
        print("Available Adventure Materials:")
        var availableMaterials: [(index: Int, item: MaterialItem)] = []
        
        for (index, material) in player.material.enumerated() {
            availableMaterials.append((index: index, item: material))
            print("[\(availableMaterials.count)] \(material.name) (owned: x\(material.owned)) - \(material.price) gold")
        }
        print("""
            Coins: \(player.coin)
            You can:
            [S]ell
            The material or you can press [return] to go back, what do you want to do?
            """)
        choice = readLine()?.lowercased() ?? ""
        switch choice {
        case "":
            choice = "g"
        case "s":
            print("Which material do you want to sell? (input number or [return] to go back)")
            if let input = readLine(), let index = Int(input), index > 0 && index <= availableMaterials.count {
                var selectedMaterial = availableMaterials[index - 1].item
                if selectedMaterial.owned > 0 {
                    player.coin += selectedMaterial.price
                    selectedMaterial.owned -= 1
                    print("You sold 1 \(selectedMaterial.name) for \(selectedMaterial.price) gold.")
                    player.material[availableMaterials[index-1].index] = selectedMaterial
                } else {
                    print("You don't have any \(selectedMaterial.name) to sell.")
                }
            }
            choice = "3"
        default:
            print("Invalid option.")
            print("")
        }
    }
}
