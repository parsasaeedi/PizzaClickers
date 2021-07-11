//
//  PizzaBrain.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-11.
//

import UIKit

struct PizzaBrain {
    var upgradesList = ["MammaMia": Upgrade(numberOwned: 0, speed: 1, initialPrice: 50),
                        "Cutter": Upgrade(numberOwned: 0, speed: 5, initialPrice: 500),
                        "Cook": Upgrade(numberOwned: 0, speed: 20, initialPrice: 3000)]
    
    var numOfPizzas: Int = 0
    var pizzaPerSec: Int = 0
    var timer = Timer()
    var speedKeeperTimer = Timer()
    var fireTimer = Timer()
    var fireImages = [#imageLiteral(resourceName: "Fire1"), #imageLiteral(resourceName: "Fire2"), #imageLiteral(resourceName: "Fire3")]
    var currentFireImage = 0
    
    var clicksPerSecond = 0
    var pointsPerClick = 1
    var averageClicksPerSecond = 0.0
    
    var fireIsOn: Bool = false


    
    // Getters
    func getNumOfPizzas() -> Int {
        return numOfPizzas
    }
    
    func getPointsPerClick() -> Int {
        return pointsPerClick
    }
    
    func getPizzaPerSec() -> Int {
        return pizzaPerSec
    }
    
    func getAverageClicksPerSecond() -> Double {
        return averageClicksPerSecond
    }
    
    func getFireIsOn() -> Bool {
        return fireIsOn
    }
    
    func getFireImage() -> UIImage {
        return fireImages[currentFireImage]
    }
    
    // Setters
    mutating func setPointsPerClick(value: Int) {
        pointsPerClick = value
    }
    
    mutating func setAverageClicksPerSecond(value: Double) {
        averageClicksPerSecond = value
    }
    
    mutating func setFireIsOn(value: Bool) {
        fireIsOn = value
    }
    
    // Functions
    mutating func incrementNumOfPizzasByClick() {
        numOfPizzas += pointsPerClick
    }
    
    mutating func incrementClicksPerSecond() {
        clicksPerSecond += 1
    }
    
    mutating func incrementNumOfPizzasAutomatically() {
        numOfPizzas += 1
    }
    
    mutating func buyUpgrade(upgradeName: String) {
        let upgrade = upgradesList[upgradeName]
        if numOfPizzas >= (upgrade?.currentPrice)! {
            numOfPizzas -= (upgrade?.currentPrice)!
            upgrade?.buy()
            pizzaPerSec += (upgrade?.speed)!
        }
    }
    
    mutating func calculateAverageClicksPerSecond() {
        averageClicksPerSecond += Double(Double(clicksPerSecond)/3.0)
        clicksPerSecond = 0
    }
    
    mutating func calculateCurrentFireImage() {
        if currentFireImage < 2 {
            currentFireImage += 1
        } else {
            currentFireImage = 0
        }
    }
    
    // String generators
    func generatePizzaPerSecLabel() -> String {
        return "\(String(pizzaPerSec + clicksPerSecond*pointsPerClick)) / sec"
    }
    
}
