//
//  main.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 03/03/23.
//

import Foundation


let alphaOnlyRegex = "^[a-zA-Z]+$"
let predicate = NSPredicate(format:"SELF MATCHES %@",alphaOnlyRegex)
var game = RPGAdventure()
game.startGame()

class RPGAdventure {
    var relife=true
    var end=false
    var start=false
    var username = ""
    var choice:String = ""
    
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
    func startGame(){
        while(relife == true){
            relife=false
            username = ""
            
            
            //Calling the startGame Function
            startGame(start: &start, username: &username, predicate: predicate)
            var player = Player(name: username, health: 50,maxHealth:100, mana: 50 , maxMana: 100, coin: 100, equipment: equipments, consumable: consumables, material: materials)
            while(end==false){
                //Main Menu Or User Option For Action
                print("""
        From here, you can...
        [C]heck your health and stats
        [H]eal yourself with potion
        [D]rink elixir to recover mana
        [G]o to town 
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
                        choice = player.checkStats()
                        
                    }
                    
                case "h":
                    //Heal
                    player.heal(menuOption: "h")
                    
                case "d":
                    player.manaRecovery(menuOption: "d")
                    
                case "g":
                    //Town Feature To Buy And Sell Things In The Inventory
                    player.townFeature()
                    
                case "i":
                    //Open Inventory
                    player.showInventory()
                    
                case "f":
                    //Battle with a troll
                    battleSequence(choice: choice, player: &player)
                    if player.health <= 0 {
                        print("Oh dear, you are dead.")
                        end = true
                    }
                    
                case "m":
                    //Battle with a golem
                    battleSequence(choice: choice, player: &player)
                    if(player.health<=0){
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
    }
    
    //function for user to battle with monster based on the ecosystem they choose
    func battleSequence(choice: String, player: inout Player) {
        var enemy: Enemy
        var doubledamage = false
        
        if choice == "f" {
            enemy = Enemy(name: "Troll", health: 1000)
            print("""
                As you enter the forest, you feel a sense of unease wash over you.
                Suddenly, you hear the sound of twigs snapping behind you. You quickly spin around, and find a \(enemy.name) emerging from the shadows.
                """)
        } else if choice == "m" {
            enemy = Enemy(name: "Golem", health: 1000)
            print("""
                As you make your way through the rugged mountain terrain, you can feel the chill of the wind biting at your skin.
                Suddenly, you hear a sound that makes you freeze in your tracks. That's when you see it - a massive, snarling \(enemy.name) emerging from the shadows.
                """)
        } else {
            return
        }
        
        var turn = "player"
        var block = false
        var totalEquipmentDamage = 0
        for item in player.equipment where item.equipped {
            totalEquipmentDamage += item.damage
        }
        let baseDamage = 5
        let totalDamage = baseDamage + totalEquipmentDamage
        
        while enemy.health > 0 && player.health > 0 {
            if turn == "player" {
                if doubledamage {
                    print("""
                        😈 Name : \(enemy.name)
                        😈 Health: \(enemy.health)
                        
                        Choose your action:
                        [1] Physical Attack. No mana required. Deal \(baseDamage * 2)pt of damage + \(totalEquipmentDamage * 2)pt from equipment you equip.
                        [2] Meteor. Use 15pt of MP. Deal 100pt of damage.
                        [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                        [4] Heal yourself with potion.
                        [5] Drink elixir to recover mana.
                        [6] Scan enemy's vital.
                        [7] Flee from battle.
                        
                        Your Choice?
                        """)
                } else {
                    print("""
                        😈 Name : \(enemy.name)
                        😈 Health: \(enemy.health)
                        
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
                
                game.choice = readLine()!
                
                
                switch game.choice {
                case "1":
                    //Use Physical Attack to damage enemy with addition of equipment
                    var totaldamage = totalDamage
                    if doubledamage==true{
                        totaldamage=totalDamage*2
                    }
                    
                    enemy.health -= totaldamage
                    print("You dealt \(totaldamage)pt of damage to \(enemy.name)!")
                case "2":
                    //Use Meteor Skill to damage enemy
                    if player.mana >= 15 {
                        if doubledamage==true{
                            enemy.health -= 100
                        }else{
                            enemy.health -= 50
                        }
                        
                        player.mana -= 15
                        print("You used Meteor and dealt 50pt of damage to \(enemy.name)!")
                    } else {
                        print("Not enough mana!")
                    }
                case "3":
                    //Use shield to block enemy
                    if player.mana >= 10 {
                        player.mana -= 10
                        print("You used Shield and blocked the enemy's attack for one turn!")
                        block=true
                    } else {
                        print("Not enough mana!")
                    }
                case "4":
                    //Heal
                    player.heal(menuOption: game.choice)
                    
                case "5":
                    //Mana Recovery
                    player.manaRecovery(menuOption: game.choice)
                    
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
                
                if enemy.health <= 0 {
                    //Enemy defeated
                    print("The beast has been defeated!")
                    let randomCoin = Int.random(in: 1...100)
                    player.coin+=randomCoin
                    if enemy.name == "Troll" {
                        player.material[0].owned += 1
                        player.material[1].owned += 1
                        player.material[2].owned += 1
                        
                        print("You have obtained the following items:")
                        print("\(player.material[0].name) x\(player.material[0].owned)")
                        print("\(player.material[1].name) x\(player.material[1].owned)")
                        print("\(player.material[2].name) x\(player.material[2].owned)")
                    } else if enemy.name == "Golem" {
                        player.material[3].owned += 1
                        player.material[4].owned += 1
                        player.material[5].owned += 10
                        
                        print("You have obtained the following items:")
                        print("\(player.material[3].name) x\(player.material[3].owned)")
                        print("\(player.material[4].name) x\(player.material[4].owned)")
                        print("\(player.material[5].name) x\(player.material[5].owned)")
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
                        The \(enemy.name) attacks you!
                        """)
                    
                    enemy.dealDamage(to: &player)
                    
                }
                
                turn = "player"
            }
            
        }
        
    }

}



