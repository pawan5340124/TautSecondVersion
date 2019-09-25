//
//  EmailSignIn.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class EmailSignIn: UIViewController,UITextFieldDelegate,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewBtnNext: UIView!
    var TeamURl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.SetUI()
        // Do any additional setup after loading the view.
    }
    
    
    func SetUI(){
        self.viewBtnNext.layer.cornerRadius = 6
        MyBaby.TextField.TextFieldPlaceHolderColorChange(textField: self.txtEmail, color: UIColor.black)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtEmail.becomeFirstResponder()
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
    @IBAction func btnNext(_ sender: Any) {
        self.NextScreen()
    }
    
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    //MARK: - NextScreenActionPerform
    func NextScreen()  {
        if txtEmail.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter email", TextField: self.txtEmail)
        }
        else if MyBaby.TextField.TextFieldIsValidEmail(TextFieldString: self.txtEmail.text!) == false{
            //email is not correct
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter valid email", TextField: self.txtEmail)
        }
        else{
            self.CheckTeamEmail()
//            let Instace = self.storyboard?.instantiateViewController(withIdentifier: "PasswordSignIn") as! PasswordSignIn
//            self.navigationController?.pushViewController(Instace, animated: true)
        }
        
    }
    
    //MARK:  - ApiCall
    func CheckTeamEmail(){
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterCheckTeamUrl as NSString, HeaderParameter: ["Content-Type":"application/x-www-form-urlencoded"], BodyParameter: ["teamurl":TeamURl,"email" : self.txtEmail.text!], ApiName: "CheckTeamExistOrNot", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
//        print(Success)
                    MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)
                    self.stopAnimating()
                    let Instace = self.storyboard?.instantiateViewController(withIdentifier: "PasswordSignIn") as! PasswordSignIn
                    Instace.TeamUrl = TeamURl
                    Instace.Email = self.txtEmail.text!
                    self.navigationController?.pushViewController(Instace, animated: true)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnNext, LoaderColour: UIColor.black, show: false)
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
