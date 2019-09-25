//
//  Home.swift
//  PawanKumar
//
//  Created by Matrix Marketers on 30/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import SideMenu
import IQKeyboardManagerSwift
import MyBaby
import SocketIO


var Chatmessage : NSMutableArray = []

class Home: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UISideMenuNavigationControllerDelegate {

    //MARK: - Outlet
    @IBOutlet weak var con_bottomFooter: NSLayoutConstraint!
    @IBOutlet weak var con_FooterHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTextFiledMessage: UIView!
    @IBOutlet weak var ViewFooter: UIView!
    @IBOutlet weak var ViewGroupHeadLibne: UIView!
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var txtMessage: IQTextView!
    @IBOutlet weak var viewNavigationbar: UIView!
    @IBOutlet weak var con_ViewNavigationbar: NSLayoutConstraint!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var lblCompanyname: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    
    
    
    //MARK: - BaseFunction
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUI()
        self.SideMenuSet(Screen: self.view)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.GotChatData()
    }
    func SetUI(){
        
        self.ViewGroupHeadLibne.layer.shadowColor = UIColor.black.cgColor
        self.ViewGroupHeadLibne.layer.shadowOffset = CGSize(width: +2, height: 2)
        self.ViewGroupHeadLibne.layer.shadowRadius = 3
        self.ViewGroupHeadLibne.layer.shadowOpacity = 0.2
        
        
        self.ViewFooter.layer.masksToBounds = false
        self.ViewFooter.layer.shadowColor = UIColor.black.cgColor
        self.ViewFooter.layer.shadowOffset = CGSize(width: +2, height: -5)
        self.ViewFooter.layer.shadowRadius = 3
        self.ViewFooter.layer.shadowOpacity = 0.2
        
        self.viewTextFiledMessage.layer.cornerRadius = self.viewTextFiledMessage.layer.frame.height / 2
        self.txtMessage.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatGroupChangeBySideMenu), name: NSNotification.Name(rawValue: "SideMenuClick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Home.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Home.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewMessage), name: NSNotification.Name(rawValue: "NewMessageRecive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AfterApiHit), name: NSNotification.Name(rawValue: "AfterApiHit"), object: nil)


        
        tableViewChat.register(UINib.init(nibName: "AnotherUserChatTableViewCell", bundle: nil), forCellReuseIdentifier: "AnotherUserChatTableViewCell")
        tableViewChat.register(UINib.init(nibName: "MyChatTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatTableViewCell")
        tableViewChat.delegate = self
        tableViewChat.dataSource = self
        

    }
    
    //MARK: - SideMenu Controller Method
    func SideMenuSet(Screen : UIView){
        let StoryBoardrefrenceCreate : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        SideMenuManager.default.menuLeftNavigationController = StoryBoardrefrenceCreate.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = StoryBoardrefrenceCreate.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuWidth = Screen.layer.frame.width * 70 / 100
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.8088554739952087
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1)
        SideMenuManager.default.menuDismissWhenBackgrounded = true
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: (self.view)!)
        
    }
    
    

    //MARK: - Brodcast Reciver
    @objc func chatGroupChangeBySideMenu(){
      self.GotChatData()
    }
    @objc func NewMessage(){
        self.tableViewChat.reloadData()
        self.ReloadTableView()
    }
    @objc func AfterApiHit(){
        self.tableViewChat.reloadData()
        self.ReloadTableView()
    }

    func GotChatData(){
        Chatmessage.removeAllObjects()
        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
        let TEamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        lblGroupName.text = NewChatGroup["name"] as? String
        Chatmessage = NSMutableArray.init(array: MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TEamData["teamid"] as! String, TableName: NewChatGroup["_id"] as! String))
        self.tableViewChat.reloadData()
        self.ReloadTableView()
        NewFunctionCall.SocketGroupChange()
    }
    
    //MARK: - textviewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if con_FooterHeight.constant < 300{
            con_FooterHeight.constant = self.txtMessage.contentSize.height + 42
        }
        else if text == ""{
           if self.txtMessage.contentSize.height < 300{
                 con_FooterHeight.constant = self.txtMessage.contentSize.height + 42
            }
        }
        return true
        
    }
    
    //MARK:- KeyboardDelegate
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let rate = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let window = UIApplication.shared.keyWindow
                let bottomPadding = window?.safeAreaInsets.bottom
                con_bottomFooter.constant = keyboardHeight - bottomPadding!
                self.ReloadTableView()
            }
            UIView.animate(withDuration: rate as! TimeInterval) {
                self.view.updateConstraintsIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let rate = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
            con_bottomFooter.constant = 0
            UIView.animate(withDuration: rate as! TimeInterval) {
                self.view.updateConstraintsIfNeeded()
                self.view.layoutIfNeeded()
                self.ReloadTableView()
            }
        }
    }
    
    //MARK: - TableViewReloadFromDown
    func ReloadTableView(){
        if Chatmessage.count != 0{
            let when = DispatchTime.now() + 0.0
            DispatchQueue.main.asyncAfter(deadline: when)
            {
            self.tableViewChat.scrollToRow(at: NSIndexPath.init(row: Chatmessage.count - 1, section: 0) as IndexPath, at: .bottom, animated: false)
            }
            self.tableViewChat.scrollToRow(at: NSIndexPath.init(row: Chatmessage.count - 1, section: 0) as IndexPath, at: .bottom, animated: false)
            self.tableViewChat.scrollToRow(at: NSIndexPath.init(row: Chatmessage.count - 1, section: 0) as IndexPath, at: .bottom, animated: false)

        }
    }
    
    //MARK: - ButtonAction
    @IBAction func btnLeftSideMenu(_ sender: Any) {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnRIghtSideMenu(_ sender: Any) {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        
        
        let StaringWhiteSpaceRemove = MyBaby.String.StringStartingWhiteSpaceRemove(InputString: self.txtMessage.text!)
        let LastWhiteSpaceRemove = MyBaby.String.StringEndingWhiteSpaceRemove(InputString: StaringWhiteSpaceRemove)
        
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
        let Parameter = ["teamid":TeamData["teamid"] as! String,"sessiontoken":TeamData["SessionToken"] as! String,"chatgroupid":NewChatGroup["_id"] as! String,"messagetype":"text","content":LastWhiteSpaceRemove,"senderid":TeamData["userid"] as! String] as NSDictionary
        
        NewFunctionCall.SendMessage(Parameter: Parameter)
        self.txtMessage.text = ""
        con_FooterHeight.constant = self.txtMessage.contentSize.height + 42

    }
    
    //MARK: - SideMenudelegate

    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        self.ReloadTableView()

    }

    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chatmessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TEmpDIct = Chatmessage[indexPath.row] as! NSDictionary
        let LogINTeam = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary

        if TEmpDIct["from_id"] as! String == LogINTeam["userid"] as! String{
            let cell = self.tableViewChat.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.selectionStyle = .none
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.layer.frame.height / 2
            cell.imgProfile.clipsToBounds = true
            cell.viewMessageBoundry.layer.cornerRadius = 12
            cell.viewMessageBoundry.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.lblMessage.text = TEmpDIct["content"] as? String
            let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
            let Mydata = TeamData["Mydata"] as! NSDictionary
            cell.lblName.text = Mydata["name"] as? String
            cell.con_HeightThreadreply.constant = 0
            cell.ViewThreadReply.isHidden = true
            
            if MyBaby.String.StringContailSingleEmoji(InputString: cell.lblMessage.text!) == true{
                cell.lblMessage.font = cell.lblMessage.font.withSize(50)
            }else{
                cell.lblMessage.font = cell.lblMessage.font.withSize(15)
            }
            

            
            return cell
        }
        else{
            let cell = self.tableViewChat.dequeueReusableCell(withIdentifier: "AnotherUserChatTableViewCell", for: indexPath) as! AnotherUserChatTableViewCell
            
            cell.selectionStyle = .none
            cell.ImgProfile.layer.cornerRadius = cell.ImgProfile.layer.frame.height / 2
            cell.ImgProfile.clipsToBounds = true
            cell.viewMessageBoundry.layer.cornerRadius = 12
            cell.viewMessageBoundry.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
            cell.lblMessage.text = TEmpDIct["content"] as? String
            let MemberData = MemberListCustom[TEmpDIct["from_id"] as! String] as? NSDictionary
            cell.lblName.text = MemberData?["name"] as? String
            cell.con_heightThreadReply.constant = 0
            cell.viewThreadReply.isHidden = true
            
            if MyBaby.String.StringContailSingleEmoji(InputString: cell.lblMessage.text!) == true{
                cell.lblMessage.font = cell.lblMessage.font.withSize(50)
            }else{
                cell.lblMessage.font = cell.lblMessage.font.withSize(15)
            }
            
            return cell
        }


        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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


