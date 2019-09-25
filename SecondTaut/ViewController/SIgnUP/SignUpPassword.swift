//
//  SignUpPassword.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby

class SignUpPassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewBtnNext: UIView!
    @IBOutlet weak var btnPasswordVisible: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    var TeamName : String = ""
    var TeamUrl : String = ""
    var FullName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtPassword.becomeFirstResponder()
        self.SetUi()
    }
    
    func SetUi()  {
        self.viewBtnNext.layer.cornerRadius = 6
        self.btnPasswordVisible.setImage(UIImage.init(named: "view"), for: .normal)
        self.txtPassword.isSecureTextEntry = true
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
    
    //MARK: - ButtonAction
    @IBAction func BtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubm(_ sender: Any) {
        self.NextScreen()
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
    
    
    func NextScreen(){
        if txtPassword.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter password", TextField: self.txtPassword)
        }
        else if self.txtPassword.text!.count < 6{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter atleast 6 character", TextField: self.txtPassword)
        }
        else{
            let INstace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpT_C") as! SignUpT_C
            INstace.modalPresentationStyle = .overCurrentContext
            INstace.Teamname = TeamName
            INstace.TeamUrl = TeamUrl
            INstace.Fullname = FullName
            INstace.Password = self.txtPassword.text!
            self.present(INstace, animated: false, completion: nil)
            

            
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
