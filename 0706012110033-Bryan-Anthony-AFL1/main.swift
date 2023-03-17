//
//  main.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 03/03/23.
//

import Foundation

//struct
//Equipment Array Struct
struct EquipmentItem: Equatable {
    let name: String
    let type: String
    let damage: Int
    let price: Int
    var owned: Int
    var equipped: Bool
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
            username = ""
        }
    }
    
    print("Let the adventure begin, \(username)!")
}

//checkStats
func checkStats(username: String, health: Int, maxhealth: Int, mana: Int, maxmana: Int, consumable: [[Any]], choice: String) -> String {
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

//useMidGradePotion
func usePotion(potion: [Any], health: Int, maxHealth: Int, consumable: inout [[Any]]) -> Int {
    var newHealth = health
    
    guard let potionIndex = consumable.firstIndex(where: { ($0[0] as? String) == (potion[0] as? String) }) else {
        print("You don't have any \(potion[0]) left. Goodluck and be careful in your journey!")
        return newHealth
    }
    
    guard var quantity = potion[2] as? Int, quantity > 0 else {
        print("You don't have any \(potion[0]) left. Goodluck and be careful in your journey!")
        return newHealth
    }
    
    repeat {
        print("""
            Your HP is \(newHealth)
            You have \(quantity) Potions (\(potion[0]))
            
            Are you sure you want to use 1 potion to heal your wounds? [Y/N]
            """)
        guard let choice = readLine()?.lowercased() else { continue }
        
        if choice == "y" {
            let heal = potion[1] as? Int ?? 0
            newHealth = min(newHealth + heal, maxHealth)
            print("You have been healed. Your new HP is \(newHealth).")
            quantity -= 1
            consumable[potionIndex][2] = quantity as Any
            if quantity == 0 {
                print("You have used up all your \(potion[0]) potions.")
                break
            }
        } else if choice == "n" {
            break
        }
    } while true
    
    return newHealth
}

//Use Elixir
func useElixir(elixir: [Any], mana: Int, maxMana: Int, consumable: inout [[Any]]) -> Int {
    var newMana = mana
    
    guard let elixirIndex = consumable.firstIndex(where: { ($0[0] as? String) == (elixir[0] as? String) }) else {
        print("You don't have any \(elixir[0]) left. Goodluck and be careful in your journey!")
        return newMana
    }
    
    guard var quantity = elixir[2] as? Int, quantity > 0 else {
        print("You don't have any \(elixir[0]) left. Goodluck and be careful in your journey!")
        return newMana
    }
    
    repeat {
        print("""
            Your MP is \(newMana)
            You have \(quantity) Elixirs (\(elixir[0]))
            
            Are you sure you want to use 1 elixir to restore your mana? [Y/N]
            """)
        guard let choice = readLine()?.lowercased() else { continue }
        
        if choice == "y" {
            let manaRestore = elixir[1] as? Int ?? 0
            newMana = min(newMana + manaRestore, maxMana)
            print("Your mana has been restored. Your new MP is \(newMana).")
            quantity -= 1
            consumable[elixirIndex][2] = quantity as Any
            if quantity == 0 {
                print("You have used up all your \(elixir[0]) elixirs.")
                break
            }
        } else if choice == "n" {
            break
        }
    } while true
    
    return newMana
}



//battle
func battleSequence(choice: String, maxhealth: inout Int, health: inout Int, mana: inout Int, maxmana: inout Int, consumable: inout [[Any]], coin: inout Int, equipment: [EquipmentItem], material: inout[[Any]]) {
    let equippedWeapon = equipment.first(where: { $0.type == "Hand" && $0.equipped })?.damage ?? 0
    
    var choice=choice
    var enemy = ""
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
    while enemyHealth > 0 && health > 0 && choice != "6"{
        if turn == "player" {
            print("""
                    😈 Name : \(enemy)
                    😈 Health: \(enemyHealth)
                    
                    Choose your action:
                    [1] Physical Attack. No mana required. Deal \(baseDamage)pt of damage + \(totalEquipmentDamage)pt from equipment you equip.
                    [2] Meteor. Use 15pt of MP. Deal 50pt of damage.
                    [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                    
                    [4] Use consumable to heal or mana recovery.
                    [5] Scan enemy's vital.
                    [6] Flee from battle.
                    
                    Your Choice?
                    """)
            
            choice = readLine()!
            
            switch choice {
            case "1":
                //Use Physical Attack to damage enemy with addition of equipment
                enemyHealth -= totalDamage
                print("You dealt \(totalDamage)pt of damage to \(enemy)!")
            case "2":
                //Use Meteor Skill to damage enemy
                if mana >= 15 {
                    enemyHealth -= 50
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
                while(choice == "4"){
                    //Heal Or Mana Recovery Option
                    print("""
                    Choose consumable you want to consume:
                    [H]eal your wounds with potion
                    [D]rink elixir to recover your mana
                    Or press [return] to go back
                    """)
                    choice = readLine()!.lowercased()
                    if( choice == ""){
                        choice="out"
                    }else if(choice == "h"){
                        //Heal
                        while choice == "h" {
                            
                            let availablePotions = consumable.filter { $0[3] as? String == "Heal" && ($0[0] as? String == "Low Grade Potion" || $0[0] as? String == "Mid Grade Potion" || $0[0] as? String == "High Grade Potion") }
                            print("Available Potions:")
                            for i in 0..<availablePotions.count {
                                print("\(i+1). \(availablePotions[i][0]) (\(availablePotions[i][1]) HP) (x\(availablePotions[i][2])")
                            }
                            
                            print("Choose a potion to use (or [return] to exit):", terminator: "")
                            choice = readLine()!.lowercased()
                            
                            if let potionIndex = Int(choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                                let potion = availablePotions[potionIndex - 1]
                                health = usePotion(potion: potion, health: health, maxHealth: maxhealth, consumable: &consumable)
                            }
                            if choice == "" {
                                choice = "4"
                            }
                            else{
                                choice="h"
                            }
                        }
                    }else if(choice == "d"){
                        //Mana Recovery
                        while choice == "d" {
                            
                            let availableElixirs = consumable.filter { $0[3] as? String == "Mana Restore" && ($0[0] as? String == "Low Grade Elixir" || $0[0] as? String == "Mid Grade Elixir" || $0[0] as? String == "High Grade Elixir") }
                            print("Available Elixirs:")
                            for i in 0..<availableElixirs.count {
                                print("\(i+1). \(availableElixirs[i][0]) (\(availableElixirs[i][1]) MP) (x\(availableElixirs[i][2]))")
                            }
                            
                            
                            print("Choose an elixir to use (or [return] to exit):", terminator: "")
                            choice = readLine()!.lowercased()
                            if let elixirIndex = Int(choice), elixirIndex > 0 && elixirIndex <= availableElixirs.count {
                                let elixir = availableElixirs[elixirIndex - 1]
                                mana = useElixir(elixir: elixir, mana: mana, maxMana: maxmana, consumable: &consumable)
                            }
                            if choice == "" {
                                choice = "4"
                            }
                            else{
                                choice = "d"
                            }
                            
                        }
                        
                    }else{
                        choice="4"
                    }
                    
                }
                
                
            case "5":
                //Vital Scan Feature (On Progress)
                print("Error, you don't have the equipment!")
            case "6":
                //Flee From The Battle
                print("""
                        You feel that if you don't escape soon, you won't be able to continue the fight.
                        You look around frantically, searching for a way out. You sprint towards the exit, your heart pounding in your chest.
                        
                        You're safe, for now.
                        """)
                return
            default:
                continue
            }
            
            if enemyHealth <= 0 {
                //Enemy defeated
                print("The beast has been defeated!")
                let randomCoin = Int.random(in: 1...100)
                coin+=randomCoin
                if enemy == "Troll" {
                    var material1 = material[0][1] as? Int ?? 0
                    material1 = material1 + 1
                    material[0][1] = material1 as Any
                    var material2 = material[1][1] as? Int ?? 0
                    material2 = material2 + 1
                    material[1][1] = material2 as Any
                    var material3 = material[2][1] as? Int ?? 0
                    material3 = material3 + 1
                    material[2][1] = material3 as Any
                    
                    print("You have obtained the following items:")
                    print("\(material[0][0]) x\(material1)")
                    print("\(material[1][0]) x\(material2)")
                    print("\(material[2][0]) x\(material3)")
                    
                    
                } else if enemy == "Golem" {
                    var material1 = material[3][1] as? Int ?? 0
                    material1 = material1 + 1
                    material[3][1] = material1 as Any
                    var material2 = material[4][1] as? Int ?? 0
                    material2 = material2 + 1
                    material[4][1] = material2 as Any
                    var material3 = material[5][1] as? Int ?? 0
                    material3 = material3 + 10
                    material[5][1] = material3 as Any
                    print("You have obtained the following items:")
                    print("\(material[3][0]) x\(material1)")
                    print("\(material[4][0]) x\(material2)")
                    print("\(material[5][0]) x\(material3)")
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
//equiping Equipment
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
    var consumable: [[Any]] = [["Low Grade Potion", 10, 0, "Heal"],["Mid Grade Potion", 20, 20, "Heal"], ["High Grade Potion", 40,0,"Heal"], ["Low Grade Elixir", 5, 20, "Mana Restore"],["Mid Grade Elixir", 10, 0, "Mana Restore"], ["High Grade Elixir", 20, 0, "Mana Restore"]]
    
    //Array material
    var material: [[Any]] = [["Troll Claw",1,2],["Troll Rusty Dagger",0,5],["Troll Staff",0,10],["Golem Core",0,20],["Adamontium Stone",0,50],["Ordinary Rock",0,1]]
    
    //Array equipment
    var equipment: [EquipmentItem] = [
        EquipmentItem(name: "Old Rusty Sword", type: "Hand", damage: 15, price: 10, owned: 1, equipped: true),
        EquipmentItem(name: "Newbie Luck", type: "Accessory", damage: 500, price: 0, owned: 1, equipped: true),
        EquipmentItem(name: "Mask of Madness", type: "Head", damage: 100, price: 50, owned: 1, equipped: true),
        EquipmentItem(name: "Zeus Lightning", type: "Hand", damage: 300, price: 500, owned: 0, equipped: false),
        EquipmentItem(name: "Hades Armor", type: "Armor", damage: 200, price: 400, owned: 1, equipped: false),
        EquipmentItem(name: "King's Sword Legacy", type: "Hand", damage: 100, price: 150, owned: 1, equipped: false),
        EquipmentItem(name: "Zephyr Boots", type: "Boots", damage: 250, price: 500, owned: 1, equipped: false),
        EquipmentItem(name: "Peasant Armor", type: "Armor", damage: 50, price: 20, owned: 1, equipped: false),
        EquipmentItem(name: "Knight Boots", type: "Boots", damage: 100, price: 40, owned: 1, equipped: false),
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
        [U]se consumable
        [G]o to town (To be Updated)
        [I]nventory (Check your inventory)
        
        ...or choose where you want to go
        
        [F]orest of Troll
        [M]ountain of Golem
        [Q]uit Game
        
        Your choice?
        """)
        choice = readLine()!.lowercased()
        switch choice{
        case "c":
            while(choice=="c"){
                choice = checkStats(username: username, health: health, maxhealth: maxhealth, mana: mana, maxmana: maxmana, consumable: consumable, choice: choice)
                
            }
        case "u":
            //Option to heal or mana recovery
            while(choice == "u"){
                print("""
                Choose consumable you want to consume:
                [H]eal your wounds with potion
                [D]rink elixir to recover your mana
                Or press [return] to go back
                """)
                choice = readLine()!.lowercased()
                if( choice == ""){
                    choice="out"
                }else if(choice == "h"){
                    //Heal
                    while choice == "h" {
                        
                        let availablePotions = consumable.filter { $0[3] as? String == "Heal" && ($0[0] as? String == "Low Grade Potion" || $0[0] as? String == "Mid Grade Potion" || $0[0] as? String == "High Grade Potion") }
                        print("Available Potions:")
                        for i in 0..<availablePotions.count {
                            print("\(i+1). \(availablePotions[i][0]) (\(availablePotions[i][1]) HP) (x\(availablePotions[i][2])")
                        }
                        
                        print("Choose a potion to use (or [return] to exit):", terminator: "")
                        choice = readLine()!.lowercased()
                        
                        
                        if let potionIndex = Int(choice), potionIndex > 0 && potionIndex <= availablePotions.count {
                            let potion = availablePotions[potionIndex - 1]
                            health = usePotion(potion: potion, health: health, maxHealth: maxhealth, consumable: &consumable)
                        }
                        if choice == "" {
                            choice = "u"
                        }else{
                            choice = "h"
                        }
                    }
                }else if(choice == "d"){
                    //Mana Recovery
                    while choice == "d" {
                        
                        let availableElixirs = consumable.filter { $0[3] as? String == "Mana Restore" && ($0[0] as? String == "Low Grade Elixir" || $0[0] as? String == "Mid Grade Elixir" || $0[0] as? String == "High Grade Elixir") }
                        print("Available Elixirs:")
                        for i in 0..<availableElixirs.count {
                            print("\(i+1). \(availableElixirs[i][0]) (\(availableElixirs[i][1]) MP) (x\(availableElixirs[i][2]))")
                        }
                        
                        
                        print("Choose an elixir to use (or [return] to exit):", terminator: "")
                        choice = readLine()!.lowercased()
                        if let elixirIndex = Int(choice), elixirIndex > 0 && elixirIndex <= availableElixirs.count {
                            let elixir = availableElixirs[elixirIndex - 1]
                            mana = useElixir(elixir: elixir, mana: mana, maxMana: maxmana, consumable: &consumable)
                        }
                        if choice == "" {
                            choice = "u"
                        }
                        else{
                            choice = "d"
                        }
                        
                    }
                    
                }else{
                    choice="u"
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
                            choice="e"
                        }
                        
                        
                    }
                }else if(choice=="m"){
                    for item in material {
                        print("""
                              \(item[0]):
                              Quantity:  \(item[1])
                              Value: \(item[2])
                              """)
                        print("")
                    }
                    choice="i"
                }else if(choice=="c"){
                    for item in consumable {
                        print("\(item[0]):")
                        print("\tQuantity: \(item[2])")
                        print("\tEffect: \(item[3])")
                        print("\tEffect Value: \(item[1])")
                        print("")
                    }
                    choice="i"
                }else if(choice=="b"){
                    choice="out"
                }else{
                    choice="i"
                }
                
            }
        case "f":
            //Battle with a troll
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana,maxmana:&maxmana,consumable: &consumable, coin: &coin, equipment: equipment, material: &material)
            
            if(health<=0){
                print("Oh dear you are dead")
                end=true
            }
            
        case "m":
            //Battle with a golem
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana,maxmana:&maxmana,consumable: &consumable, coin: &coin, equipment: equipment,material: &material)
            if(health<=0){
                print("Oh dear you are dead")
                end=true
            }
            
        case "q":
            //Quit game
            while(choice == "q"){
                print("Are you sure you want to quit, adventurer \(username)?")
                choice = readLine()!.lowercased()
                if(choice == "yes"  || choice == "ye" || choice == "y" || choice == "ya" || choice == "iya"){
                    print("Thank you for your adventure, adventurer \(username)!")
                    end=true
                    choice = "out"
                    
                }
                else if(choice == "n" || choice == "no" || choice=="tidak" || choice == "tak" || choice == "g" || choice == "ga" || choice == "gk" || choice == "gak"){
                    choice="out"
                }else{
                    print("Invalid Answer")
                    choice = "q"
                }
            }
        default:
            print("Input Invalid")
        }
    }
    while(end==true){
        print("Do you want to reincarnate and fix your path ?")
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
            choice = "q"
        }
    }
    
    
    
    
    
}



