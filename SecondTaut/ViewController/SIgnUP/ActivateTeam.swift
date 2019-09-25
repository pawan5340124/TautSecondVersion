//
//  ActivateTeam.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class ActivateTeam: UIViewController,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnOpenEmail: UIButton!
    @IBOutlet weak var viewPopUP: UIView!
    @IBOutlet weak var ViewSignIn: UIView!
    @IBOutlet weak var ViewOpenEmailApp: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ViewSignIn.layer.cornerRadius = 6
        self.ViewOpenEmailApp.layer.cornerRadius = 6
        self.ViewSignIn.layer.borderWidth = 1
        self.ViewSignIn.layer.borderColor = UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1).cgColor
        
        self.viewPopUP.layer.cornerRadius = 20
        self.viewPopUP.layer.shadowColor = UIColor.black.cgColor
        self.viewPopUP.layer.shadowOpacity = 0.4
        self.viewPopUP.layer.shadowOffset = CGSize(width: +25, height: +25)
        self.viewPopUP.layer.shadowRadius = 20
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(verifyteamtoken), name: NSNotification.Name(rawValue: "verifyteamtoken"), object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    @objc func verifyteamtoken(){
        if(UserDefaults.standard.value(forKey: "verifyteamtoken") != nil) {
            self.VerificationApiHit()
        }
    }
    
    
    @IBAction func BtnSignIn(_ sender: Any) {
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.HomeRoot()
    }
    @IBAction func btnEmailApp(_ sender: Any) {
        self.LaunchEmailApp()

    }
    
    
    func VerificationApiHit(){
        MyBaby.Loader.ButtonLoader(Button: self.btnSignIn, LoaderColour: UIColor.black, show: true)
        MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)


        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterTeamActivate as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "verifyteamtoken") as! String,"Content-Type":"application/x-www-form-urlencoded"], BodyParameter: [:], ApiName: "RegisterUserTokenVerify", Log: true, Controller: self)
        
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        MyBaby.Alert.AlertAppear(Messaage: Success["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "OK", SecondButtonText: "")

        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            MyBaby.Loader.ButtonLoader(Button: self.btnSignIn, LoaderColour: UIColor.black, show: false)
            MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: false)
            self.stopAnimating()
//            let appobject = UIApplication.shared.delegate as! AppDelegate
//            appobject.HomeRoot()
            
        }

    }
    
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnSignIn, LoaderColour: UIColor.black, show: false)
        MyBaby.Loader.ButtonLoader(Button: self.btnOpenEmail, LoaderColour: UIColor.black, show: false)
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
