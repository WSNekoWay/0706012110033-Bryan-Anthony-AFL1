//
//  Battle.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation

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
            
            let choice = readLine()!
            
            
            switch choice {
            case "1":
                //Use Physical Attack to damage enemy with addition of equipment
                var totaldamage = totalDamage
                if doubledamage==true{
                    totaldamage=totalDamage*2
                }
                
                enemy.health -= totaldamage
                print("You dealt \(totaldamage)pt of damage to \(enemy)!")
            case "2":
                //Use Meteor Skill to damage enemy
                if player.mana >= 15 {
                    if doubledamage==true{
                        enemy.health -= 100
                    }else{
                        enemy.health -= 50
                    }
                    
                    player.mana -= 15
                    print("You used Meteor and dealt 50pt of damage to \(enemy)!")
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
                
                player.heal(menuOption: "4")
                
            case "5":
                //Mana Recovery
                player.manaRecovery(menuOption: "5")
                
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
                    The \(enemy) attacks you!
                    """)
                
                if Int.random(in: 0...1) == 0 {
                    print("You dodge the attack!")
                    
                } else {
                    // Enemy deals damage to player
                    let damage = Int.random(in: 10...20)
                    player.health -= damage
                    print("""
                      The \(enemy) deals \(damage)pt of damage to you!
                      Your HP = \(player.health)/\(player.maxHealth)
                      """)
                    
                }}
            
            turn = "player"
        }
        
    }
    
}
