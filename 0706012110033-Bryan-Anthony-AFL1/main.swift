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



//func


//ui

while(relife == true){
  relife=false
    //default var
    username = ""
    
    var consumable: [[Any]] = [["Low Grade Potion", 10, 0, "Heal"],["Mid Grade Potion", 20, 20, "Heal"], ["High Grade Potion", 40,0,"Heal"], ["Low Grade Elixir", 5, 20, "Add Max HP"],["Mid Grade Elixir", 10, 0, "Add Max HP"], ["High Grade Elixir", 20, 0, "Add Max HP"]]
    var health=100
    var mana=50
    var maxhealth=100
    var maxmana=50
    var coin=100
    
    
    while(start == false){
      print("""
        ⛩️ Welcome to the New World ! ⛩️
        You have been chosen to embark on epic journey as a young adventurer on the path to become the greatest adventurer. Your adventures will take you through forests 🌲, mountains 🪨, and dungeons ⛓️, where you will face challenges, make allies, and fight enemies.
        Press [return] to continue:
        """,terminator: "")
        choice = readLine()!
        if choice == ""{
            start=true
        }
    }
    while(username == "" ){
        print("May I know your name young adventurer ?")
        username = readLine()!
        if predicate.evaluate(with: username){
            print("Nice name you have there, adventurer \(username)")
        }else{
            print("I didn't catch that!")
            username=""
        }
        
    }
    while(end==false){
        print("""
        From here, you can...
        [C]heck your health and stats
        [H]eal your wounds with potion (Mid Grade Potion)
        
        ...or choose where you want to go
        
        [F]orest of Troll
        [M]ountain of Golem
        [Q]uit Game
        
        Your choice?
        """,terminator:"")
        choice = readLine()!.lowercased()
        switch choice{
            case "c":
            while(choice=="c"){
                print("""
                Player name: \(username)
                
                HP: \(health)/\(maxhealth)
                MP: \(mana)/\(maxmana)
                
                Action:
                -Physical Attack. No mana required. Deal 5pt damage.
                -Meteor. Use 15pt of MP. Deal 50pt damage.
                -Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                
                Items:
                """);
                
                for item in consumable {
                    print("\(item[0]):")
                    print("\tQuantity: \(item[2])")
                    print("\tEffect: \(item[3])")
                    print("\tEffect Value: \(item[1])")
                }
                print("""
                Press [return] to go back:
            """,terminator: "")
                choice = readLine()!
                if(choice == ""){
                    choice="out"
                }else{
                    choice="c"
                }
            }
            case "h":
            var value = consumable[1][2] as? Int
            if ( value! >= 1) {
                while(choice=="h"){
                    print("""
                Your HP is \(health)
                You have \(consumable[1][2]) Potions (Mid Grade Potion)
                
                Are you sure want to use 1 potion to heal wound? [Y/N]
                """,terminator: "")
                    choice = readLine()!.lowercased()
                    
                    if choice == "y"{
                        choice = "out"
                        var heal = consumable[1][1] as? Int
                        health = health + heal!
                        if(health>maxhealth){
                            health=maxhealth
                        }
                        value = value! - 1
                        consumable[1][2] = value as Any
                    }else if choice == "n"{
                        choice = "out"
                    }else{
                        choice = "h"
                    }
                    
                }}
            else{
                while(choice != ""){
                    print("""
                          You don't have any potion left. Be careful of your next journey!
                          Press [return] to go back:
                          """,terminator: "")
                    choice = readLine()!
                }
            }
            case "f":
                print("""
                As you enter the forst, you geel a sense of unease wash over you.
                Suddenly, you hear the sound of twigs snapping behind you. You quickly spin around, and find a Troll emerging from the shadows.
                
""")
                var enhealth = 1000
                var enname = "Troll x1"
            while(choice == "f"){
                print("""
                😈 Name : \(enname)
                😈 Health: \(enhealth)
                
                Choose your action:
                [1] Physical Attack. No mana required.Deal 5pt of damage.
                [2] Meteor. Use 15pt of MP. Deal 50pt of damage.
                [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
                
                [4] Use potion to heal wound.
                [5] Scan enemy's vital.
                [6] Flee from battle.
                
                Your Choice?
                """)
                choice = readLine()!

                switch choice {
                case "1":
                    enhealth = enhealth-5
                    if (enhealth <= 0 ){
                        print("The beast has been fallen")
                        choice = "out"
                    }
                    else{
                        choice = "f"
                    }
                case "2":
                    if (mana >= 15) {
                        enhealth = enhealth - 50
                        mana = mana - 15
                    }else{
                        print("Not enough mana!")
                    }
                    if (enhealth <= 0 ){
                        print("The beast has been fallen")
                        choice = "out"
                    }
                    else{
                        choice = "f"
                    }
                case "3":
                    if (mana >= 10) {
                        mana = mana - 10
                    }else{
                        print("Not enough mana!")
                    }
                    if (enhealth <= 0 ){
                        print("The beast has been fallen")
                        choice = "out"
                    }
                    else{
                        choice = "f"
                    }
                case "4":
                    var value = consumable[1][2] as? Int
                    if ( value! >= 1) {
                        while(choice=="4"){
                            print("""
                        Your HP is \(health)
                        You have \(consumable[1][2]) Potions (Mid Grade Potion)
                        
                        Are you sure want to use 1 potion to heal wound? [Y/N]
                        """,terminator: "")
                            choice = readLine()!.lowercased()
                            
                            if choice == "y"{
                                choice = "f"
                                var heal = consumable[1][1] as? Int
                                health = health + heal!
                                if(health>maxhealth){
                                    health=maxhealth
                                }
                                value = value! - 1
                                consumable[1][2] = value as Any
                            }else if choice == "n"{
                                choice = "f"
                            }else{
                                choice = "4"
                            }
                            
                        }}
                    else{
                        while(choice != ""){
                            print("""
                                  You don't have any potion left. Be careful on your battle!
                                  Press [return] to go back:
                                  """,terminator: "")
                            choice = readLine()!
                        }
                        choice = "f"
                    }
                case "5":
                    print("Error, you don't have the equipment!")
                    choice = "f"
                case "6":
                    while(choice == "6"){
                        print("""
                        You feel that if you don't escape soon, you won't be able to continue the fight.
                        You look around frantically, searching for a way out. You sprint towards the exit, your heart pounding in your chest.
                        
                        You're safe, for now.
                        Press [return] to continue:
                        """,terminator: "")
                        choice = readLine()!
                        if choice != ""{
                            choice = "6"
                        }else{
                            choice = "out"
                        }
                    }
                default:
                    choice="f"
                }}
            case "m":
            print("""
            As you make you way through the rugged mountain terrain, you can feel the chill of the wind biting at your skin.
            Suddenly, you hear a sound that makes you freeze in your tracks. That's when you see it - a massie, snarling Golem emrging from the shadows
            
""")
            var enhealth = 1000
            var enname = "golem x1"
        while(choice == "m"){
            print("""
            😈 Name : \(enname)
            😈 Health: \(enhealth)
            
            Choose your action:
            [1] Physical Attack. No mana required.Deal 5pt of damage.
            [2] Meteor. Use 15pt of MP. Deal 50pt of damage.
            [3] Shield. Use 10pt of MP. Block enemy's attack in 1 turn.
            
            [4] Use potion to heal wound.
            [5] Scan enemy's vital.
            [6] Flee from battle.
            
            Your Choice?
            """)
            choice = readLine()!

            switch choice {
            case "1":
                enhealth = enhealth-5
                if (enhealth <= 0 ){
                    print("The beast has been fallen")
                    choice = "out"
                }
                else{
                    choice = "m"
                }
            case "2":
                if (mana >= 15) {
                    enhealth = enhealth - 50
                    mana = mana - 15
                }else{
                    print("Not enough mana!")
                }
                if (enhealth <= 0 ){
                    print("The beast has been fallen")
                    choice = "out"
                }
                else{
                    choice = "m"
                }
            case "3":
                if (mana >= 10) {
                    mana = mana - 10
                }else{
                    print("Not enough mana!")
                }
                if (enhealth <= 0 ){
                    print("The beast has been fallen")
                    choice = "out"
                }
                else{
                    choice = "m"
                }
            case "4":
                var value = consumable[1][2] as? Int
                if ( value! >= 1) {
                    while(choice=="4"){
                        print("""
                    Your HP is \(health)
                    You have \(consumable[1][2]) Potions (Mid Grade Potion)
                    
                    Are you sure want to use 1 potion to heal wound? [Y/N]
                    """,terminator: "")
                        choice = readLine()!.lowercased()
                        
                        if choice == "y"{
                            choice = "m"
                            var heal = consumable[1][1] as? Int
                            health = health + heal!
                            if(health>maxhealth){
                                health=maxhealth
                            }
                            value = value! - 1
                            consumable[1][2] = value as Any
                        }else if choice == "n"{
                            choice = "m"
                        }else{
                            choice = "4"
                        }
                        
                    }}
                else{
                    while(choice != ""){
                        print("""
                              You don't have any potion left. Be careful on your battle!
                              Press [return] to go back:
                              """,terminator: "")
                        choice = readLine()!
                    }
                    choice = "m"
                }
            case "5":
                print("Error, you don't have the equipment!")
                choice = "m"
            case "6":
                while(choice == "6"){
                    print("""
                    You feel that if you don't escape soon, you won't be able to continue the fight.
                    You look around frantically, searching for a way out. You sprint towards the exit, your heart pounding in your chest.
                    
                    You're safe, for now.
                    Press [return] to continue:
                    """,terminator: "")
                    choice = readLine()!
                    if choice != ""{
                        choice = "6"
                    }else{
                        choice = "out"
                    }
                }
            default:
                choice="m"
            }}

            case "q":
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

