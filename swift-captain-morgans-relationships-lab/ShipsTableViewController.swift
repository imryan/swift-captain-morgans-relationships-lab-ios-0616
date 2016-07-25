//
//  ShipsTableViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Ryan Cohen on 7/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ShipsTableViewController: UITableViewController {
    
    var ships: Set<Ship>!
    var pirate: Pirate!
    let store = DataStore.sharedInstance
    
    // MARK: - Functions
    
    @IBAction func add() {
        let alertController = UIAlertController(title: "Captain Morgans", message: "Add a new ship", preferredStyle: .Alert)
        var nameField: UITextField!
        var engineField: UITextField!
        
        let send = UIAlertAction(title: "Add", style: .Default) { (action) in
            var engineType: DataStore.EngineType = .Sail
            
            if (engineField.text == "Sail") {
                engineType = .Sail
            } else if (engineField.text == "Electric") {
                engineType = .Electric
            } else if (engineField.text == "Gas") {
                engineType = .Gas
            } else {
                // Shit out of luck if you can't type
                engineType = .Sail
            }
            
            self.store.addShip(nameField.text!, engineType: engineType, pirate: self.pirate)
            self.reload()
        }
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "Petey's Sick Ship"
            textField.returnKeyType = .Done
            
            nameField = textField
        })
        
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "Sail/Gas/Electric"
            textField.returnKeyType = .Done
            
            engineField = textField
        })
        
        alertController.addAction(send)
        alertController.addAction(dismiss)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ships.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath)

        let ship: Ship = Array(ships)[indexPath.row]
        cell.textLabel?.text = ship.name
        
        return cell

    }
    
    func reload() {
        store.fetchData()
        ships = pirate.ships
        
        tableView.reloadSections(NSIndexSet.init(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: .Automatic)
    }
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! ShipDetailViewController
        
        if let exitisingShips = ships {
            let shipsArray = Array(exitisingShips)
            
            if let index = tableView.indexPathForSelectedRow?.row {
                detailController.ship = shipsArray[index]
            }
        }
    }
}
