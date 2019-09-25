//
//  SignUpTeamName.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby

class SignUpTeamName: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewNextButton: UIView!
    @IBOutlet weak var txtTeamName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtTeamName.becomeFirstResponder()
    }
    
    func SetUi(){
        self.viewNextButton.layer.cornerRadius = 6
        MyBaby.TextField.TextFieldPlaceHolderColorChange(textField: self.txtTeamName, color: UIColor.black)
        
        
    }
    
    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NextScreen()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    //MARK: - Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any) {
        self.NextScreen()
    }
    
    
    func NextScreen(){
        if txtTeamName.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter team name", TextField: self.txtTeamName)
        }
        else{
            let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpTeamUrl") as! SignUpTeamUrl
            Instace.TeamName = self.txtTeamName.text!
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
