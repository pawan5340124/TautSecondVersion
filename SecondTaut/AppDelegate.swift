//
//  AppDelegate.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 19/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MyBaby
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(Home.self)
        IQKeyboardManager.shared.enabledTouchResignedClasses.append(Home.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(Home.self)

        UIApplication.shared.isIdleTimerDisabled = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.AfterApiCall()
      
        self.HomeRoot()
        self.NotificationStart()
        return true
    }
    
    //MARK: - NotificationStart(){
    func NotificationStart()  {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in}
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        UserDefaults.standard.set("Simulator", forKey: "deviceToken")
        UserDefaults.standard.synchronize()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications
        {
            completionHandler([.alert, .badge, .sound])
        }
        
        let NotificationDataGot = notification.request.content.userInfo as NSDictionary
        print(NotificationDataGot)
        
        
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    //MARK: - NotificationFunction
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            // print(url)
            
            let UrlString =  String(describing: url)
            print(UrlString)
            if UrlString.contains("https://tautweb.matrixmarketers.com/register/") {
                let VerificationTokenGet = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/register/", with: "")
                UserDefaults.standard.set(VerificationTokenGet, forKey: "VerificationTokenGotForREgistration")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VerificationTokenGotForREgistration"), object: nil)

            }
            else if UrlString.contains("https://tautweb.matrixmarketers.com/verify-team/") {
                let verifyteamtoken = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/verify-team/", with: "")
                UserDefaults.standard.set(verifyteamtoken, forKey: "verifyteamtoken")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "verifyteamtoken"), object: nil)
                
            }
            else if UrlString.contains("https://tautweb.matrixmarketers.com/loginwithmagicallink/") {
                let verifyteamtoken = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/loginwithmagicallink/", with: "")
                UserDefaults.standard.set(verifyteamtoken, forKey: "DirectLoginWIthMagicLinkToken")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectLoginWIthMagicLinkToken"), object: nil)
            }
            else if UrlString.contains("https://tautweb.matrixmarketers.com/recover-password/") {
                let VerifyForgotPasswordToken = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/recover-password/", with: "")
                UserDefaults.standard.set(VerifyForgotPasswordToken, forKey: "VerifyForgotPasswordToken")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VerifyForgotPasswordToken"), object: nil)
            }
            else if UrlString.contains("https://tautweb.matrixmarketers.com/your-teams/") {
                let yourteamsToken = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/your-teams/", with: "")
                UserDefaults.standard.set(yourteamsToken, forKey: "yourteamsToken")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "yourteamsToken"), object: nil)
            }
            else if UrlString.contains("https://tautweb.matrixmarketers.com/invitation/") {
                if(UserDefaults.standard.value(forKey: "LogInTeamData") == nil) {

                    let AcceptInvitation = String(url.absoluteString).replacingOccurrences(of: "https://tautweb.matrixmarketers.com/invitation/", with: "")
                UserDefaults.standard.set(AcceptInvitation, forKey: "AcceptInvitationToken")
                UserDefaults.standard.synchronize()
                self.InvitationAccept()
                }
            }
            
        
        }
        
        
        return false
    }

    
  
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        socket.disconnect()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
         self.AfterApiCall()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
               // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    func AfterApiCall(){
        if(UserDefaults.standard.value(forKey: "LastTimeSave") != nil) {
            NewFunctionCall.SocketConnectAgain()
            let DateString : String = UserDefaults.standard.value(forKey: "LastTimeSave") as! String
            NewFunctionCall.AfterApiHit(LastTime: DateString)
        }
    }

    func InvitationAccept(){
        window = UIWindow(frame: UIScreen.main.bounds)
        let StoryBoardInstance : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let FirstScreenInstance = StoryBoardInstance.instantiateViewController(withIdentifier: "AccpetInvitationNavigation") as! AccpetInvitationNavigation
        window?.rootViewController = FirstScreenInstance
        window?.makeKeyAndVisible()
    }
    
    func HomeRoot(){
          if(UserDefaults.standard.value(forKey: "LogInTeamData") != nil) {
            window = UIWindow(frame: UIScreen.main.bounds)
            let StoryBoardInstance : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let FirstScreenInstance = StoryBoardInstance.instantiateViewController(withIdentifier: "CustomSplashNavigation") as! CustomSplashNavigation
            window?.rootViewController = FirstScreenInstance
            window?.makeKeyAndVisible()
        }
        else{
            window = UIWindow(frame: UIScreen.main.bounds)
            let StoryBoardInstance : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let FirstScreenInstance = StoryBoardInstance.instantiateViewController(withIdentifier: "NaviGationViewController") as! UINavigationController
            window?.rootViewController = FirstScreenInstance
            window?.makeKeyAndVisible()
        }
  
    }
    
    func LounchChat(){
        window = UIWindow(frame: UIScreen.main.bounds)
         let StoryBoardInstance : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let FirstScreenInstance = StoryBoardInstance.instantiateViewController(withIdentifier: "HomeNavigation") as! HomeNavigation
        window?.rootViewController = FirstScreenInstance
        window?.makeKeyAndVisible()
    }
    
}

