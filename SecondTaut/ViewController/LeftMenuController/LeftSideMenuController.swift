//
//  LeftSideMenuController.swift
//  PawanKumar
//
//  Created by Matrix Marketers on 30/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby

class LeftSideMenuController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK: - Outlet
    @IBOutlet weak var tableViewHOme: UITableView!
    var MainArraySideMenuHOme  : NSMutableArray = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewHOme.register(UINib.init(nibName: "headerTableViewCell", bundle: nil), forCellReuseIdentifier: "headerTableViewCell")
        tableViewHOme.register(UINib.init(nibName: "BoadyTableViewCell", bundle: nil), forCellReuseIdentifier: "BoadyTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(SideMenuReset), name: NSNotification.Name(rawValue: "SideMenuReset"), object: nil)

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.DataReset()
    }
    
    @objc func SideMenuReset(){
        self.DataReset()

    }
    
    
    func DataReset(){
        


        
        MainArraySideMenuHOme.removeAllObjects()
        let TEamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let ChannelListGot =  MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TEamData["teamid"] as! String, TableName: "ChannelList")
        let GroupListGot = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TEamData["teamid"] as! String, TableName: "GroupList")
        
        
        let Channel : NSMutableArray = []
        let DirectMessage : NSMutableArray = []
        let UnreadMessage : NSMutableArray = []
        let staredItem : NSMutableArray = []
        
        for item in ChannelListGot{
            let Data = item as! NSDictionary
            if(UserDefaults.standard.value(forKey: "CountManage") != nil) {
                let countData = UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary
                if countData[Data["_id"] as! String] != nil{
                    //count present
                   UnreadMessage.add(item as! NSDictionary)
                }
                else{
                    Channel.add(item as! NSDictionary)
                }
            }else{
                //count not exist so
                Channel.add(item as! NSDictionary)
            }
        }
        for item in GroupListGot{
            let Data = item as! NSDictionary
            let FinalDataCount : NSMutableDictionary = NSMutableDictionary.init(dictionary: Data)
            if Data["type"] as! String != "individual"{
               let Name = GetGroupName(TEmpData: Data)
               FinalDataCount.setValue(Name, forKey: "name")
            }
            
            
            let OpenChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
            if(UserDefaults.standard.value(forKey: "CountManage") != nil)  && Data["_id"] as! String != OpenChatGroup["_id"] as! String{
                let countData = UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary
                if countData[Data["_id"] as! String] != nil{
                    //count present
                    UnreadMessage.add(FinalDataCount as NSDictionary)
                }
                else{
                    DirectMessage.add(FinalDataCount as NSDictionary)
                }
            }else{
                //count not exist so
                DirectMessage.add(FinalDataCount as NSDictionary)
            }
        }
        
        
        
       
        let TempDict4 = ["Header":"STARRED ITEMS","Category":staredItem] as [String : Any]
        MainArraySideMenuHOme.add(TempDict4)
        let TempDict1 = ["Header":"UNREADS","Category":UnreadMessage] as [String : Any]
        MainArraySideMenuHOme.add(TempDict1)
        let TempDict2 = ["Header":"CHANNELS","Category":Channel] as [String : Any]
        MainArraySideMenuHOme.add(TempDict2)
        let TempDict3 = ["Header":"DIRECT MESSAGES","Category":DirectMessage] as [String : Any]
        MainArraySideMenuHOme.add(TempDict3)
        
        
        tableViewHOme.delegate = self
        tableViewHOme.dataSource = self
        tableViewHOme.reloadData()
        
        
    }
    
    func GetGroupName(TEmpData : NSDictionary) -> String{
        let RawData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let MemberListArray = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "MemberList")
        var NameCAlculate : String = ""
        for newItem in MemberListArray{
            let TempDataCreate = newItem as! NSDictionary
            let MEmberId = TempDataCreate["_id"] as! String
            let MemberIDs = TEmpData["MemberId"] as! String
            let GroupMemberArray = MemberIDs.components(separatedBy: ",") as NSArray
            if GroupMemberArray.contains(MEmberId) == true && MEmberId != RawData["userid"] as! String{
                if NameCAlculate == ""{
                    NameCAlculate = TempDataCreate["name"] as! String
                }
                else{
                    NameCAlculate = NameCAlculate + "," + String( TempDataCreate["name"] as! String)
                }
            }else{
                print("this member not present in this group")
            }
        }
        return NameCAlculate
    }
    

    @IBAction func btnnavigation(_ sender: Any) {
//         let menu = storyboard!.instantiateViewController(withIdentifier: "LogOut") as! LogOut
//         self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @IBAction func btnHideSideMenu(_ sender: Any) {
    
    }
    
    @IBAction func btnSubMenu(_ sender: Any) {

    
    }
    
    //MARK: -TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainArraySideMenuHOme.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.layer.frame.size.height * 7 / 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableViewHOme.dequeueReusableCell(withIdentifier: "headerTableViewCell") as! headerTableViewCell
        cell.viewMain.layer.masksToBounds = false
        cell.viewMain.layer.shadowColor = UIColor.black.cgColor
        cell.viewMain.layer.shadowOpacity = 0.10
        cell.viewMain.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.viewMain.layer.shadowRadius = 2
        let TempDict = MainArraySideMenuHOme.object(at: section) as! NSDictionary
        cell.lblTitle.text = TempDict["Header"] as? String
        cell.btnAdd.isHidden = false
        if TempDict["Header"] as! String == "STARRED ITEMS" || TempDict["Header"] as! String == "UNREADS"{
            cell.btnAdd.isHidden = true
        }

        cell.btnAdd.tag = section
        cell.btnAdd.addTarget(self, action: #selector(HeaderAddButtonCLick), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let TempDict = MainArraySideMenuHOme.object(at: section) as! NSDictionary
        let CategoryUnderHeader = TempDict.value(forKey: "Category") as! NSArray
        return CategoryUnderHeader.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.layer.frame.size.height * 5 / 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewHOme.dequeueReusableCell(withIdentifier: "BoadyTableViewCell", for: indexPath) as! BoadyTableViewCell
        cell.selectionStyle = .none
        let TempDataGot = MainArraySideMenuHOme[indexPath.section] as! NSDictionary
        let ArrayGot = TempDataGot["Category"] as! NSArray
        let DataGot = ArrayGot[indexPath.row] as! NSDictionary
        cell.lblTitle.text = DataGot["name"] as? String
        cell.LBLCOUNT.layer.cornerRadius = cell.LBLCOUNT.layer.frame.height / 2
        cell.LBLCOUNT.clipsToBounds = true
        let GroupId = DataGot["_id"] as! String
        if(UserDefaults.standard.value(forKey: "CountManage") != nil) {
            let countData : NSMutableDictionary = NSMutableDictionary.init(dictionary: UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary)
            let OpenChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
            if countData[GroupId] != nil  {
                if GroupId != OpenChatGroup["_id"] as! String{
                //count present
                   let CountGot = countData[GroupId] as! NSDictionary
                  cell.LBLCOUNT.text = CountGot["Count"] as? String
                  cell.LBLCOUNT.isHidden = false
                }else{
                    countData.removeObject(forKey: GroupId)
                    UserDefaults.standard.set(countData, forKey: "CountManage")
                    UserDefaults.standard.synchronize()
                    cell.LBLCOUNT.isHidden = true
                }
            }
            else{
                cell.LBLCOUNT.isHidden = true
            }
        }
        else{
           cell.LBLCOUNT.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Leave Old chat group
        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
        let _ : NSDictionary = ["chatgroupid": NewChatGroup["_id"] as! String]
   //     NewFunctionCall.LeaveOldFroup(Parameter: TempDict)
        
        //JoinChatGroup
        let TempDataGot = MainArraySideMenuHOme[indexPath.section] as! NSDictionary
        let Category = TempDataGot["Category"] as! NSArray
        let SelectedDirectMessagegot = Category[indexPath.row] as! NSDictionary
        let GroupId = SelectedDirectMessagegot["_id"] as! String
        UserDefaults.standard.set(SelectedDirectMessagegot, forKey: "OpenGroupForChat")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuClick"), object: nil)
        
        //Remove Count if available
        if(UserDefaults.standard.value(forKey: "CountManage") != nil) {
            let countData : NSMutableDictionary = NSMutableDictionary.init(dictionary: UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary)
            if countData[GroupId] != nil{
                //count present
                countData.removeObject(forKey: GroupId)
                UserDefaults.standard.set(countData, forKey: "CountManage")
                UserDefaults.standard.synchronize()
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func HeaderAddButtonCLick(sender: UIButton!) {

        print(sender.tag)
        if sender.tag == 2{
            // add channel
            
            let menu = storyboard!.instantiateViewController(withIdentifier: "CreateChannelViewController") as! CreateChannelViewController
            self.navigationController?.pushViewController(menu, animated: false)
        }
        else if sender.tag == 3{
            // add Direct Message
            let menu = storyboard!.instantiateViewController(withIdentifier: "AddDirectMessage") as! AddDirectMessage
            self.navigationController?.pushViewController(menu, animated: false)
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
