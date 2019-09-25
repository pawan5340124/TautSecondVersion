//
//  CreateChannelViewController.swift
//  Taut
//
//  Created by Matrix Marketers on 14/06/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DGCollectionViewLeftAlignFlowLayout
import MyBaby

class CreateChannelViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiResponceDelegateMB,NVActivityIndicatorViewable,UITextFieldDelegate {


    //MARK: - ColelctionView
    @IBOutlet weak var txtPurpose: UITextField!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var con_heightCollectionview: NSLayoutConstraint!
    @IBOutlet weak var con_HeightCollectionViewBaseView: NSLayoutConstraint!
    @IBOutlet weak var btnSwitch: UISwitch!
    var PrivateChannel : String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.MainCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()

        let nib = UINib(nibName: "CreatgeChannelCell", bundle: nil)
        MainCollectionView?.register(nib, forCellWithReuseIdentifier: "CreatgeChannelCell")
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        MainCollectionView.reloadData()

    }
    

    //MARK: - ButtonAction
    @IBAction func btnSwitchPrivacy(_ sender: Any) {
        if btnSwitch.isOn == true{
            PrivateChannel = "0"
        }
        else{
            PrivateChannel = "1"
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddMember(_ sender: Any) {
        

        let InstanceCreate = self.storyboard?.instantiateViewController(withIdentifier: "AddMemberIncreateChannel") as! AddMemberIncreateChannel
        self.present(InstanceCreate, animated: true, completion: nil)
    }
    @IBAction func btnCreate(_ sender: Any) {

        self.txtFirstname.text = MyBaby.String.StringMultipleLineWhiteSpaceRemove(InputString: self.txtFirstname.text!)
        self.txtPurpose.text = MyBaby.String.StringMultipleLineWhiteSpaceRemove(InputString: self.txtPurpose.text!)


        if self.txtFirstname.text == ""{
            
            MyBaby.Alert.AlertAppear(Messaage: "Please enter group name", Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")
        }
         else if selectedIdContainForCreatingChannel.count == 0{
            MyBaby.Alert.AlertAppear(Messaage: "Please add group member", Title: "", View: self, Button: true, SingleButton: true, FirstButtonText: "OK", SecondButtonText: "")
        }
        else{
            
            self.txtPurpose.resignFirstResponder()
            self.txtFirstname.resignFirstResponder()
            self.startAnimating(CGSize(width: 50, height:50), type: NVActivityIndicatorType.lineSpinFadeLoader, color: UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1), backgroundColor: UIColor.clear)

            let teamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
            selectedIdContainForCreatingChannel.add(teamData["userid"] as! String)
            let IdValueSelected = selectedIdContainForCreatingChannel.componentsJoined(by: ",")
            let headerDict : NSDictionary = ["sessiontoken":teamData["SessionToken"] as! String]
            let Body : NSDictionary = ["name":self.txtFirstname.text!,"teamid":teamData["teamid"] as! String,"memberids":IdValueSelected,"privacy":"0"]
            MyBaby.ApiCall.ApiHitUsingPostMethod(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.CreateGroup as NSString, HeaderParameter: headerDict as! [String : String], BodyParameter: Body, ApiName: "Create Group", Log: true, Controller: self)
            

        }
        
        
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectedArrayForCreatingChannel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: "CreatgeChannelCell", for: indexPath) as! CreatgeChannelCell
    
        cell.viewMain.layer.cornerRadius = 20
        let TempDict = SelectedArrayForCreatingChannel[indexPath.row] as! NSDictionary
        cell.lbltitle.text = TempDict["name"] as? String
        
        con_heightCollectionview.constant = self.MainCollectionView.contentSize.height
        con_HeightCollectionViewBaseView.constant = self.MainCollectionView.contentSize.height + 67
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        let TempDict = SelectedArrayForCreatingChannel[indexPath.row] as! NSDictionary
        label.text = TempDict["name"] as? String
        label.sizeToFit()
       return CGSize(width: label.frame.width + 24, height: 40)
    }
    
  
    

    //MARK: - APiResponceDelegate
    func ApiResponceSuccess(Success: NSDictionary) {
       print(Success)
        let TEmpData = Success["data"] as! NSDictionary
        let DIctionaryCreate = ["_id":TEmpData["_id"] as? String ?? "","isPrivate":TEmpData["isPrivate"] as? String ?? "","name":TEmpData["name"] as? String ?? "","purpose":TEmpData["purpose"] as? String ?? "","status":TEmpData["status"] as? String ?? "","type":TEmpData["type"] as? String ?? ""]
        UserDefaults.standard.set(DIctionaryCreate, forKey: "OpenGroupForChat")
        
        self.navigationController?.popViewController(animated: true)
        self.stopAnimating()

     self.navigationController?.popViewController(animated: true)
       
    }
    func ApiResponceFailure(Failure: NSDictionary) {
        self.stopAnimating()

        MyBaby.Alert.AlertAppear(Messaage: Failure["message"] as! String, Title: "", View: self, Button: false, SingleButton: false, FirstButtonText: "", SecondButtonText: "")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtPurpose.resignFirstResponder()
        self.txtFirstname.resignFirstResponder()
        
        return true
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
