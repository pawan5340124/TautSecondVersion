//
//  CheckEmailFindYourTeam.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class CheckEmailFindYourTeam: UIViewController,NVActivityIndicatorViewable,ApiResponceDelegateMB {

    @IBOutlet weak var viewOpenEmail: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewOpenEmail.layer.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyForgotPasswordToken), name: NSNotification.Name(rawValue: "yourteamsToken"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func VerifyForgotPasswordToken(){
        if(UserDefaults.standard.value(forKey: "yourteamsToken") != nil) {
            self.yourteamsToken()
        }
    } 
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenEmailApp(_ sender: Any) {
        self.LaunchEmailApp()
//        let appobject = UIApplication.shared.delegate as! AppDelegate
//        appobject.HomeRoot()
    }
    
    //MARK: - APiHit
    func yourteamsToken(){
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)
        
        
        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.FindWorkSpaceTokenVerify as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "yourteamsToken") as! String], BodyParameter: [:], ApiName: "yourteamsToken", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        
        self.stopAnimating()
        UserDefaults.standard.removeObject(forKey: "yourteamsToken")
        UserDefaults.standard.synchronize()
        let InstaceCreate = self.storyboard?.instantiateViewController(withIdentifier: "TeamList") as! TeamList
        InstaceCreate.TeamListArray = Success["data"] as! NSArray
        self.present(InstaceCreate, animated: true, completion: nil)
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
