//
//  NewFunction.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 16/09/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import Foundation
import SQLite
import SocketIO
import MyBaby
import Alamofire
import Reachability
import BRYXBanner

let socket = SocketManager(socketURL: URL(string: ApiUrlCall.SocketbaseUrl)!, config: [.log(false), .compress])

let NewFunctionCall = NewFunction()
class NewFunction: NSObject {
    
    //MARK: - Reachability
    //MARK: - Internet reachability check
    let reachability = Reachability()!
    
    func NetworkObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("internet available by wifi")
            if socket.status == .disconnected{
                if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                    NewFunctionCall.SocketConnectAgain()
                    let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                    NewFunctionCall.AfterApiHit(LastTime: DateString)
                }}
        case .cellular:
            print("internet available by mobiledata")
            if socket.status == .disconnected{
                if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                    NewFunctionCall.SocketConnectAgain()
                    let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                    NewFunctionCall.AfterApiHit(LastTime: DateString)
                }}
        case .none:
            print("internet not working")
            socket.disconnect()
            let banner = Banner(title: "You are offline", subtitle: "Please check your internet connection", image: UIImage(named: "AppIcon"), backgroundColor: UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }

    //MARK: - GetIpAddress
    
    func getIFAddresses() -> String {
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "" }
        guard let firstAddr = ifaddr else { return "" }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        if address.count < 20{
                            
                            return address
                        }
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return ""
    }
    

    //MARK: - Socket Maintain
    
    //SOCKET FUNCITON FOR PROJECT
    func SocketStart(){
        self.ReciverSocker()
        self.checkSocketStatus()
    }
    func SocketStop(){
        socket.disconnect()
    }
    
    func SocketGroupChange(){
//        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
//        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
//        let Parameter = ["teamid":TeamData["teamid"] as! String,"sessiontoken":TeamData["SessionToken"] as! String,"chatgroupid":NewChatGroup["_id"] as! String,"messagetype":"text","content":"","senderid":TeamData["userid"] as! String] as NSDictionary
//        socket.emitAll("Start_Chat", Parameter)
    }
    
    func SocketConnectAgain(){
        self.checkSocketStatus()

    }
    
    func ReciverSocker(){
        socket.defaultSocket.on("jointheteam") { ( RawData, error) -> Void in
            _ = RawData[0] as? String
           // print(MainData as Any)
        }
        socket.defaultSocket.on("newmessage") { ( RawData, error) -> Void in
            let RawData = RawData[0] as? NSDictionary
            if let MainData : NSDictionary = RawData?["message"] as? NSDictionary{
                self.NewMesssageMaintain(MainData: MainData)
            }
            else if let TEmpData : NSDictionary = RawData?["groups"] as? NSDictionary{
              self.NewGroupCreateMaintain(TEmpData: TEmpData)
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuReset"), object: nil)
                let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
                let Para = ["chatgroupid":TEmpData["_id"] as! String,"sessiontoken":TeamData["SessionToken"] as! String]
                socket.emitAll("Start_Chat", Para)
            }
            else if let members : NSDictionary = RawData?["members"] as? NSDictionary{
                self.NewMemberMaintain(TEmpData: members)
            }
            
       
        }
    }
    func checkSocketStatus(){
        DispatchQueue.global(qos: .background).async {
            let socketConnectionStatus = socket.status
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                self.NowConnectionStablish()
            case SocketIOStatus.connecting:
                self.checkSocketStatus()
            case SocketIOStatus.disconnected:
                socket.connect()
                self.checkSocketStatus()
            case SocketIOStatus.notConnected:
                socket.connect()
                self.checkSocketStatus()
            }
        }
    }
    
    func NowConnectionStablish(){
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
        let Parameter = ["teamid":TeamData["teamid"] as! String,"sessiontoken":TeamData["SessionToken"] as! String,"chatgroupid":NewChatGroup["_id"] as! String,"messagetype":"text","content":"","senderid":TeamData["userid"] as! String] as NSDictionary
        socket.emitAll("subscribe_socket", Parameter)
        
        let ChannelListGot =  MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TeamData["teamid"] as! String, TableName: "ChannelList")
        let GroupListGot = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TeamData["teamid"] as! String, TableName: "GroupList")
        
        for Item in ChannelListGot{
            let Data = Item as! NSDictionary
            let Para = ["chatgroupid":Data["_id"] as! String,"sessiontoken":TeamData["SessionToken"] as! String]
            socket.emitAll("Start_Chat", Para)

        }
        for item in GroupListGot{
            let Data = item as! NSDictionary
            let Para = ["chatgroupid":Data["_id"] as! String,"sessiontoken":TeamData["SessionToken"] as! String]
            socket.emitAll("Start_Chat", Para)

        }
        
    }
    
    func SendMessage(Parameter : NSDictionary){
        
        if socket.status == .disconnected || socket.status == .notConnected || socket.status == .connecting{
            print("SOcket not connected")
            NewFunctionCall.SocketConnectAgain()
        }
        else{
            socket.emitAll("Send_Message", Parameter)
        }
        
    }
    
    func LeaveOldFroup(Parameter : NSDictionary){
        socket.emitAll("leaveChat", Parameter)
    }
    
    func NewGroupCreateMaintain(TEmpData : NSDictionary){
         let Type = TEmpData["type"] as! String
        
        //Save Time For nextMessage
        UserDefaults.standard.set(TEmpData["createdAt"] as! String, forKey: "LastTimeSave")
        UserDefaults.standard.synchronize()
        
         if Type == "channel"{
            let LogInTeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary

            let DIctionaryCreate = ["_id":TEmpData["_id"] as? String,"isPrivate":TEmpData["isPrivate"] as? String,"name":TEmpData["name"] as? String,"purpose":TEmpData["purpose"] as? String,"status":TEmpData["status"] as? String,"type":TEmpData["type"] as? String]
            _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: LogInTeamData["teamid"] as! String, TableName: "ChannelList", DataWantToSave: DIctionaryCreate as NSDictionary)
         }
        else{
            let LogInTeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
            let RawData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary

            let MemberListArray = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: RawData["teamid"] as! String, TableName: "MemberList")
            var NameCAlculate : String = ""
            for newItem in MemberListArray{
                let TempDataCreate = newItem as! NSDictionary
                let MEmberId = TempDataCreate["_id"] as! String
                let GroupMemberArray = TEmpData["members"] as! NSArray
                if Type != "group"{
                    NameCAlculate = TEmpData["name"] as! String
                }
                else if GroupMemberArray.contains(MEmberId) == true  {
                    if NameCAlculate == ""{
                        NameCAlculate = TempDataCreate["name"] as! String
                    }
                    else{
                        NameCAlculate = NameCAlculate + "," + String( TempDataCreate["name"] as! String)
                    }
                }
            }
            
            let MemberID : NSArray = TEmpData["members"] as! NSArray
            let AllMemberIds = MemberID.componentsJoined(by: ",")
           let DIctionaryCreate = ["_id":TEmpData["_id"] as? String ?? "","isPrivate":TEmpData["isPrivate"] as? String ?? "","name":NameCAlculate,"purpose":TEmpData["purpose"] as? String ?? "","status":TEmpData["status"] as? String ?? "","type":TEmpData["type"] as? String ?? "","MemberId":AllMemberIds]
          _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: LogInTeamData["teamid"] as! String, TableName: "GroupList", DataWantToSave: DIctionaryCreate as NSDictionary)
        }
    }
    func NewMemberMaintain(TEmpData : NSDictionary){
        UserDefaults.standard.set(TEmpData["createdAt"] as! String, forKey: "LastTimeSave")
        UserDefaults.standard.synchronize()
        let LogInTeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: LogInTeamData["teamid"] as! String, TableName: "MemberList", DataWantToSave: TEmpData)

        
    }
    
    
    func NewMesssageMaintain(MainData : NSDictionary){
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let NewChatGroup = UserDefaults.standard.value(forKey: "OpenGroupForChat") as! NSDictionary
        
        //Save Time For nextMessage
        UserDefaults.standard.set(MainData["createdAt"] as! String, forKey: "LastTimeSave")
        UserDefaults.standard.synchronize()

        
        if MainData["teamId"] as! String == TeamData["teamid"] as! String && MainData["chat_group_id"] as! String == NewChatGroup["_id"] as! String{
            Chatmessage.add(MainData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessageRecive"), object: nil)
        }else{
            //COunt Increase
            if(UserDefaults.standard.value(forKey: "CountManage") == nil) {
                let CountManage = ["teamID" : MainData["chat_group_id"] as! String,"Count" : "1"]
                let TeamKeygenrate = [MainData["chat_group_id"] as! String : CountManage]
                UserDefaults.standard.set(TeamKeygenrate, forKey: "CountManage")
                UserDefaults.standard.synchronize()
            }else{
                let countData : NSMutableDictionary = NSMutableDictionary.init(dictionary: UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary)
                if countData[MainData["chat_group_id"] as! String] != nil{
                    let GroupdataCount : NSMutableDictionary = NSMutableDictionary.init(dictionary: countData[MainData["chat_group_id"] as! String] as! NSDictionary)
                    let Count = GroupdataCount["Count"] as! String
                    let IncreaseCount = Int(Count)! + 1
                    GroupdataCount.setValue(String(IncreaseCount), forKey: "Count")
                    countData.removeObject(forKey: MainData["chat_group_id"] as! String)
                    countData.setValue(GroupdataCount, forKey: MainData["chat_group_id"] as! String)
                    UserDefaults.standard.set(countData, forKey: "CountManage")
                    UserDefaults.standard.synchronize()
                    
                }else{
                    let CountManage = ["teamID" : MainData["chat_group_id"] as! String,"Count" : "1"]
                    let AllDataGot : NSMutableDictionary = NSMutableDictionary.init(dictionary: UserDefaults.standard.value(forKey: "CountManage") as! NSDictionary)
                    AllDataGot.setValue(CountManage, forKey: MainData["chat_group_id"] as! String)
                    UserDefaults.standard.set(AllDataGot, forKey: "CountManage")
                    UserDefaults.standard.synchronize()
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuReset"), object: nil)

        }
        
        _ = MyBaby.MySqualDatabase.SaveValueInSqlite(DataBaseName: MainData["teamId"] as! String, TableName: MainData["chat_group_id"] as! String, DataWantToSave: MainData as NSDictionary)
    }
    
    //MARK: - AfterAPiMaintain
    func AfterApiHit(LastTime : String){
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let headerDict = ["sessiontoken" : TeamData["SessionToken"] as! String]
        let Body = ["time":LastTime,"teamid":TeamData["teamid"] as! String] as [String : Any]
        self.AfterApiCode(APiUrl: ApiUrlCall.BaseUrl + ApiUrlCall.AfterApi as NSString, HeaderParameter: headerDict, BodyParameter: Body as NSDictionary, ApiName: "After", Log: true)
    }
    
    private func AfterApiCode( APiUrl: NSString,HeaderParameter : [String: String] , BodyParameter: NSDictionary,ApiName : String,Log : Bool){
        
        var url = APiUrl
        url = url.replacingOccurrences(of: " ", with: "%20") as NSString
        URLCache.shared.removeAllCachedResponses()
        
        //Create a non-caching configuration.
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        
        Alamofire.request(url as String , method: .post, parameters: BodyParameter as? Parameters,headers:HeaderParameter).responseJSON { response in
            
            if Log == true{
                print("API NAME :-  \(ApiName)")
                print("API URL :-  \(APiUrl)")
                print("API HeaderParameter :-  \(HeaderParameter)")
                print("API BodyParameter :-  \(BodyParameter)")
                print("API Result :-  \(response)")
            }
            
            let InternetCheck = NetworkReachabilityManager()!.isReachable
            if InternetCheck == false{
                let JSON = ["message":"Please check internet connection.","ApiName":ApiName,"status":"001"]
                print(JSON)
                if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                    NewFunctionCall.SocketConnectAgain()
                    let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                    NewFunctionCall.AfterApiHit(LastTime: DateString)
                }
            }
            else{
                
                let statusCode = (response.response?.statusCode) ?? 0 //example : 200
                
                if statusCode == 200{
                    if let JSON = response.result.value {
                        let sessionExpireJson = JSON as! NSDictionary
                        let GetAllApiData : NSMutableDictionary = NSMutableDictionary.init(dictionary: sessionExpireJson)
                        GetAllApiData.setValue(ApiName, forKey: "ApiName")
                        self.AfterApiDataMaintain(Success: GetAllApiData)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AfterApiHit"), object: nil)
                    }
                    else{
                        let JSON = ["message":"Due to some reason error occur please try again","ApiName":ApiName,"status":"002"]
                        print(JSON)
                        if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                            NewFunctionCall.SocketConnectAgain()
                            let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                            NewFunctionCall.AfterApiHit(LastTime: DateString)
                        }
                    }
                }
                else{
                    if let JSON = response.result.value {
                        let sessionExpireJson = JSON as! NSDictionary
                        let GetAllApiData : NSMutableDictionary = NSMutableDictionary.init(dictionary: sessionExpireJson)
                        GetAllApiData.setValue(ApiName, forKey: "ApiName")
                        if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                            NewFunctionCall.SocketConnectAgain()
                            let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                            NewFunctionCall.AfterApiHit(LastTime: DateString)
                        }
                    }
                    else{
                        let JSON = ["message":"Due to some reason error occur please try again","ApiName":ApiName,"status":"002"]
                        print(JSON)
                        if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
                            NewFunctionCall.SocketConnectAgain()
                            let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
                            NewFunctionCall.AfterApiHit(LastTime: DateString)
                        }
                    }
                }
            }

        }
    }
    
    private func AfterApiDataMaintain(Success : NSDictionary){
        
        let RawData = Success["data"] as! NSDictionary
        let MessageList = RawData["messageslist"] as! NSArray
        let Groups = RawData["groups"] as! NSArray

        for message in MessageList {
            NewFunctionCall.NewMesssageMaintain(MainData: message as! NSDictionary)
        }
        
        for Group in Groups {
        self.NewGroupCreateMaintain(TEmpData: Group as! NSDictionary)
        }
        
        //Member Data manuplate
        let TeamData = UserDefaults.standard.value(forKey: "LogInTeamData") as! NSDictionary
        let MemberList = MyBaby.MySqualDatabase.GetValueFromSqlite(DataBaseName: TeamData["teamid"] as! String, TableName: "MemberList")
        MemberListCustom.removeAllObjects()
        for item in MemberList{
            let Data = item as! NSDictionary
            let ID = Data["_id"] as! String
            MemberListCustom.setValue(Data, forKey: ID)
        }

    }
}


