//
//  ViewController.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-02.
//

import UIKit

class ViewController: UIViewController {
    
    var pizzaBrain = PizzaBrain()
    
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


    // Top Outlets
    @IBOutlet weak var numOfPizzasLabel: UILabel!
    @IBOutlet weak var pizzaPerSecLabel: UILabel!
    
    // Middle Outlets
    @IBOutlet weak var pizzaButton: UIImageView!
    @IBOutlet weak var pizzaHeight: NSLayoutConstraint!
    @IBOutlet weak var pizzaWidth: NSLayoutConstraint!
    @IBOutlet weak var glowRays: UIImageView!
    @IBOutlet weak var glowRaysHeight: NSLayoutConstraint!
    @IBOutlet weak var glowRaysWidth: NSLayoutConstraint!
    
    @IBOutlet weak var fire: UIImageView!
    @IBOutlet weak var fireHeight: NSLayoutConstraint!
    
    // Bottom Outlets
    // Mamma Mia
    @IBOutlet weak var numberOfMammaMia: UILabel!
    @IBOutlet weak var mammaMiaPriceLabel: UILabel!
    // Cutter
    @IBOutlet weak var numberOfCutters: UILabel!
    @IBOutlet weak var cutterPriceLabel: UILabel!
    @IBOutlet weak var cutterLock: UIView!
    
