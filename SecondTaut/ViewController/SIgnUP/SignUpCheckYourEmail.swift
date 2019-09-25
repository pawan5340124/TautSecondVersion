//
//  SignUpCheckYourEmail.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class SignUpCheckYourEmail: UIViewController,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnOpenEmail: UIButton!
    @IBOutlet weak var viewOpenEmail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUI()
        // Do any additional setup after loading the view.
    }
    
    func SetUI(){
        NotificationCenter.default.addObserver(self, selector: #selector(VerificationTokenGotForREgistration), name: NSNotification.Name(rawValue: "VerificationTokenGotForREgistration"), object: nil)
        self.viewOpenEmail.layer.cornerRadius = 6
    }
    
    
    @objc func VerificationTokenGotForREgistration(){
        if(UserDefaults.standard.value(forKey: "VerificationTokenGotForREgistration") != nil) {
            self.VerificationApiHit()
        }
    }
    
    @IBAction func btnOpenEmail(_ sender: Any) {
        self.LaunchEmailApp()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func VerificationApiHit(){
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: true)

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterUserToken as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "VerificationTokenGotForREgistration") as! String], BodyParameter: [:], ApiName: "RegisterUserTokenVerify", Log: true, Controller: self)
        
    }
    
    //MARK: - ApiResponceHandel
    func ApiResponceSuccess(Success: NSDictionary) {
        let VerifyTokenForRegistration = UserDefaults.standard.value(forKey: "VerificationTokenGotForREgistration") as! String
        UserDefaults.standard.set(VerifyTokenForRegistration, forKey: "CreateTeamToken")
        UserDefaults.standard.removeObject(forKey: "VerificationTokenGotForREgistration")
        UserDefaults.standard.synchronize()
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: false)
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpTeamName") as! SignUpTeamName
        self.navigationController?.pushViewController(Instace, animated: true)
    }
    
    func ApiResponceFailure(Failure: NSDictionary) {
        self.stopAnimating()
        MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: false)
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
