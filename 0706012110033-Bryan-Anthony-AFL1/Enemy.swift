//
//  Enemy.swift
//  0706012110033-Bryan-Anthony-AFL1
//
//  Created by MacBook Pro on 04/04/23.
//

import Foundation



//class enemy inherit from character class
class Enemy: Character {
    override init(name: String, health: Int = 1000, maxHealth: Int = 1000) {
        super.init(name: name, health: health, maxHealth: maxHealth)
    }
    
    
}
