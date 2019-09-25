//
//  SignUpEmail.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class SignUpEmail: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    

    //MARK: - Outlet
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var ViewNextButton: UIView!
    @IBOutlet weak var viewTextEmail: UIView!
    @IBOutlet weak var TxtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUI()
        // Do any additional setup after loading the view.
    }
    
    func SetUI(){
        self.ViewNextButton.layer.cornerRadius = 6
        MyBaby.TextField.TextFieldPlaceHolderColorChange(textField: self.TxtEmail, color: UIColor.black)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TxtEmail.becomeFirstResponder()
    }
   
    
    
    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NextScreen()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_@.-"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    
    //MARK: - ButtonAction
    @IBAction func btnNext(_ sender: Any) {
      self.NextScreen()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func EMailVerificationLinkSend()  {

        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        let Parameter = ["email": self.TxtEmail.text!]
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterEmailSend as NSString, HeaderParameter: [:], BodyParameter: Parameter as NSDictionary, ApiName: "RegisterVerificationLink", Log: false, Controller: self)
        
        
    }
    
    //MARK: - ApiResponceHandel
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)

        if Success["token"] != nil{
            //first time mail enter
            UserDefaults.standard.set(Success["token"] as! String, forKey: "CreateTeamToken")
            UserDefaults.standard.synchronize()
            let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpTeamName") as! SignUpTeamName
            self.navigationController?.pushViewController(Instace, animated: true)
        }
        else{
            //Mail is already verify
             let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpCheckYourEmail") as! SignUpCheckYourEmail
             self.navigationController?.pushViewController(Instace, animated: true)
        }
    }
    
    func ApiResponceFailure(Failure: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)
        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")

    }
    
    //MARK: - NextScreenActionPerform
    func NextScreen()  {
        if TxtEmail.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter email", TextField: self.TxtEmail)
        }
        else if MyBaby.TextField.TextFieldIsValidEmail(TextFieldString: self.TxtEmail.text!) == false{
            //email is not correct
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter valid email", TextField: self.TxtEmail)
        }
        else{
            self.EMailVerificationLinkSend()
        }
        
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
