//
//  main.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 03/03/23.
//

import Foundation

//let
let alphaOnlyRegex = "^[a-zA-Z]+$"
let predicate = NSPredicate(format:"SELF MATCHES %@",alphaOnlyRegex)

//global var
var relife=true
var end=false
var start=false
var username = ""
var choice:String
//function main
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
//ui
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
                choice = player.checkStats()
                
            }
            
        case "h":
            //Heal
            player.heal(menuOption: "h")
            
        case "d":
            player.manaRecovery(menuOption: "d")
            
        case "g":
            //Town Feature To Buy And Sell Things In The Inventory
            townFeature(player: &player)
            
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



