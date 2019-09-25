//
//  LocalDatabaseManage.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 13/09/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import Foundation
import SQLite

 let DatabaseManage      =    LocalDatabaseManage()

public class LocalDatabaseManage{

    

    
    
    
    var Localdatabase: Connection!
    
    let _id = Expression<String?>("_id")
    let chat_group_id = Expression<String>("chat_group_id")
    let content = Expression<String>("content")
    let createdAt = Expression<String>("createdAt")
    let from_id = Expression<String>("from_id")
    let is_deleted = Expression<String>("is_deleted")
    let is_edited = Expression<String>("is_edited")
    let message_type = Expression<String>("message_type")
    let parent_id = Expression<String>("parent_id")
    let pinned = Expression<String>("pinned")
    let read_by = Expression<String>("read_by")
    let starred = Expression<String>("starred")
    let teamId = Expression<String>("teamId")
    let updatedAt = Expression<String>("updatedAt")

    

    
    func StartSqlite(){
        
         //sqliteConenct
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            Localdatabase = database
            
        } catch {
            // print(error)
            
        }
        
    }
    
    func CreateTable(TableName : String){
        
        //Create Table if available already then get Value
        let usersTableForNow = Table(TableName)
        
        let createTable = usersTableForNow.create { (table) in
            table.column(_id)
            table.column(chat_group_id)
            table.column(content)
            table.column(createdAt)
            table.column(from_id)
            table.column(is_deleted)
            table.column(is_edited)
            table.column(message_type)
            table.column(parent_id)
            table.column(pinned)
            table.column(read_by)
            table.column(starred)
            table.column(teamId)
            table.column(updatedAt)

        }
        
        do {
            try Localdatabase.run(createTable)
              print("Created Table")
        } catch {
            print(error)
        }
        
    }
    

    

    
    func DeleteValueInSqlite(){
        
        let ActiveChat = UserDefaults.standard.value(forKey: "LastActiveSideMenuChat") as! NSDictionary
        let usersTableForNow = Table(ActiveChat["_id"] as! String)
        let user = usersTableForNow
        let deleteUser = user.delete()
        do {
            try Localdatabase.run(deleteUser)
        } catch {
            //   print(error)
        }
        
    }

    
    
    func AddValueInSqliteLocalDataBase(MessageArray : NSArray) {
        
        for message in MessageArray{
            

            let ExactData = message as! NSDictionary
            let usersTableForNow = Table(ExactData["chat_group_id"] as! String)
            self.CreateTable(TableName: ExactData["chat_group_id"] as! String)

            
            let insertUser = usersTableForNow.insert(_id <- ExactData["_id"] as? String, chat_group_id <- ExactData["chat_group_id"] as? String ?? "",content <- ExactData["content"] as? String ?? "",createdAt <- ExactData["createdAt"] as? String ?? "",from_id <- ExactData["from_id"] as? String ?? "",is_deleted <- ExactData["is_deleted"] as? String ?? "",is_edited <- ExactData["is_edited"] as? String ?? "",message_type <- ExactData["message_type"] as? String ?? "text",parent_id <- ExactData["parent_id"] as? String ?? "",pinned <- ExactData["pinned"] as? String ?? "",read_by <- ExactData["read_by"] as? String ?? "",starred <- ExactData["starred"] as? String ?? "",teamId <- ExactData["teamId"] as? String ?? "",updatedAt <- ExactData["updatedAt"] as? String ?? "")
            
            
            do {
                try Localdatabase.run(insertUser)
                  print("INSERTED USER")
                
            } catch {
                 print(error)
            }
            
        }
    }
    
    

    
    
    func GetlocalDataBaseTableValue(TableName : String){
        
        do {
            print(TableName)
            let usersTableForNow = Table(TableName)
            let users = try Localdatabase.prepare(usersTableForNow)
            
            let TryMainArray : NSMutableArray = []
            for user in users {
                // print(user)
                let tempDict1 = ["_id": user[_id] as Any,"chat_group_id": user[chat_group_id],"content": user[content],"createdAt": user[createdAt],"from_id":user[from_id],"is_deleted":user[is_deleted],"is_edited":user[is_edited],"message_type":user[message_type],"parent_id":user[parent_id],"pinned":user[pinned]] as [String : Any]
                let TEmpDIct2 = [user[_id]:tempDict1]
                
                TryMainArray.add(TEmpDIct2)
            }
          
     
            
        } catch {
            //  print(error)
        }
        
    }
    
}
