//
//  SignUpTeamUrl.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class SignUpTeamUrl: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewBtnNext: UIView!
    @IBOutlet weak var txtTeamUrl: UITextField!
    var TeamName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewBtnNext.layer.cornerRadius = 6
        self.txtTeamUrl.becomeFirstResponder()
        if self.txtTeamUrl.text == ""{
            txtTeamUrl.textAlignment = .left
        }
        else{
            txtTeamUrl.textAlignment = .right
        }
    }
    
    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NextScreen()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != ""{
            if self.txtTeamUrl.text!.count > 19{
                return false
            }
        }
        
        self.txtTeamUrl.placeholder = ""
        if string == "" && self.txtTeamUrl.text?.count == 1{
            self.txtTeamUrl.placeholder = "your_team"
            txtTeamUrl.textAlignment = .left
        }
        else{
            txtTeamUrl.textAlignment = .right
        }
        
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any) {
        self.NextScreen()
    }
    func NextScreen(){
        if txtTeamUrl.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter team url", TextField: self.txtTeamUrl)
        }
        else{
           self.CheckTeamUrl()
        }
    }
    
    
    //MARK:  - ApiCall
    func CheckTeamUrl(){
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: true)
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterCheckTeamUrl as NSString, HeaderParameter: ["Content-Type":"application/x-www-form-urlencoded"], BodyParameter: ["teamurl":self.txtTeamUrl.text!], ApiName: "CheckTeamExistOrNot", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        print(Success)
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)
        MyBaby.Alert.AlertAppear(Messaage: Success["message"] as! String, Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")

    }
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)
        self.stopAnimating()
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpFullName") as! SignUpFullName
        Instace.TeamName = self.TeamName
        Instace.TeamUrl = self.txtTeamUrl.text!
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
