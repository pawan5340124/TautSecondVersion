//
//  AddDirectMessage.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 11/09/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class AddDirectMessage: UIViewController,UITableViewDelegate,UITableViewDataSource,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tableViewMain: UITableView!
    var MemberListArray : NSArray = []
    var SelectedArray : NSMutableArray = []
    var selectedIdContain : NSMutableArray = []
    var selectedNameContain : NSMutableArray = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.register(UINib.init(nibName: "directMessageAddCell", bundle: nil), forCellReuseIdentifier: "directMessageAddCell")
        let TEamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        MemberListArray = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TEamData["teamid"] as! String, TableName: "MemberList")
        selectedIdContain.removeAllObjects()
        selectedNameContain.removeAllObjects()
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        tableViewMain.reloadData()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - ButtonAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDirectMessage(_ sender: Any) {
        if selectedIdContain.count == 0{
          MyBaby.Alert.AlertAppear(Messaage: "Please select member", Title: "", View: self, Button: false, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")
        }
        else{
            self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

            let teamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
            selectedIdContain.add(teamData["userid"] as! String)
            let IdValueSelected = selectedIdContain.componentsJoined(by: ",")
            let NameValueSelected = selectedNameContain.componentsJoined(by: ",")
            
            let headerDict = ["sessiontoken" : teamData["SessionToken"] as! String]
            let Body = ["memberids":IdValueSelected,"teamid":teamData["teamid"] as! String,"name":NameValueSelected] as [String : Any]
            MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.Creategroup as NSString, HeaderParameter: headerDict, BodyParameter: Body as NSDictionary, ApiName: "CreateGroup", Log: true, Controller: self)
        }
        
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewMain.dequeueReusableCell(withIdentifier: "directMessageAddCell", for: indexPath) as! directMessageAddCell
        cell.selectionStyle = .none
        

        
            let tempDict = MemberListArray[indexPath.row] as! NSDictionary
            let ID = tempDict["_id"] as! String
        
            if selectedIdContain.contains(ID) == true{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
            }
            else{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Ellipse 329"), for: .normal)
            }
            cell.lblName.text = tempDict["name"] as? String
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.layer.frame.height / 2
        
  

        self.tableViewMain.tableFooterView = UIView()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempDict = MemberListArray[indexPath.row] as! NSDictionary
        let ID = tempDict["_id"] as! String
        if selectedIdContain.contains(ID) == true{
            selectedIdContain.remove(ID)
            selectedNameContain.remove(tempDict["name"] as! String)
            SelectedArray.remove(tempDict)
        }else{
            selectedIdContain.add(ID)
            selectedNameContain.add(tempDict["name"] as! String)
            SelectedArray.add(tempDict)
        }
        tableViewMain.reloadData()
        
    }
    
    
    //MARK: - ApiResponceDelegate
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        let TEmpData = Success["data"] as! NSDictionary

        let DIctionaryCreate = ["_id":TEmpData["_id"] as? String ?? "","isPrivate":TEmpData["isPrivate"] as? String ?? "","name":TEmpData["name"] as? String ?? "","purpose":TEmpData["purpose"] as? String ?? "","status":TEmpData["status"] as? String ?? "","type":TEmpData["type"] as? String ?? ""]
            UserDefaults.standard.set(DIctionaryCreate, forKey: "OpenGroupForChat")
  
        self.navigationController?.popViewController(animated: true)
        
        
        
        
//        MyBaby.Alert.AlertAppear(Messaage: Success["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "OK", SecondButtonText: "")
//        let when = DispatchTime.now() + 2.5
//        DispatchQueue.main.asyncAfter(deadline: when)
//        {
//            self.navigationController?.popViewController(animated: true)
//        }


    }
    
    func ApiResponceFailure(Failure: NSDictionary) {
        print(Failure)
        self.stopAnimating()
        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")


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
