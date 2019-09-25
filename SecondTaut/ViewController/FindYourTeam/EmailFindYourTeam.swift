//
//  EmailFindYourTeam.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class EmailFindYourTeam: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,ApiResponceDelegateMB {

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
            self.FindTeamForThisEmail()

        }
        
    }
    
    //MARK:  - ApiCall
    func FindTeamForThisEmail(){
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)
        
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.FindWorkSpaceUsingEMail as NSString, HeaderParameter: ["Content-Type":"application/x-www-form-urlencoded"], BodyParameter: ["email":self.TxtEmail.text!], ApiName: "CheckTeamExistOrNot", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        self.stopAnimating()
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "CheckEmailFindYourTeam") as! CheckEmailFindYourTeam
        self.navigationController?.pushViewController(Instace, animated: true)
        
        
    }
    func ApiResponceFailure(Failure: NSDictionary) {
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
