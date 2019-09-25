//
//  SecondViewController.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 20/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LastScreen(_ sender: Any) {
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        self.navigationController?.pushViewController(Instace, animated: true)
    }
    
    @IBAction func BtnReset(_ sender: Any) {
        let appobject = UIApplication.shared.delegate as! AppDelegate
//        appobject.ResetRoot()
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
