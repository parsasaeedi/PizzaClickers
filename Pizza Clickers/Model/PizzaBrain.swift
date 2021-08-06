//
//  PizzaBrain.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-11.
//

import UIKit

struct PizzaBrain {
    
    let defaults = UserDefaults.standard
    
    init() {
        let hasPlayedBeforeConstant = defaults.bool(forKey: "hasPlayedBefore")
        if !hasPlayedBeforeConstant {
            numOfPizzas = 0
            pizzaPerSec = 0
            upgradesList = [
                "MammaMia": Upgrade(numberOwned: 0, speed: 1, initialPrice: 50),
                "Cutter": Upgrade(numberOwned: 0, speed: 5, initialPrice: 500),
                "Cook": Upgrade(numberOwned: 0, speed: 20, initialPrice: 3000)]
            hasPlayedBefore = true
        } else {
            loadData()
        }
    }
    var upgradesList: [String : Upgrade]?
    
    var numOfPizzas: Int?
    var pizzaPerSec: Int?
    
    var hasPlayedBefore: Bool = true
    
    let maxTimeInBackground = 43200
    var pizzasMadeInBackground = 0

    
    // Timers
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
        return numOfPizzas ?? 0
    }
    
    func getPointsPerClick() -> Int {
        return pointsPerClick
    }
    
    func getPizzaPerSec() -> Int {
        return pizzaPerSec ?? 0
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
    
    func getPizzasMadeInBackground() -> String {
        return String(pizzasMadeInBackground)
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
        numOfPizzas = (numOfPizzas ?? 0) + pointsPerClick
    }
    
    mutating func incrementClicksPerSecond() {
        clicksPerSecond += 1
    }
    
    mutating func incrementNumOfPizzasAutomatically() {
        numOfPizzas = (numOfPizzas ?? 0) + 1
    }
    
    mutating func buyUpgrade(upgradeName: String) {
        let upgrade = upgradesList?[upgradeName]
        if numOfPizzas ?? 0 >= (upgrade?.currentPrice)! {
            numOfPizzas = (numOfPizzas ?? 0) - (upgrade?.currentPrice)!
            upgrade?.buy()
            pizzaPerSec = (pizzaPerSec ?? 0) + (upgrade?.speed)!
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
        return "\(String((pizzaPerSec ?? 0)  + clicksPerSecond*pointsPerClick)) / sec"
    }
    
    
    // Save and Load
    
    func saveData() {
        
//        timer.invalidate()
//        speedKeeperTimer.invalidate()
//        fireTimer.invalidate()
        
        let lastTimePlayed = Int(Date().timeIntervalSince1970)
        
        let encoder = JSONEncoder()
        if let encodedUpgradesList = try? encoder.encode(upgradesList) {
            UserDefaults.standard.set(encodedUpgradesList, forKey: "upgradesList")
        }
        defaults.set(numOfPizzas, forKey: "numOfPizzas")
        defaults.set(pizzaPerSec, forKey: "pizzaPerSec")
        defaults.set(hasPlayedBefore, forKey: "hasPlayedBefore")
        defaults.set(lastTimePlayed, forKey: "lastTimePlayed")
        
        defaults.synchronize()
    }
    
    mutating func loadData() {
        if let encodedUpgradesList = defaults.value(forKey: "upgradesList") as? Data {
            let decoder = JSONDecoder()
            if let decodedUpgradesList = try? decoder.decode(Dictionary.self, from: encodedUpgradesList) as [String : Upgrade]? {
                upgradesList = decodedUpgradesList
            }
        }
        
        self.numOfPizzas = defaults.integer(forKey: "numOfPizzas")
        self.pizzaPerSec = defaults.integer(forKey: "pizzaPerSec")
        
        let lastTimePlayed = defaults.integer(forKey: "lastTimePlayed")
        let currentTime = Int(Date().timeIntervalSince1970)
        let timeSinceLastPlayed = (currentTime - lastTimePlayed)
        if timeSinceLastPlayed < maxTimeInBackground {
            pizzasMadeInBackground = Int(timeSinceLastPlayed * (pizzaPerSec ?? 0) / 20)
        } else {
            pizzasMadeInBackground = Int(maxTimeInBackground * (pizzaPerSec ?? 0) / 20)
        }
        self.numOfPizzas = numOfPizzas! + pizzasMadeInBackground

        
        currentFireImage = 0
        clicksPerSecond = 0
        pointsPerClick = 1
        averageClicksPerSecond = 0.0
        fireIsOn = false
        
    }
    
}
