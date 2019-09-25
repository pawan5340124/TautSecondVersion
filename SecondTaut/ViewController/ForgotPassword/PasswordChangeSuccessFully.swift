//
//  PasswordChangeSuccessFully.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class PasswordChangeSuccessFully: UIViewController {

    @IBOutlet weak var viewLogINAgain: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLogINAgain.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnlogInAgain(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

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
