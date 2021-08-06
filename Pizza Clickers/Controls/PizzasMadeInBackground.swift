//
//  PizzasMadeInBackground.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-29.
//

import UIKit

class PizzasMadeInBackground: UIViewController {
    
    var pizzasMadeInBackground: String?

    @IBOutlet weak var pizzasMadeInBackgroundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pizzasMadeInBackgroundLabel.text = pizzasMadeInBackground
        // Do any additional setup after loading the view.
    }
    
    @IBAction func makeMore(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
