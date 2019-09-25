//
//  ResetPasswordGetVerficationLink.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class ResetPasswordGetVerficationLink: UIViewController,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnOPenEmail: UIButton!
    @IBOutlet weak var ViewOPenEmailApp: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewOPenEmailApp.layer.cornerRadius = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyForgotPasswordToken), name: NSNotification.Name(rawValue: "VerifyForgotPasswordToken"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func VerifyForgotPasswordToken(){
        if(UserDefaults.standard.value(forKey: "VerifyForgotPasswordToken") != nil) {
            self.ForGotPasswordMagicLinkVerify()
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func btnOpenEmail(_ sender: Any) {
       self.LaunchEmailApp()
    }
    
    //MARK: - APiHit
    func ForGotPasswordMagicLinkVerify(){
        MyBaby.Loader.ButtonLoader(Button: self.btnOPenEmail, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.MagicLinkVerifyForForgotPassword as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "VerifyForgotPasswordToken") as! String], BodyParameter: [:], ApiName: "VerifyForgotPasswordToken", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
       
        MyBaby.Loader.ButtonLoader(Button: self.btnOPenEmail, LoaderColour: UIColor.black, show: false)
        self.stopAnimating()
        UserDefaults.standard.set(Success["teamtoken"] as! String, forKey: "TokenForResetPasswrod")
        UserDefaults.standard.removeObject(forKey: "VerifyForgotPasswordToken")
        UserDefaults.standard.synchronize()
        let InstaceCreate = self.storyboard?.instantiateViewController(withIdentifier: "NewPassword") as! NewPassword
        self.present(InstaceCreate, animated: true, completion: nil)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnOPenEmail, LoaderColour: UIColor.black, show: false)
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
