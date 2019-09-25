//
//  CommonValue.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import Foundation

var MemberListCustom : NSMutableDictionary = [:]

var ApiUrlCall = UrlStore()
struct UrlStore {
    var BaseUrl = ""
    var RegisterEmailSend = ""
    var RegisterUserToken = ""
    var RegisterCreateTeam = ""
    var RegisterCheckTeamUrl = ""
    var RegisterTeamActivate = ""
    var LogINAPi = ""
    var MagicLinkSendForLogIn = ""
    var MagicLinkVerifyLogin = ""
    var MagicLinkSendForForgotPassword = ""
    var MagicLinkVerifyForForgotPassword = ""
    var ResetPassword = ""
    var FindWorkSpaceUsingEMail = ""
    var FindWorkSpaceTokenVerify = ""
    var Creategroup = ""
    var SocketbaseUrl = ""
    var AfterApi = ""
    var CreateGroup = ""
    var InvitationSend = ""
    var InvitationTokenVerify = ""
    var CompleteVerification = ""
    
    init() {
        BaseUrl = "https://api.taut.team/"
        RegisterEmailSend = "user/register"
        RegisterUserToken = "user/verify"
        RegisterCreateTeam = "user/createteam"
        RegisterCheckTeamUrl = "user/checkteamurl"
        RegisterTeamActivate = "user/verifyteam"
        LogINAPi = "user/login"
        MagicLinkSendForLogIn = "user/loginwithmagicalink"
        MagicLinkVerifyLogin = "user/acceptloginwithmagicalink"
        MagicLinkSendForForgotPassword = "user/magicallinkwithteamurl"
        MagicLinkVerifyForForgotPassword = "user/verifymagicallinkwithteamurl"
        ResetPassword = "user/forgotpassword"
        FindWorkSpaceUsingEMail = "user/magicallinkwithoutteamurl"
        FindWorkSpaceTokenVerify = "user/verifymagicallinkwithoutteamurl"
        Creategroup = "user/createchatgroups"
        SocketbaseUrl = "https://api.taut.team/"
        AfterApi = "user/getdatabytime"
        CreateGroup = "user/createchannels"
        InvitationSend = "user/sendinvitation"
        InvitationTokenVerify = "user/verifyinvitation"
        CompleteVerification = "user/completeinvitation"
    }
    
}