    // Cook
    @IBOutlet weak var numberOfCook: UILabel!
    @IBOutlet weak var cookPriceLabel: UILabel!
    @IBOutlet weak var cookLock: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(checkSpeed), userInfo: nil, repeats: true)
        speedKeeperTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calculateSpeed), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(rotateRays), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(raysAnimation), userInfo: nil, repeats: true)
    }

    @IBAction func pizzaPressed(_ sender: UIButton) {
        numOfPizzas += pointsPerClick
        numOfPizzasLabel.text = "\(numOfPizzas) Pizzas!"
        clicksPerSecond += 1
        
        
        pizzaHeight.constant = 250
        pizzaWidth.constant = 250
        self.view.layoutIfNeeded()
        
        generatePoint()
    }
    
    @IBAction func pizzaTouchDown(_ sender: UIButton) {
        
        pizzaHeight.constant = 240
        pizzaWidth.constant = 240
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func UpgradePressed(_ sender: UIButton) {
        buyUpgrade(upgradeName: sender.currentTitle!)
    }
    
    func buyUpgrade(upgradeName: String) {
        let upgrade = upgradesList[upgradeName]
        if numOfPizzas >= (upgrade?.currentPrice)! {
            numOfPizzas -= (upgrade?.currentPrice)!
            upgrade?.buy()
            pizzaPerSec += (upgrade?.speed)!
            updateUI()
            updateTimer()
        }
    }
    
    func updateUI() {
        numOfPizzasLabel.text = "\(numOfPizzas) Pizzas!"
        pizzaPerSecLabel.text = "\(String(pizzaPerSec + clicksPerSecond*pointsPerClick)) / sec"
        
        numberOfMammaMia.text = String((upgradesList["MammaMia"]?.numberOwned)!)
        
        if String((upgradesList["MammaMia"]?.currentPrice)!).count > 3 {
            mammaMiaPriceLabel.text = "\(String(format: "%.1f",(Double(upgradesList["MammaMia"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            mammaMiaPriceLabel.text = String((upgradesList["MammaMia"]?.currentPrice)!)
        }
        
        numberOfCutters.text = String((upgradesList["Cutter"]?.numberOwned)!)
        if String((upgradesList["Cutter"]?.currentPrice)!).count > 3 {
            cutterPriceLabel.text = "\(String(format: "%.1f",(Double(upgradesList["Cutter"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            cutterPriceLabel.text = String((upgradesList["Cutter"]?.currentPrice)!)
        }
        
        numberOfCook.text = String((upgradesList["Cook"]?.numberOwned)!)
        if String((upgradesList["Cook"]?.currentPrice)!).count > 3 {
            cookPriceLabel.text = "\(String(format: "%.1f",(Double(upgradesList["Cook"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            cookPriceLabel.text = String((upgradesList["Cook"]?.currentPrice)!)
        }
        
        if (upgradesList["MammaMia"]?.numberOwned)! > 0 && cutterLock.isHidden == false {
            cutterLock.isHidden = true
            numberOfCutters.isHidden = false
        }
        
        if (upgradesList["Cutter"]?.numberOwned)! > 0 && cookLock.isHidden == false {
            cookLock.isHidden = true
            numberOfCook.isHidden = false
        }
        
        
    }
    
    @objc func makePizzasAutomatically() {
        numOfPizzas += 1
        numOfPizzasLabel.text = "\(numOfPizzas) Pizzas!"
    }
    
    func updateTimer() {
        timer.invalidate()
        if pizzaPerSec > 0 {
            timer = Timer.scheduledTimer(timeInterval: 1.0/Double(pizzaPerSec), target: self, selector: #selector(makePizzasAutomatically), userInfo: nil, repeats: true)
        }
    }
    
    @objc func calculateSpeed() {
        pizzaPerSecLabel.text = "\(String(pizzaPerSec + clicksPerSecond*pointsPerClick)) / sec"
        averageClicksPerSecond += Double(Double(clicksPerSecond)/3.0)
        clicksPerSecond = 0
    }
    
    @objc func checkSpeed() {
        if averageClicksPerSecond < 4 && (pointsPerClick == 2 || pointsPerClick == 1) {
            pointsPerClick = 1
        } else if averageClicksPerSecond < 6 {
            pointsPerClick = 2
            stopFire()
        } else if averageClicksPerSecond >= 6 && pointsPerClick == 1 {
            pointsPerClick = 2
        } else if averageClicksPerSecond >= 6 && pointsPerClick == 2 {
            pointsPerClick = 3
            startFire()
        }
        
        averageClicksPerSecond = 0
        
    }
    
    func startFire() {
        if !fireIsOn {
            fireTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateFire), userInfo: nil, repeats: true)
            self.fireHeight.constant = 230
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.fireIsOn = true
            }
        }
    }
    
    func stopFire() {
        if fireIsOn {
            self.fireHeight.constant = 1
            UIView.animate(withDuration: 2) {
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.fireHeight.constant = 0
                self.view.layoutIfNeeded()
                self.fireIsOn = false
                self.fireTimer.invalidate()
            }
        }
    }
    
    @objc func animateFire() {
        if currentFireImage < 2 {
            currentFireImage += 1
        } else {
            currentFireImage = 0
        }
        
        fire.image = fireImages[currentFireImage]
    }
    
    @objc func rotateRays() {
        glowRays.transform = glowRays.transform.rotated(by: .pi/720)
    }
    
    @objc func raysAnimation() {
        
        self.glowRaysHeight.constant = 380
        self.glowRaysHeight.constant = 380
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.glowRaysHeight.constant = 450
            self.glowRaysHeight.constant = 450
            UIView.animate(withDuration: 2, animations: {
                self.view.layoutIfNeeded()
            })
        })

    }
    
    func generatePoint() {
        let screenWidth = Int(self.view.frame.size.width)
        let screenHeight = Int(self.view.frame.size.height)
        let label = UILabel()
        label.text = "+\(pointsPerClick)"
        label.frame = CGRect(x: Int.random(in: (screenWidth/2)-145 ... (screenWidth/2)+55), y: Int.random(in: (screenHeight/2)-140 ... (screenHeight/2)+40), width: 90, height: 80)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "Snell Roundhand Bold", size: 70)
        label.textAlignment = NSTextAlignment.center
        label.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.shadowOffset.height = 3
        label.shadowOffset.width = 2
        
        view.addSubview(label)
        
        UIView.animate(withDuration: 1) {
            label.transform = CGAffineTransform(translationX: 0, y: -150)
            label.alpha = 0
        } completion: { (_) in
            label.removeFromSuperview()
        }

        
    }
    
    
    
    
}

