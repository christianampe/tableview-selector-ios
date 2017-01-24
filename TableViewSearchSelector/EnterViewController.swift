//
//  EnterViewController.swift
//  AdminStoryboard
//
//  Created by Ampe on 1/11/17.
//  Copyright © 2017 Ampe. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toprofilecompletion", sender: nil)
    }

}
