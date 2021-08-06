//
//  Upgrade.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-07.
//

import Foundation

class Upgrade: Encodable, Decodable {
    var numberOwned: Int?
    var initialPrice: Int?
    var currentPrice: Int?
    var speed: Int?
    
    init(numberOwned: Int, speed: Int, initialPrice: Int) {
        self.numberOwned = numberOwned
        self.speed = speed
        self.initialPrice = initialPrice
        self.currentPrice = initialPrice
    }
    
    func buy() {
        numberOwned = numberOwned! + 1
        currentPrice = currentPrice! + initialPrice!/2
    }
}
