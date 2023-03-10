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
//startGame
func startGame(start: inout Bool, username: inout String, predicate: NSPredicate) {
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
    
    for item in consumable {
        print("\(item[0]):")
        print("\tQuantity: \(item[2])")
        print("\tEffect: \(item[3])")
        print("\tEffect Value: \(item[1])")
    }
    
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
func useMidGradePotion(health: Int, maxHealth: Int, consumable: inout [[Any]]) -> Int {
    var newHealth = health
    
    
    guard let midGradePotionIndex = consumable.firstIndex(where: { ($0[0] as? String) == "Mid Grade Potion" }) else {
        print("You don't have any mid-grade potion left. Goodluck and be careful in your journey!")
        return newHealth
    }
    
    guard var quantity = consumable[midGradePotionIndex][2] as? Int, quantity > 0 else {
        print("You don't have any mid-grade potion left. Goodluck and be careful in your journey!")
        return newHealth
    }
    
    repeat {
        print("""
            Your HP is \(health)
            You have \(quantity) Potions (Mid Grade Potion)
            
            Are you sure you want to use 1 potion to heal your wounds? [Y/N]
            """)
        guard let choice = readLine()?.lowercased() else { continue }
        
        if choice == "y" {
            let heal = consumable[midGradePotionIndex][1] as? Int ?? 0
            newHealth = min(newHealth + heal, maxHealth)
            print("You have been healed. Your new HP is \(newHealth).")
            quantity -= 1
            consumable[midGradePotionIndex][2] = quantity as Any
            if quantity == 0 {
                print("You have used up all your mid-grade potions.")
                break
            }
        } else if choice == "n" {
            break
        }
    } while true
    
    return newHealth
}

//battle
func battleSequence(choice: String, maxhealth: inout Int, health: inout Int, mana: inout Int, maxmana: inout Int, consumable: inout [[Any]]) {
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
    while enemyHealth > 0 && health > 0 && choice != "6"{
        if turn == "player" {
            print("""
                    😈 Name : \(enemy)
                    😈 Health: \(enemyHealth)
                    
                    Choose your action:
                    [1] Physical Attack. No mana required. Deal 5pt of damage.
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
                enemyHealth -= 5
                print("You dealt 5pt of damage to \(enemy)!")
            case "2":
                if mana >= 15 {
                    enemyHealth -= 50
                    mana -= 15
                    print("You used Meteor and dealt 50pt of damage to \(enemy)!")
                } else {
                    print("Not enough mana!")
                }
            case "3":
                if mana >= 10 {
                    mana -= 10
                    print("You used Shield and blocked the enemy's attack for one turn!")
                } else {
                    print("Not enough mana!")
                }
            case "4":
                while(choice=="4"){
                    
                        health = useMidGradePotion(health: health, maxHealth: maxhealth, consumable: &consumable)
                    
                    print("Press [return] to go back:",terminator: "")
                    choice=readLine()!.lowercased()
                    if(choice==""){
                        choice="out"
                    }else{
                        choice="4"
                    }
                    
                }
            case "5":
                print("Error, you don't have the equipment!")
            case "6":
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
                print("The beast has been defeated!")
                return
            }
            
            turn = "enemy"
        }else {
            print("""
                    The \(enemy) attacks you!
                    """)
            
            if Int.random(in: 0...1) == 0 {
                print("You dodge the attack!")
                
            } else {
                // Enemy deals damage to player
                let damage = Int.random(in: 10...20)
                health -= damage
                print("The \(enemy) deals \(damage)pt of damage to you!")
            }
            
            turn = "player"
        }

    }
    
}
//ui

while(relife == true){
  relife=false
    //default var
    username = ""
    
    var consumable: [[Any]] = [["Low Grade Potion", 10, 0, "Heal"],["Mid Grade Potion", 20, 20, "Heal"], ["High Grade Potion", 40,0,"Heal"], ["Low Grade Elixir", 5, 20, "Add Max HP"],["Mid Grade Elixir", 10, 0, "Add Max HP"], ["High Grade Elixir", 20, 0, "Add Max HP"]]
    var health=50
    var mana=50
    var maxhealth=100
    var maxmana=50
    var coin=100
    //Calling the startGame Function
    startGame(start: &start, username: &username, predicate: predicate)

    while(end==false){
        print("""
        From here, you can...
        [C]heck your health and stats
        [H]eal your wounds with potion (Mid Grade Potion)
        [G]o to town (Buy something)
        [I]nventory (Check your inventory)
        
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
                choice = checkStats(username: username, health: health, maxhealth: maxhealth, mana: mana, maxmana: maxmana, consumable: consumable, choice: choice)

            }
            case "h":
            while(choice=="h"){
                
                    health = useMidGradePotion(health: health, maxHealth: maxhealth, consumable: &consumable)
                
                print("Press [return] to go back:",terminator: "")
                choice=readLine()!.lowercased()
                if(choice==""){
                    choice="out"
                }else{
                    choice="h"
                }
                
            }
                    
            case "f":
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana,maxmana:&maxmana,consumable: &consumable)
            
            if(health<=0){
                print("Oh dear you are dead")
                end=true
            }

            case "m":
            
            battleSequence(choice: choice, maxhealth: &maxhealth, health: &health, mana: &mana,maxmana:&maxmana,consumable: &consumable)
            if(health<=0){
                print("Oh dear you are dead")
                end=true
            }
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



