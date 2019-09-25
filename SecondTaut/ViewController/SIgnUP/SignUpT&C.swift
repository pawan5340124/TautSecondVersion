//
//  SignUpT&C.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby
import NVActivityIndicatorView

class SignUpT_C: UIViewController,ApiResponceDelegateMB,NVActivityIndicatorViewable {

    @IBOutlet weak var viewLastPopUP: UIView!
    @IBOutlet weak var viewPopUP: UIView!
    
    var Teamname : String = ""
    var TeamUrl : String = ""
    var Fullname : String = ""
    var Password : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewPopUP.layer.cornerRadius = 20
        self.viewLastPopUP.layer.cornerRadius = 20

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewPopUP.isHidden = false
        self.viewLastPopUP.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.viewPopUP.isHidden = true
        self.viewLastPopUP.isHidden = false
      

    }
    @IBAction func btnYesCancel(_ sender: Any) {
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.HomeRoot()
    }
    @IBAction func btnCancelSecondPopUP(_ sender: Any) {
        self.viewPopUP.isHidden = false
        self.viewLastPopUP.isHidden = true
    }
    
    @IBAction func btnNo(_ sender: Any) {
        self.viewPopUP.isHidden = false
        self.viewLastPopUP.isHidden = true
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnAgree(_ sender: Any) {
        
  
        self.CreateTEamAPiHit()
    }
    
    //MARK: - ApiHit
    func CreateTEamAPiHit(){
//        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: true)
        self.startAnimating(CGSize(width: 50, height:50), message: "", type: NVActivityIndicatorType.ballScaleRippleMultiple)

        MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.RegisterCreateTeam as NSString, HeaderParameter: ["token":UserDefaults.standard.value(forKey: "CreateTeamToken") as! String], BodyParameter: ["teamurl":TeamUrl,"teamname":Teamname,"name":Fullname,"password":Password], ApiName: "CreteTeam", Log: true, Controller: self)
        
    }
    
    
    func ApiResponceSuccess(Success: NSDictionary) {
//        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: false)
        self.stopAnimating()

        let iNstace = self.storyboard?.instantiateViewController(withIdentifier: "ActivateTeam") as! ActivateTeam
        self.present(iNstace, animated: true, completion: nil)
    }
    func ApiResponceFailure(Failure: NSDictionary) {
//        MyBaby.Loader.ButtonLoader(Button: self.btnSubmit, LoaderColour: UIColor.black, show: false)
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
