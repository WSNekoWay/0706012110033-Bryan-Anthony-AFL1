//
//  main.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 03/03/23.
//

import Foundation

//struct
//Implementation of protocol Item and structs as parent and child (Inheritance)
protocol Item {
    var name: String { get }
    var owned: Int { get set }
    var price: Int { get }
}

struct EquipmentItem: Equatable, Item {
    let name: String
    let type: String
    let damage: Int
    let price: Int
    var owned: Int
    var equipped: Bool
}

struct MaterialItem: Equatable, Item {
    let name: String
    var owned: Int
    let price: Int
}

struct ConsumableItem: Equatable, Item {
    let name: String
    let type: String
    let effect: String
    let value: Int
    var owned: Int
    let price: Int
}

//let
let alphaOnlyRegex = "^[a-zA-Z]+$"
let predicate = NSPredicate(format:"SELF MATCHES %@",alphaOnlyRegex)

//global var
var relife=true
var end=false
var start=false
var username = ""
var choice:String



//func
//startGame
func startGame(start: inout Bool, username: inout String, predicate: NSPredicate) {
    //User first interface
    while !start {
        print("""
        ⛩️ Welcome to the New World ! ⛩️
        You have been chosen to embark on epic journey as a young adventurer on the path to become the greatest adventurer. Your adventures will take you through forests 🌲, mountains 🪨, and dungeons ⛓️, where you will face challenges, make allies, and fight enemies.
        Press [return] to continue:
        """, terminator: "")
        let choice = readLine()!
        if choice == "" {
            start = true
        }else{
            print("Invalid input please press [return] to continue")
            print("")
        }
    }
    //User second interface
    while username.isEmpty {
        print("May I know your name young adventurer ?")
        username = readLine()!
        if predicate.evaluate(with: username) {
            print("Nice name you have there, adventurer \(username)")
        } else {
            print("I didn't catch that!")
            print("Error, Can not accept numerical or symbolic input!")
            username = ""
        }
    }
    
    print("Let the adventure begin, \(username)!")
}

