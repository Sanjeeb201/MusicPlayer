//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController : TabBarController!
    var globalPlayBar : GlobalPlayBar = GlobalPlayBar()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initialiseTabBarController()
        return true
    }
    
    func initialiseTabBarController() {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
        window?.rootViewController = tabBarController
    }
    

    //MARK:- Share Appdelegate
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showTabBar() {
        if tabBarController != nil {
            tabBarController.setTabBarHidden(tabBarHidden: false)
        }
    }
    
    func hideTabBar() {
        if tabBarController != nil {
            tabBarController.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK:- set music data
    func setMusicDataInGlobalView()
    {
        GlobalPlayBar.shared.setupCurrentTrackData()
        
//        if let musicPlayer = PlayerManager.shared.player{
//            if musicPlayer.isPlaying{
//                
//            }
//            else{
//                globalPlayBar.playPauseBtn.isSelected = false
//            }
//        }
    }


}

