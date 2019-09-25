//
//  CustomSplash.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 20/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby



class CustomSplash: UIViewController {

     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //manage member data if after api not hit
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let MemberList = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TeamData["teamid"] as! String, TableName: "MemberList")
        MemberListCustom.removeAllObjects()
        for item in MemberList{
            let Data = item as! NSDictionary
            let ID = Data["_id"] as! String
            MemberListCustom.setValue(Data, forKey: ID)
        }

        NewFunctionCall.SocketStart()
        self.NavigateOnPAge()
        NewFunctionCall.NetworkObserver()
        // Do any additional setup after loading the view.
    }
    

    func NavigateOnPAge(){
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.LounchChat()
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
