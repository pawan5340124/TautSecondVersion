//
//  JinWorkSPaceName.swift
//  Taut
//
//  Created by Matrix Marketers on 01/07/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class JinWorkSPaceName: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,ApiResponceDelegateMB {

    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var ViewFullName: UIView!
    @IBOutlet weak var txtname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           btnView.layer.cornerRadius = 6
    }
    
    @IBAction func btnback(_ sender: Any) {
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.HomeRoot()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
         self.Forword()
    }
    
    func Forword(){
        self.txtname.text = MyBaby.String.StringStartingWhiteSpaceRemove(InputString: self.txtname.text!)
        self.txtname.text = MyBaby.String.StringEndingWhiteSpaceRemove(InputString: self.txtname.text!)
        
        self.txtname.text = MyBaby.String.StringMultipleLineWhiteSpaceRemove(InputString: self.txtname.text!)
        if self.txtname.text == ""{
            MyBaby.Alert.AlertForTextFieldAppear(Message: "Please enter full name", TextField: self.txtname)
            
        }
        else{
            self.InvitationTokenVerify()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.Forword()
        return true
    }
    
    //MARK: - APiHIt
    func InvitationTokenVerify(){
        self.startAnimating(CGSize(width: 50, height:50), type: NVActivityIndicatorType.lineSpinFadeLoader, color: UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1), backgroundColor: UIColor.clear)
        let VerifyToken = UserDefaults.standard.value(forKey: "AcceptInvitationToken") as! String
        let HeaderDict = ["token":VerifyToken]
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.InvitationTokenVerify as NSString, HeaderParameter: HeaderDict, BodyParameter: [:], ApiName: "VerifyToken", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        print(Success)
        self.stopAnimating()
        let Instance = self.storyboard?.instantiateViewController(withIdentifier: "JoinWorkSpacePassword") as! JoinWorkSpacePassword
        Instance.FullName = self.txtname.text!
        Instance.TeamData = Success
        self.navigationController?.pushViewController(Instance, animated: true)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        self.stopAnimating()
        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "", SecondButtonText: "")    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