//function for user to check their stats
func checkStats(username: String, health: Int, maxhealth: Int, mana: Int, maxmana: Int, choice: String) -> String {
    print("""
        Player name: \(username)
        
        HP: \(health)/\(maxhealth)
        MP: \(mana)/\(maxmana)
        
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

//function for use to heal him/herself using potion he/she choose
func usePotion(potion: ConsumableItem, health: Int, maxHealth: Int, consumable: inout [ConsumableItem]) -> Int {
    var newHealth = health
    var quantity = potion.owned
    
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
                updatedConsumable.remove(at: potionIndex)
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
    var quantity = elixir.owned
    
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
                updatedConsumable.remove(at: elixirIndex)
            }
            break
        } else if choice == "n" {
            break
        }
    } while true
    
    consumable = updatedConsumable
    return newMana
}



//function for user to battle with monster based on the ecosystem they choose
func battleSequence(choice: String, maxhealth: inout Int, health: inout Int, mana: inout Int, maxmana: inout Int, consumable: inout [ConsumableItem], coin: inout Int, equipment: [EquipmentItem], material: inout[MaterialItem]) {
    var choice=choice
    var enemy = ""
    var doubledamage=false
    if(choice == "f"){
        enemy="Troll"
        print("""
            As you enter the forest, you feel a sense of unease wash over you.
            Suddenly, you hear the sound of twigs snapping behind you. You quickly spin around, and find a \(enemy) emerging from the shadows.
            
            """)
    }
    else if(choice == "m"){
        enemy="Golem"
        print("""
                    As you make you way through the rugged mountain terrain, you can feel the chill of the wind biting at your skin.
                    Suddenly, you hear a sound that makes you freeze in your tracks. That's when you see it - a massive, snarling Golem emerging from the shadows
                    
        """)
    }
    var enemyHealth = 1000
    var turn = "player"
    var block = false
    var totalEquipmentDamage = 0
    for item in equipment where item.equipped {
        totalEquipmentDamage += item.damage
    }
    let baseDamage = 5
    let totalDamage = baseDamage + totalEquipmentDamage
    while enemyHealth > 0 && health > 0 && choice != "7"{
        if turn == "player" {
            if doubledamage==true{
                print("""
                    😈 Name : \(enemy)
                    😈 Health: \(enemyHealth)
                    
                    Choose your action:
                    [1] Physical Attack. No mana required. Deal \(baseDamage*2)pt of damage + \(totalEquipmentDamage*2)pt from equipment you equip.
                    [2] Meteor. Use 15pt of MP. Deal 100pt of damage.
                    [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                    
                    [4] Heal yourself with potion.
                    [5] Drink elixir to recover mana.
                    [6] Scan enemy's vital.
                    [7] Flee from battle.
                    
                    Your Choice?
                    """)
                
            }else{
                print("""
                    😈 Name : \(enemy)
                    😈 Health: \(enemyHealth)
                    
                    Choose your action:
                    [1] Physical Attack. No mana required. Deal \(baseDamage)pt of damage + \(totalEquipmentDamage)pt from equipment you equip.
                    [2] Meteor. Use 15pt of MP. Deal 50pt of damage.
                    [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                    
                    [4] Heal yourself with potion.
                    [5] Drink elixir to recover mana.
                    [6] Scan enemy's vital.
                    [7] Flee from battle.
                    
                    Your Choice?
                    """)
            }
            choice = readLine()!
            
            switch choice {
            case "1":
                //Use Physical Attack to damage enemy with addition of equipment
                var totaldamage = totalDamage
                if doubledamage==true{
                    totaldamage=totalDamage*2
                }
                
                enemyHealth -= totaldamage
                print("You dealt \(totaldamage)pt of damage to \(enemy)!")
            case "2":
                //Use Meteor Skill to damage enemy
                if mana >= 15 {
                    if doubledamage==true{
                        enemyHealth -= 100
                    }else{
                        enemyHealth -= 50
                    }
                    
                    mana -= 15
                    print("You used Meteor and dealt 50pt of damage to \(enemy)!")
                } else {
                    print("Not enough mana!")
                }
            case "3":
                //Use shield to block enemy
                if mana >= 10 {
                    mana -= 10
                    print("You used Shield and blocked the enemy's attack for one turn!")
                    block=true
                } else {
                    print("Not enough mana!")
                }
            case "4":
                
                while choice == "4" {
                    let availablePotions = consumable.filter { $0.type == "Heal" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
                    
                    print("Available Potions:")
                    for (index, potion) in availablePotions.enumerated() {
                        print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
                    }
                    
                    print("Choose a potion to use (or [return] to exit):", terminator: "")
                    choice = readLine()!.lowercased()
                    
                    if let potionIndex = Int(choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                        let potion = availablePotions[potionIndex - 1]
                        health = usePotion(potion: potion, health: health, maxHealth: maxhealth, consumable: &consumable)
                    }
                    
                    if choice == "" {
                        choice = "out"
                    } else {
                        choice = "4"
                    }
                }
                
            case "5":
                //Mana Recovery
                while choice == "5" {
                                
                    let availableElixirs = consumable.filter { $0.type == "Mana Restore" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }

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
                        mana = useElixir(elixir: elixir, mana: mana, maxMana: maxmana, consumable: &consumable)
                    }
                    if choice == "" {
                        choice = "out"
                    } else {
                        choice = "5"
                    }
                }
                
            case "6":
                //Vital Scan Feature (On Progress)
                print("You found enemy weakness! Your damage to enemy will be more effective 100 percent!")
                doubledamage=true
                
            case "7":
                //Flee From The Battle
                print("""
                        You feel that if you don't escape soon, you won't be able to continue the fight.
                        You look around frantically, searching for a way out. You sprint towards the exit, your heart pounding in your chest.
                        
                        You're safe, for now.
                        """)
                return
            default:
                print("Invalid Input (Input must be numerical and not outside of the option!)")
                continue
            }
            
            if enemyHealth <= 0 {
                //Enemy defeated
                print("The beast has been defeated!")
                let randomCoin = Int.random(in: 1...100)
                coin+=randomCoin
                if enemy == "Troll" {
                    material[0].owned += 1
                    material[1].owned += 1
                    material[2].owned += 1
                    
                    print("You have obtained the following items:")
                    print("\(material[0].name) x\(material[0].owned)")
                    print("\(material[1].name) x\(material[1].owned)")
                    print("\(material[2].name) x\(material[2].owned)")
                } else if enemy == "Golem" {
                    material[3].owned += 1
                    material[4].owned += 1
                    material[5].owned += 10
                    
                    print("You have obtained the following items:")
                    print("\(material[3].name) x\(material[3].owned)")
                    print("\(material[4].name) x\(material[4].owned)")
                    print("\(material[5].name) x\(material[5].owned)")
                }

                

                
                return
            }
            
            turn = "enemy"
        }else {
            //Enemy turn
            if(block==true){
                print("You blocked your enemy attack")
                block=false
            }else{
                print("""
                    The \(enemy) attacks you!
                    """)
                
                if Int.random(in: 0...1) == 0 {
                    print("You dodge the attack!")
                    
                } else {
                    // Enemy deals damage to player
                    let damage = Int.random(in: 10...20)
                    health -= damage
                    print("""
                      The \(enemy) deals \(damage)pt of damage to you!
                      Your HP = \(health)/\(maxhealth)
                      """)
                    
                }}
            
            turn = "player"
        }
        
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
        }
    }
}



//ui
while(relife == true){
    relife=false
    username = ""
    
    //Array consumable
    var consumable: [ConsumableItem] = [
        ConsumableItem(name: "Low Grade Potion", type: "Potion", effect: "Heal", value: 10, owned: 0, price: 0),
        ConsumableItem(name: "Mid Grade Potion", type: "Potion", effect: "Heal", value: 20, owned: 20, price: 0),
        ConsumableItem(name: "High Grade Potion", type: "Potion", effect: "Heal", value: 40, owned: 0, price: 0),
        ConsumableItem(name: "Low Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 5, owned: 20, price: 20),
        ConsumableItem(name: "Mid Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 10, owned: 0, price: 20),
        ConsumableItem(name: "High Grade Elixir", type: "Elixir", effect: "Mana Restore", value: 20, owned: 0, price: 0)
    ]

    
    //Array material
    var material: [MaterialItem] = [
        MaterialItem(name: "Troll Claw", owned: 1, price: 2),
        MaterialItem(name: "Troll Rusty Dagger", owned: 0, price: 5),
        MaterialItem(name: "Troll Staff", owned: 0, price: 10),
        MaterialItem(name: "Golem Core", owned: 0, price: 20),
        MaterialItem(name: "Adamontium Stone", owned: 0, price: 50),
        MaterialItem(name: "Ordinary Rock", owned: 0, price: 1)
    ]
    
    //Array equipment
    var equipment: [EquipmentItem] = [
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
    var health=50
    var mana=50
    var maxhealth=100
    var maxmana=50
    var coin=100
    //Calling the startGame Function
    startGame(start: &start, username: &username, predicate: predicate)
    
    while(end==false){
        //Main Menu Or User Option For Action
        print("""
        From here, you can...
        [C]heck your health and stats
        [H]eal yourself with potion
        [D]rink elixir to recover mana
        [G]o to town (To be Updated)
        [I]nventory (Check your inventory)
        
        ...or choose where you want to go
        
        [F]orest of Troll
        [M]ountain of Golem
        [Q]uit Adventure
        
        Your choice?
        """)
        choice = readLine()!.lowercased()
        switch choice{
        case "c":
            while(choice=="c"){
                choice = checkStats(username: username, health: health, maxhealth: maxhealth, mana: mana, maxmana: maxmana, choice: choice)
                
            }
        case "h":
            //Heal
            while choice == "h" {
                let availablePotions = consumable.filter { $0.type == "Heal" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
                
                print("Available Potions:")
                for (index, potion) in availablePotions.enumerated() {
                    print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
                }
                
                print("Choose a potion to use (or [return] to exit):", terminator: "")
                choice = readLine()!.lowercased()
                
                if let potionIndex = Int(choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                    let potion = availablePotions[potionIndex - 1]
                    health = usePotion(potion: potion, health: health, maxHealth: maxhealth, consumable: &consumable)
                }
                
                if choice == "" {
                    choice = "out"
                } else {
                    choice = "h"
                }
            }
            
        case "d":
            while choice == "d" {
                            
                let availableElixirs = consumable.filter { $0.type == "Mana Restore" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }

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
                    mana = useElixir(elixir: elixir, mana: mana, maxMana: maxmana, consumable: &consumable)
                }
                if choice == "" {
                    choice = "out"
                } else {
                    choice = "h"
                }
            }
            
            
            
        case "g":
            //Town Feature To Buy And Sell Things In The Inventory
            while(choice=="g"){
                print("This feature is on progress. Press [return] to go back!")
                choice = readLine()!.lowercased()
                if(choice==""){
                    choice="out"
                }else{
                    choice="g"
                    print("Please input [return] if you want to go back!")
                    print("")
                }
            }
        case "i":
            //Open Inventory
            while (choice=="i"){
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
                if(choice=="e"){
                    while choice=="e"{
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
                        if(choice==""){
                            choice="i"
                        }else if var ind = Int(choice) {
                            if ind >= 1 && ind <= equipment.count {
                                ind -= 1
                                toggleEquip(index: ind, equipment: &equipment)
                            } else {
                                
                                print("Invalid index")
                                
                            }
                            choice="e"
                        }
                        else{
                            print("Please choose the right number option!")
                            print("")
                            choice="e"
                        }
                        
                        
                    }
                }else if(choice=="m"){
                    print("Your Material List:")
                    for item in material {
                        print("\(item.name):")
                        print("\tQuantity: \(item.owned)")
                        print("\tPrice: \(item.price)")
                        print("")
                    }
                    choice="i"
                } else if (choice == "c") {
                    let availablePotions = consumable.filter { $0.type == "Heal" && ["Low Grade Potion", "Mid Grade Potion", "High Grade Potion"].contains($0.name) }
                    let availableElixirs = consumable.filter { $0.type == "Elixir" && ["Low Grade Elixir", "Mid Grade Elixir", "High Grade Elixir"].contains($0.name) }
                                
                    print("Available Potions:")
                    for (index, potion) in availablePotions.enumerated() {
                        print("[\(index + 1)] \(potion.name) (\(potion.value) HP) (x\(potion.owned))")
                    }
                                
                    print("Available Elixirs:")
                    for (index, elixir) in availableElixirs.enumerated() {
                        print("[\(index + 1)] \(elixir.name) (\(elixir.value) MP) (x\(elixir.owned))")
                    }
                                
                    print("Press [return] to go back")
                    choice = readLine()!.lowercased()
                    choice = "i"
                }else if(choice=="b"){
                    choice="out"
                }else{
                    choice="i"
                    print("Please choose the right input from the option!")
                    print("")
                }
                
            }
        case "f":
            //Battle with a troll
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana, maxmana: &maxmana, consumable: &consumable, coin: &coin, equipment: equipment, material: &material)

            
            if health <= 0 {
                print("Oh dear, you are dead.")
                end = true
            }

        case "m":
            //Battle with a golem
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana, maxmana: &maxmana, consumable: &consumable, coin: &coin, equipment: equipment, material: &material)

            if(health<=0){
                print("Oh dear you are dead")
                end=true
            }
            
        case "q":
            //Quit adventure
            while(choice == "q"){
                print("Are you sure you want to quit, adventurer \(username)?(Y/N)(You will quit this adventure and can restart again.)")
                choice = readLine()!.lowercased()
                if(choice == "yes"  || choice == "ye" || choice == "y" || choice == "ya" || choice == "iya"){
                    print("Thank you for your adventure, adventurer \(username)!")
                    end=true
                    choice = "out"
                    
                }
                else if(choice == "n" || choice == "no" || choice=="tidak" || choice == "tak" || choice == "g" || choice == "ga" || choice == "gk" || choice == "gak"){
                    choice="out"
                }else{
                    print("Please input Y for yes or N for no!")
                    print("Invalid Answer")
                    choice = "q"
                }
            }
        default:
            print("Input Invalid")
            print("Please input the valid answer that is in the option list!")
            print("")
        }
    }
    while(end==true){
        print("Do you want to reincarnate and fix your path ?(Y/N)(You will quit this game if you say no)")
        choice = readLine()!
        
        if(choice == "yes"  || choice == "ye" || choice == "y" || choice == "ya" || choice == "iya"){
            print("Nice Choice!")
            end=false
            relife=true
            start=false
            choice = "out"
            
        }
        else if(choice == "n" || choice == "no" || choice=="tidak" || choice == "tak" || choice == "g" || choice == "ga" || choice == "gk" || choice == "gak"){
            end = false
            choice="out"
            print("May your soul rest in peace")
        }else{
            print("Invalid Answer")
            print("Please input Y for yes or N for no!")
            choice = "q"
        }
    }
    
    
    
    
    
}



