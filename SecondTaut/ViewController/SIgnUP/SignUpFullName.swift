//
//  SignUpFullName.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby

class SignUpFullName: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewBtnNext: UIView!
    @IBOutlet weak var txtFullName: UITextField!
    var TeamName : String = ""
    var TeamUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.SetUi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtFullName.becomeFirstResponder()
        
    }
    
    func SetUi(){
        self.viewBtnNext.layer.cornerRadius = 6
        MyBaby.TextField.TextFieldPlaceHolderColorChange(textField: self.txtFullName, color: UIColor.black)
        
        
        
    }

    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NextScreen()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " && self.txtFullName.text == ""{
            return false
        }
        else if string == " " && self.txtFullName.text != ""{
            let lastChar = self.txtFullName.text?.last!
            if lastChar == " "{
                return false
            }

        }
        
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ "
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    //MARK: -ButtonAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any) {
        self.NextScreen()
    }
    
    func NextScreen(){
        if txtFullName.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter full name", TextField: self.txtFullName)
        }
        else{
            let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpPassword") as! SignUpPassword
            Instace.TeamUrl = self.TeamUrl
            Instace.TeamName = self.TeamName
            Instace.FullName = self.txtFullName.text!
            self.navigationController?.pushViewController(Instace, animated: true)
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
