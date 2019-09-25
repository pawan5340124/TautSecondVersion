//
//  SqliteDataBase.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 20/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import Foundation

import SQLite

class SqliteManagert: NSObject {
    
    var Localdatabase: Connection!

    
    ////////////USER TABLE /////////////////
    let User_id = Expression<String?>("User_id")
    let Team_id = Expression<String>("Team_id")
    let Profile_picture = Expression<String>("Profile_picture")
    let Name = Expression<String>("Name")
    let Status = Expression<String>("Status")
    let Display_name = Expression<String>("Display_name")
    let Designaion = Expression<String>("Designaion")
    let Phone_number = Expression<String>("Phone_number")
    let Account_status = Expression<String>("Account_status")
    let Is_admin = Expression<String>("Is_admin")
    let Is_online = Expression<String>("Is_online")
    let Is_guest = Expression<String>("Is_guest")


    func HandelUserTable (){
        let usersTableForNow = Table("UserTable")
        
        let createTable = usersTableForNow.create { (table) in
            table.column(User_id)
            table.column(Team_id)
            table.column(Profile_picture)
            table.column(Name)
            table.column(Status)
            table.column(Display_name)
            table.column(Designaion)
            table.column(Phone_number)
            table.column(Account_status)
            table.column(Is_admin)
            table.column(Is_online)
            table.column(Is_guest)
        }
        
        do {
            try Localdatabase.run(createTable)
            //  print("Created Table")
        } catch {
             print(error)
        }
    }
    
    
    /////////////// MESSAGE TABLE ////////////////////
    let Message_id = Expression<String?>("Message_id")
    let Team_id_Message = Expression<String>("Team_id_Message")
    let Chatgroup_id = Expression<String>("Chatgroup_id")
    let From_id = Expression<String>("From_id")
    let Message_type = Expression<String>("Message_type")
    let Content = Expression<String>("Content")
    let Parent_id = Expression<String>("Parent_id")
    let Starred = Expression<String>("Starred")
    let Read_by = Expression<String>("Read_by")
    let Pinned = Expression<String>("Pinned")
    let Created_at = Expression<String>("Created_at")
    let Modified_at = Expression<String>("Modified_at")

    func HandelMessageTable (){
        let usersTableForNow = Table("MessageTable")
        
        let createTable = usersTableForNow.create { (table) in
            table.column(Message_id)
            table.column(Team_id_Message)
            table.column(Chatgroup_id)
            table.column(From_id)
            table.column(Message_type)
            table.column(Content)
            table.column(Parent_id)
            table.column(Starred)
            table.column(Read_by)
            table.column(Pinned)
            table.column(Created_at)
            table.column(Modified_at)

        }
        
        do {
            try Localdatabase.run(createTable)
            //  print("Created Table")
        } catch {
            print(error)
        }
    }
    
    
    
    /////////////// Active Team /////////////////
    
    let Team_id_InTemList = Expression<String?>("Team_id_InTemList")
    let Team_name = Expression<String>("Team_name")
    let Team_logo = Expression<String>("Team_logo")
    let Edit_message_allowed = Expression<String>("Edit_message_allowed")
    let Delete_message_allowed = Expression<String>("Delete_message_allowed")
    
    
    func HandelTeamTable (){
        let usersTableForNow = Table("TeamTable")
        
        let createTable = usersTableForNow.create { (table) in
            table.column(Team_id_InTemList)
            table.column(Team_name)
            table.column(Team_logo)
            table.column(Edit_message_allowed)
            table.column(Delete_message_allowed)
   
        }
        
        do {
            try Localdatabase.run(createTable)
            //  print("Created Table")
        } catch {
            print(error)
        }
    }
    

}
