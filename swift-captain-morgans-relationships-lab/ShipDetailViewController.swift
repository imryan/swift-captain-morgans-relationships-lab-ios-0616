//
//  ShipDetailViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Ryan Cohen on 7/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ShipDetailViewController: UIViewController {
    
    var ship: Ship?
    
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var pirateNameLabel: UILabel!
    @IBOutlet weak var shipEngineLabel: UILabel!

    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shipNameLabel.text = ship?.name
        pirateNameLabel.text = ship?.pirate?.name
        shipEngineLabel.text = ship?.engine?.propulsionType
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
