//
//  ViewController.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-02.
//

import UIKit

class ViewController: UIViewController {
    
    var pizzaBrain = PizzaBrain()


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
        pizzaBrain.speedKeeperTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calculateSpeed), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(rotateRays), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(raysAnimation), userInfo: nil, repeats: true)
    }

    @IBAction func pizzaPressed(_ sender: UIButton) {
        pizzaBrain.incrementNumOfPizzasByClick()
        numOfPizzasLabel.text = "\(pizzaBrain.getNumOfPizzas()) Pizzas!"
        pizzaBrain.incrementClicksPerSecond()
        
        
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
        pizzaBrain.buyUpgrade(upgradeName: sender.currentTitle!)
        updateUI()
        pizzaBrain.timer.invalidate()
        if pizzaBrain.getPizzaPerSec() > 0 {
            pizzaBrain.timer = Timer.scheduledTimer(timeInterval: 1.0/Double(pizzaBrain.getPizzaPerSec()), target: self, selector: #selector(makePizzasAutomatically), userInfo: nil, repeats: true)
        }
    }
    
    func updateUI() {
        numOfPizzasLabel.text = "\(pizzaBrain.getNumOfPizzas()) Pizzas!"
        pizzaPerSecLabel.text = pizzaBrain.generatePizzaPerSecLabel()
        
        numberOfMammaMia.text = String((pizzaBrain.upgradesList["MammaMia"]?.numberOwned)!)
        
        if String((pizzaBrain.upgradesList["MammaMia"]?.currentPrice)!).count > 3 {
            mammaMiaPriceLabel.text = "\(String(format: "%.1f",(Double(pizzaBrain.upgradesList["MammaMia"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            mammaMiaPriceLabel.text = String((pizzaBrain.upgradesList["MammaMia"]?.currentPrice)!)
        }
        
        numberOfCutters.text = String((pizzaBrain.upgradesList["Cutter"]?.numberOwned)!)
        if String((pizzaBrain.upgradesList["Cutter"]?.currentPrice)!).count > 3 {
            cutterPriceLabel.text = "\(String(format: "%.1f",(Double(pizzaBrain.upgradesList["Cutter"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            cutterPriceLabel.text = String((pizzaBrain.upgradesList["Cutter"]?.currentPrice)!)
        }
        
        numberOfCook.text = String((pizzaBrain.upgradesList["Cook"]?.numberOwned)!)
        if String((pizzaBrain.upgradesList["Cook"]?.currentPrice)!).count > 3 {
            cookPriceLabel.text = "\(String(format: "%.1f",(Double(pizzaBrain.upgradesList["Cook"]?.currentPrice ?? 0))/1000.0))k"
        } else {
            cookPriceLabel.text = String((pizzaBrain.upgradesList["Cook"]?.currentPrice)!)
        }
        
        if (pizzaBrain.upgradesList["MammaMia"]?.numberOwned)! > 0 && cutterLock.isHidden == false {
            cutterLock.isHidden = true
            numberOfCutters.isHidden = false
        }
        
        if (pizzaBrain.upgradesList["Cutter"]?.numberOwned)! > 0 && cookLock.isHidden == false {
            cookLock.isHidden = true
            numberOfCook.isHidden = false
        }
        
        
    }
    
    @objc func makePizzasAutomatically() {
        pizzaBrain.incrementNumOfPizzasAutomatically()
        numOfPizzasLabel.text = "\(pizzaBrain.getNumOfPizzas()) Pizzas!"
    }
    
    @objc func calculateSpeed() {
        pizzaPerSecLabel.text = pizzaBrain.generatePizzaPerSecLabel()
        pizzaBrain.calculateAverageClicksPerSecond()
    }
    
    @objc func checkSpeed() {
        if pizzaBrain.getAverageClicksPerSecond() < 4 && (pizzaBrain.getPointsPerClick() == 2 || pizzaBrain.getPointsPerClick() == 1) {
            pizzaBrain.setPointsPerClick(value: 1)
        } else if pizzaBrain.getAverageClicksPerSecond() < 6 {
            pizzaBrain.setPointsPerClick(value: 2)
            stopFire()
        } else if pizzaBrain.getAverageClicksPerSecond() >= 6 && pizzaBrain.getPointsPerClick() == 1 {
            pizzaBrain.setPointsPerClick(value: 2)
        } else if pizzaBrain.getAverageClicksPerSecond() >= 6 && pizzaBrain.getPointsPerClick() == 2 {
            pizzaBrain.setPointsPerClick(value: 3)
            startFire()
        }
        
        pizzaBrain.setAverageClicksPerSecond(value: 0)
        
    }
    
    func startFire() {
        if !pizzaBrain.getFireIsOn() {
            pizzaBrain.fireTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateFire), userInfo: nil, repeats: true)
            self.fireHeight.constant = 230
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.pizzaBrain.setFireIsOn(value: true)
            }
        }
    }
    
    func stopFire() {
        if pizzaBrain.getFireIsOn() {
            self.fireHeight.constant = 1
            UIView.animate(withDuration: 2) {
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.fireHeight.constant = 0
                self.view.layoutIfNeeded()
                self.pizzaBrain.setFireIsOn(value: false)
                self.pizzaBrain.fireTimer.invalidate()
            }
        }
    }
    
    @objc func animateFire() {
        pizzaBrain.calculateCurrentFireImage()
        fire.image = pizzaBrain.getFireImage()
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
        label.text = "+\(pizzaBrain.getPointsPerClick())"
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

