//
//  SelectedAreaViewController.swift
//  WeatherApp
//
//  Created by Roger Villarreal on 2/23/18.
//  Copyright © 2018 Roger Alexander. All rights reserved.
//

import UIKit

class SelectedAreaViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    var temperaturePassed = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        temperatureLabel.text = temperaturePassed
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
