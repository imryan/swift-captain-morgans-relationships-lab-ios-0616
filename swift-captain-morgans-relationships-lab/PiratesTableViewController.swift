//
//  PiratesTableViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Ryan Cohen on 7/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PiratesTableViewController: UITableViewController {
    
    var pirates: [Pirate] = []
    let store = DataStore.sharedInstance

    // MARK: - Functions
    
    @IBAction func add() {
        let alertController = UIAlertController(title: "Captain Morgans", message: "Add a new pirate", preferredStyle: .Alert)
        var field: UITextField!
        
        let send = UIAlertAction(title: "Add", style: .Default) { (action) in
            self.store.addPirate(field.text!)
            self.reload()
        }
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "Petey Doe"
            textField.returnKeyType = .Done
            
            field = textField
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
        return pirates.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath)

        let pirate: Pirate = pirates[indexPath.row]
        cell.textLabel?.text = pirate.name
        
        if let count = pirate.ships?.count {
            cell.detailTextLabel?.text = (count == 1) ? "\(count) Ship" : "\(count) Ships"
        }

        return cell
    }
    
    func reload() {
        store.fetchData()
        pirates = store.pirates
        
        tableView.reloadSections(NSIndexSet.init(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: .Automatic)
    }
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        store.fetchData()
        pirates = store.pirates
        
        tableView.reloadData()
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
        let shipsController = segue.destinationViewController as! ShipsTableViewController
        
        if let index = tableView.indexPathForSelectedRow?.row {
            let pirate = pirates[index]
            shipsController.pirate = pirate
        }
    }
}
