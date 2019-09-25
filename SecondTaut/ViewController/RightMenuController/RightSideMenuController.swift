//
//  RightSideMenuController.swift
//  PawanKumar
//
//  Created by Matrix Marketers on 30/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class RightSideMenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("Right navigaiton controller launch")
    }

    @IBAction func btnNavigation(_ sender: Any) {
//        let menu = storyboard!.instantiateViewController(withIdentifier: "LogOut") as! LogOut
//        self.navigationController?.pushViewController(menu, animated: true)
        
        
    }
    @IBAction func btnInvitation(_ sender: Any) {
                let menu = storyboard!.instantiateViewController(withIdentifier: "InvitePeopleViewController") as! InvitePeopleViewController
                self.navigationController?.pushViewController(menu, animated: true)
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
