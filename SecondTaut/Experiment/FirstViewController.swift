//
//  FirstViewController.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 20/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController { 

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func firstButton(_ sender: Any) {
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.navigationController?.pushViewController(Instace, animated: true)
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
