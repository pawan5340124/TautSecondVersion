//
//  PasswordSignIn.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class PasswordSignIn: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnMagicLink: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var ViewMagicLink: UIView!
    @IBOutlet weak var btnPasswordVisible: UIButton!
    @IBOutlet weak var ViewBtnNext: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    
    var TeamUrl : String = ""
    var Email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtPassword.becomeFirstResponder()
        self.SetUi()
    }
    
    func SetUi()  {
        
        self.ViewBtnNext.layer.cornerRadius = 6
        self.btnPasswordVisible.setImage(UIImage.init(named: "view"), for: .normal)
        self.txtPassword.isSecureTextEntry = true
        
        self.ViewMagicLink.layer.cornerRadius = 6
        self.ViewMagicLink.layer.borderWidth = 1
        self.ViewMagicLink.layer.borderColor = UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1).cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(DirectLoginWIthMagicLinkToken), name: NSNotification.Name(rawValue: "DirectLoginWIthMagicLinkToken"), object: nil)

        
    }
    
    @objc func DirectLoginWIthMagicLinkToken(){
        if(UserDefaults.standard.value(forKey: "DirectLoginWIthMagicLinkToken") != nil) {
            self.MagicLinkVerify()
        }
    }
    
    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NextScreen()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "{
            return false
        }
        else{
            return true
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnPasswordVisible(_ sender: Any) {
        if btnPasswordVisible.currentImage == UIImage.init(named: "view"){
            self.btnPasswordVisible.setImage(UIImage.init(named: "private"), for: .normal)
            self.txtPassword.isSecureTextEntry = false
        }
        else{
            self.btnPasswordVisible.setImage(UIImage.init(named: "view"), for: .normal)
            self.txtPassword.isSecureTextEntry = true
        }
        
    }
    @IBAction func btnNext(_ sender: Any) {
        self.NextScreen()

    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let INstaceCreate = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordLink") as! ResetPasswordLink
        INstaceCreate.TeamUrl = TeamUrl
        INstaceCreate.Email = Email
        self.present(INstaceCreate, animated: true, completion: nil)
    }
    
    @IBAction func btnSendMagicLink(_ sender: Any) {
        self.LogINWithMagicLink()
    }
    
    
    func NextScreen(){
        if txtPassword.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter password", TextField: self.txtPassword)
        }
//        else if self.txtPassword.text!.count < 6{
//            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter atleast 6 character", TextField: self.txtPassword)
//        }
        else{
             self.txtPassword.resignFirstResponder()
            self.LogINApiHit()
        }
    }
    
    //MARK:  -apiHit
    
    func MagicLinkVerify(){
        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: true)
        MyBaby.Loader.ButtonLoader(Button: self.btnMagicLink, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        
        
        MyBaby.ApiCall.ApiHitUsingGetMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.MagicLinkVerifyLogin as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "DirectLoginWIthMagicLinkToken") as! String], BodyParameter: [:], ApiName: "MagicLinkVerify", Log: true, Controller: self)
        
    }
    
    
    func LogINWithMagicLink(){
        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: true)
        MyBaby.Loader.ButtonLoader(Button: self.btnMagicLink, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.MagicLinkSendForLogIn as NSString, HeaderParameter: [:], BodyParameter: ["teamurl": TeamUrl,"email":Email,"password":self.txtPassword.text!], ApiName: "MagicLinkSend", Log: true, Controller: self)
        
    }
    
    
    func LogINApiHit(){
        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: true)
        MyBaby.Loader.ButtonLoader(Button: self.btnMagicLink, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.LogINAPi as NSString, HeaderParameter: [:], BodyParameter: ["teamurl": TeamUrl,"email":Email,"password":self.txtPassword.text!], ApiName: "LogInAPi", Log: true, Controller: self)
        
        
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: false)
        MyBaby.Loader.ButtonLoader(Button: self.btnMagicLink, LoaderColour: UIColor.black, show: false)
        if Success["ApiName"] as! String == "LogInAPi"{
            
            self.LogInDatamaintain(AllData: Success)
  
        }
        else if Success["ApiName"] as! String == "MagicLinkSend"{
            self.LaunchEmailApp()
        }
        else if Success["ApiName"] as! String == "MagicLinkVerify"{
            UserDefaults.standard.removeObject(forKey: "DirectLoginWIthMagicLinkToken")
            UserDefaults.standard.synchronize()
            let appobject = UIApplication.shared.delegate as! AppDelegate
            appobject.HomeRoot()
            
            
        }
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: false)
        MyBaby.Loader.ButtonLoader(Button: self.btnMagicLink, LoaderColour: UIColor.black, show: false)

        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")
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
                NameCAlculate = TEmpData["name"] as! String
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
