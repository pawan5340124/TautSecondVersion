//
//  TeamList.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 30/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class TeamList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var tableViewTeamList: UITableView!
    @IBOutlet weak var viewTopBanner: UIView!
    @IBOutlet weak var conTableViewHeight: NSLayoutConstraint!
    var TeamListArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.SetUI()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnnext(_ sender: Any) {
        let appobject = UIApplication.shared.delegate as! AppDelegate
        appobject.HomeRoot()
    }
    
    func SetUI(){
        self.viewTopBanner.layer.shadowColor = UIColor.black.cgColor
        self.viewTopBanner.layer.shadowOpacity = 0.4
        self.viewTopBanner.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        tableViewTeamList.register(UINib.init(nibName: "TeamListTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamListTableViewCell")
        tableViewTeamList.delegate = self
        tableViewTeamList.dataSource = self
        tableViewTeamList.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewTeamList.dequeueReusableCell(withIdentifier: "TeamListTableViewCell") as! TeamListTableViewCell
        cell.selectionStyle = .none
        conTableViewHeight.constant = tableViewTeamList.contentSize.height + 10
        let TempData = TeamListArray[indexPath.row] as! NSDictionary
        cell.lblTeamName.text = (TempData["teamname"] as! String)
        cell.lblteamUrl.text = (TempData["teamurl"] as! String)
        
        return cell
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
