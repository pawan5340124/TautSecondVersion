//
//  InvitePeopleViewController.swift
//  Taut
//
//  Created by Matrix Marketers on 01/07/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView
import Alamofire

class InvitePeopleViewController: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var viewBtnInvite: UIView!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var txtemail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtemail.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewBtnInvite.layer.cornerRadius = 6

    }
    
    @IBAction func btnInviteSend(_ sender: Any) {
        self.Forword()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.txtemail.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)

    }
    
    func Forword(){
        if MyBaby.TextField.TextFieldIsValidEmail(TextFieldString: self.txtemail.text!) == false{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter valid email", TextField: self.txtemail)
        }
        else{
            self.InviteSendAPiHit()
        }
    }
    
    //MARK: - TExtFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.Forword()
        return true
    }
    
    
    //MAKE : - APiHit
    func InviteSendAPiHit(){
        self.startAnimating(CGSize(width: 50, height:50), type: NVActivityIndicatorType.lineSpinFadeLoader, color: UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1), backgroundColor: UIColor.clear)
        let teamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let EmailData = ["email":self.txtemail.text!,"name":""]
        let EmailArray = [EmailData]
        let Body = ["teamid":teamData["teamid"] as! String,"email":EmailArray] as [String : Any]
        MyBaby.ApiCall.ApiHitWithRawDataFormat(ApiMethod: "POST", APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.InvitationSend as NSString, HeaderParameter: ["Content-Type":"application/json"], BodyParameter: Body as NSDictionary, ApiName: "InvitePeople", Log: true, Controller: self)

    }
    
    
    
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        MyBaby.Alert.AlertAppear(Messaage: Success["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "", SecondButtonText: "")
    }
    
    func ApiResponceFailure(Failure: NSDictionary) {
         self.stopAnimating()
        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "", SecondButtonText: "")
        
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
