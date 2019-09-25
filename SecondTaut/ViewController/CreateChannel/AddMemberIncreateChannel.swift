//
//  AddMemberIncreateChannel.swift
//  Taut
//
//  Created by Matrix Marketers on 14/06/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout
import MyBaby

var SelectedArrayForCreatingChannel : NSMutableArray = []
var selectedIdContainForCreatingChannel : NSMutableArray = []
class AddMemberIncreateChannel: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
 
    //MARK: - Outlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var Con_CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var tableViewMain: UITableView!
    
    var MemberListArray : NSArray = []
    
    var SearchArray : NSMutableArray = []
    var TextFiled = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewMain.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        SelectedArrayForCreatingChannel.removeAllObjects()
        selectedIdContainForCreatingChannel.removeAllObjects()
        let nib = UINib(nibName: "CreatgeChannelCell", bundle: nil)
        collectionViewMain?.register(nib, forCellWithReuseIdentifier: "CreatgeChannelCell")
        collectionViewMain.delegate = self
        collectionViewMain.dataSource = self
         Con_CollectionViewHeight.constant = 1
        tableViewMain.register(UINib.init(nibName: "directMessageAddCell", bundle: nil), forCellReuseIdentifier: "directMessageAddCell")
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        let TEamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        MemberListArray = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TEamData["teamid"] as! String, TableName: "MemberList")

        
        TextFiled = ""
        self.txtSearch.text = ""
        // Do any additional setup after loading the view.
    }
    

    

    //MARK: - ButtonAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
 
    
    //MARK: - textFielddelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        SearchArray.removeAllObjects()
        
        if string == ""{
            TextFiled.removeLast()
        }
        else{
            let temp = self.txtSearch.text! + string
            TextFiled = temp.uppercased()
        }
        if TextFiled.count != 0{
            for i in 0..<MemberListArray.count {
                let getTempData = MemberListArray[i] as! NSDictionary
                let name = String( getTempData["name"] as! String).uppercased()
                if name.contains(TextFiled) {
                    SearchArray.add(getTempData)
                }
            }
            self.tableViewMain.reloadData()
        }
        else{
            self.tableViewMain.reloadData()
        }
        
        return true
    }
    
    
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.TextFiled == ""{
            return MemberListArray.count
        }
        else{
            return SearchArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewMain.dequeueReusableCell(withIdentifier: "directMessageAddCell", for: indexPath) as! directMessageAddCell
        cell.selectionStyle = .none
        
        if self.TextFiled == ""{

        
        let tempDict = MemberListArray[indexPath.row] as! NSDictionary
        let ID = tempDict["_id"] as! String
        
        if selectedIdContainForCreatingChannel.contains(ID) == true{
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
        }
        else{
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Ellipse 329"), for: .normal)

        }
        cell.lblName.text = tempDict["name"] as? String
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.layer.frame.height / 2

        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        }
        else{
            let tempDict = SearchArray[indexPath.row] as! NSDictionary
            let ID = tempDict["_id"] as! String
            
            if selectedIdContainForCreatingChannel.contains(ID) == true{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)

            }
            else{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Ellipse 329"), for: .normal)

            }
            cell.lblName.text = tempDict["name"] as? String
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.layer.frame.height / 2
            
            cell.btnCheckBox.tag = indexPath.row
            cell.btnCheckBox.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
            
            
        self.tableViewMain.tableFooterView = UIView()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.TextFiled == ""{

        
        let tempDict = MemberListArray[indexPath.row] as! NSDictionary
        let ID = tempDict["_id"] as! String
        if selectedIdContainForCreatingChannel.contains(ID) == true{
            selectedIdContainForCreatingChannel.remove(ID)
            SelectedArrayForCreatingChannel.remove(tempDict)
        }else{
            selectedIdContainForCreatingChannel.add(ID)
            SelectedArrayForCreatingChannel.add(tempDict)
        }
        
        Con_CollectionViewHeight.constant = 1
        tableViewMain.reloadData()
        collectionViewMain.reloadData()
            
        }
        else{
            let tempDict = SearchArray[indexPath.row] as! NSDictionary
            let ID = tempDict["_id"] as! String
            if selectedIdContainForCreatingChannel.contains(ID) == true{
                selectedIdContainForCreatingChannel.remove(ID)
                SelectedArrayForCreatingChannel.remove(tempDict)
            }else{
                selectedIdContainForCreatingChannel.add(ID)
                SelectedArrayForCreatingChannel.add(tempDict)
            }
            
            Con_CollectionViewHeight.constant = 1
            tableViewMain.reloadData()
            collectionViewMain.reloadData()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        if self.TextFiled == ""{

        
        let tempDict = MemberListArray[sender.tag] as! NSDictionary
        let ID = tempDict["_id"] as! String
        if selectedIdContainForCreatingChannel.contains(ID) == true{
            selectedIdContainForCreatingChannel.remove(ID)
            SelectedArrayForCreatingChannel.remove(tempDict)
        }else{
            selectedIdContainForCreatingChannel.add(ID)
            SelectedArrayForCreatingChannel.add(tempDict)
        }
        
         Con_CollectionViewHeight.constant = 1
        tableViewMain.reloadData()
        collectionViewMain.reloadData()
        }
        else{
            let tempDict = SearchArray[sender.tag] as! NSDictionary
            let ID = tempDict["_id"] as! String
            if selectedIdContainForCreatingChannel.contains(ID) == true{
                selectedIdContainForCreatingChannel.remove(ID)
                SelectedArrayForCreatingChannel.remove(tempDict)
            }else{
                selectedIdContainForCreatingChannel.add(ID)
                SelectedArrayForCreatingChannel.add(tempDict)
            }
            
            Con_CollectionViewHeight.constant = 1
            tableViewMain.reloadData()
            collectionViewMain.reloadData()
        }
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectedArrayForCreatingChannel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "CreatgeChannelCell", for: indexPath) as! CreatgeChannelCell
        
        let TempDict = SelectedArrayForCreatingChannel[indexPath.row] as! NSDictionary
        cell.viewMain.layer.cornerRadius = 20
        cell.lbltitle.text = TempDict["name"] as? String
        Con_CollectionViewHeight.constant = self.collectionViewMain.contentSize.height + 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let TempDict = SelectedArrayForCreatingChannel[indexPath.row] as! NSDictionary
        let label = UILabel(frame: CGRect.zero)
        label.text = TempDict["name"] as? String
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 40)
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
