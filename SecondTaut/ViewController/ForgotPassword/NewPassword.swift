//
//  NewPassword.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class NewPassword: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnresetPassword: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var viewUpdatePassword: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtNewPassword.becomeFirstResponder()
        self.SetUi()
    }
    
    func SetUi()  {
        viewUpdatePassword.layer.cornerRadius = 6
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
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUpdatePassword(_ sender: Any) {
        self.NextScreen()
    }
    
    
    
    func NextScreen(){
        if txtNewPassword.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter password", TextField: self.txtNewPassword)
        }
        else  if txtConfirmPassword.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter Confirm password", TextField: self.txtConfirmPassword)
        }
        else if txtNewPassword.text! != self.txtConfirmPassword.text!{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Confirm password not match", TextField: self.txtConfirmPassword)

        }
        else if self.txtNewPassword.text!.count < 6{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter atleast 6 character", TextField: self.txtNewPassword)
        }
        else{
            self.PasswordReeset()
//            let INstace = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeSuccessFully") as! PasswordChangeSuccessFully
//            self.present(INstace, animated: false, completion: nil)
            
        }
    }
    
    //MARK : - ApiHit
    func PasswordReeset(){
        MyBaby.Loader.ButtonLoader(Button: self.btnresetPassword, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.ResetPassword as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "TokenForResetPasswrod") as! String,"Content-Type":"application/x-www-form-urlencoded"], BodyParameter: ["new_password": self.txtNewPassword.text!,"confirm_password":self.txtConfirmPassword.text!], ApiName: "CheckTeamExistOrNot", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnresetPassword, LoaderColour: UIColor.black, show: false)
        let INstace = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeSuccessFully") as! PasswordChangeSuccessFully
        self.present(INstace, animated: false, completion: nil)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnresetPassword, LoaderColour: UIColor.black, show: false)
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
