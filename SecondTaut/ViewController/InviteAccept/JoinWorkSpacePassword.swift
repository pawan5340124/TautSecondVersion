//
//  JoinWorkSpacePassword.swift
//  Taut
//
//  Created by Matrix Marketers on 01/07/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class JoinWorkSpacePassword: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var viewSubmitButton: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    var FullName : String = ""
    var TeamData : NSDictionary = [:]
    var NewTOKEN : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       self.txtPassword.text = ""
        NewTOKEN = UserDefaults.standard.value(forKey: "AcceptInvitationToken") as! String
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewSubmitButton.layer.cornerRadius = 6
    }
    
    @IBAction func btnback(_ sender: Any) {
        self.txtPassword.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSubmit(_ sender: Any) {
        self.Forword()
    }
    
    func Forword(){
        if txtPassword.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter password", TextField: self.txtPassword)
            
        }
        else{
            
            self.startAnimating(CGSize(width: 50, height:50), type: NVActivityIndicatorType.lineSpinFadeLoader, color: UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1), backgroundColor: UIColor.clear)

            let HeaderDict = ["devicetype":"I","devicetoken":UserDefaults.standard.value(forKey: "deviceToken") as! String]
            let Body = ["name":FullName,"password":self.txtPassword.text!,"teamid":TeamData["teamid"] as! String,"id":TeamData["_id"] as! String] as [String : Any]
            MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.CompleteVerification as NSString, HeaderParameter: HeaderDict, BodyParameter: Body as NSDictionary, ApiName: "acceptComplete", Log: true, Controller: self)

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       self.Forword()
        return true
    }
    
    //MARK: - ApiResponce
    func ApiResponceSuccess(Success: NSDictionary) {
        print(Success)
        self.LogInDatamaintain(AllData: Success)

        
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        print(Failure)
        self.stopAnimating()
    }
    
    
    
    func LogInDatamaintain(AllData : NSDictionary){
        
        let RawData = AllData["data"] as! NSDictionary
        let Group = RawData["groups"] as! NSArray
        let Members  =  RawData["members"] as! NSArray
        let MessageList  =  RawData["messageslist"] as! NSArray
        _ = MyBaby.MySqualDatabase.DeleteCompleteDatabase(databaseName: RawData["teamid"] as! String)
        var mydataGot : NSDictionary = [:]
        for item in Members{
            let TempData = item as! NSDictionary
            if TempData["_id"] as! String != RawData["userid"] as! String{
                _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "MemberList", DataWantToSave: TempData)
            }else{
                mydataGot = TempData
            }
        }
        for Item in Group{
            let TEmpData = Item as! NSDictionary
            let Type = TEmpData["type"] as! String
            if Type == "channel"{
                let DIctionaryCreate = ["_id":TEmpData["_id"] as! String,"isPrivate":TEmpData["isPrivate"] as! String,"name":TEmpData["name"] as! String,"purpose":TEmpData["purpose"] as! String,"status":TEmpData["status"] as! String,"type":TEmpData["type"] as! String]
                _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "ChannelList", DataWantToSave: DIctionaryCreate as NSDictionary)
            }
            else{
                let MemberListArray = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "MemberList")
                var NameCAlculate : String = ""
                for newItem in MemberListArray{
                    let TempDataCreate = newItem as! NSDictionary
                    let MEmberId = TempDataCreate["_id"] as! String
                    let GroupMemberArray = TEmpData["members"] as! NSArray
                    if Type != "group"{
                        NameCAlculate = TEmpData["name"] as! String
                    }
                    else if GroupMemberArray.contains(MEmberId) == true  {
                        if NameCAlculate == ""{
                            NameCAlculate = TempDataCreate["name"] as! String
                        }
                        else{
                            NameCAlculate = NameCAlculate + "," + String( TempDataCreate["name"] as! String)
                        }
                    }
                }
                
                let MemberID : NSArray = TEmpData["members"] as! NSArray
                let AllMemberIds = MemberID.componentsJoined(by: ",")
                let DIctionaryCreate = ["_id":TEmpData["_id"] as! String,"isPrivate":TEmpData["isPrivate"] as! String,"name":NameCAlculate,"purpose":TEmpData["purpose"] as! String,"status":TEmpData["status"] as! String,"type":TEmpData["type"] as! String,"MemberId":AllMemberIds]
                _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "GroupList", DataWantToSave: DIctionaryCreate as NSDictionary)
            }
        }
        for Item in MessageList{
            let tempData = Item as! NSDictionary
            _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: tempData["teamId"] as! String, TableName: tempData["chat_group_id"] as! String, DataWantToSave: tempData)
        }
        
        
        
        let TeamData = ["SessionToken" : RawData["sessiontoken"] as! String,"teamid" : RawData["teamid"] as! String,"teamname" : RawData["teamname"] as! String,"teamurl":RawData["teamurl"] as! String,"userid" : RawData["userid"] as! String,"Mydata":mydataGot] as [String : Any]
        UserDefaults.standard.set(TeamData, forKey: "LogInTeamData")
        let GetGroupData = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "GroupList")
        UserDefaults.standard.set(GetGroupData[0] as! NSDictionary, forKey: "OpenGroupForChat")
        UserDefaults.standard.synchronize()
        self.stopAnimating()
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.HomeRoot()
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
