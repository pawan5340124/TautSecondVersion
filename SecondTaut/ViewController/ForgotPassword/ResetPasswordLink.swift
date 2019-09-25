//
//  ResetPasswordLink.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 27/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class ResetPasswordLink: UIViewController,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var btnSendMail: UIButton!
    @IBOutlet weak var ViewVewrificationLink: UIView!
    var TeamUrl : String = ""
    var Email : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
        ViewVewrificationLink.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func btnSendVerificationLink(_ sender: Any) {
        self.ForGotPasswordMagicLinkSend()

    }
    
    
    //MARK: - ApiHit
    func ForGotPasswordMagicLinkSend(){
        MyBaby.Loader.ButtonLoader(Button: self.btnSendMail, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)
        

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.MagicLinkSendForForgotPassword as NSString, HeaderParameter: ["Content-Type":"application/x-www-form-urlencoded"], BodyParameter: ["teamurl":TeamUrl,"email" : Email], ApiName: "CheckTeamExistOrNot", Log: true, Controller: self)
    }
    
    func ApiResponceSuccess(Success: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnSendMail, LoaderColour: UIColor.black, show: false)
        self.stopAnimating()
        let InstaceCreate = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordGetVerficationLink") as! ResetPasswordGetVerficationLink
        self.present(InstaceCreate, animated: true, completion: nil)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        MyBaby.Loader.ButtonLoader(Button: self.btnSendMail, LoaderColour: UIColor.black, show: false)
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
