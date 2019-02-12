//
//  ViewController.swift
//  sqliteInSwift
//
//  Created by Jenny Chang on 12/02/2019.
//  Copyright © 2019 Jenny Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        do {
            let db = try DataManager()
            let people = try db.getAllFamousPeople()
            for person in people {
                print("\(String(describing: person.firstName)) \(String(describing: person.lastName))")
            }
        }
        catch let error {
            print("error \(error)")
        }
    }
    
}

