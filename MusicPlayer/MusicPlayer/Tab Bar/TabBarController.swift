//
//  TabBarController.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 27/11/23.
//

import UIKit

class TabBarController: UITabBarController, TabBarViewDelegate {
    
    var tabBarView : TabBarView = TabBarView()
    var tabBarViewHeightConstraint: NSLayoutConstraint?
    var globalPlayBar : GlobalPlayBar = GlobalPlayBar()
    
    override func loadView() {
        super.loadView()
        tabBarView = Bundle.main.loadNibNamed("TabBarView", owner: nil, options: nil)?.last as! TabBarView
        globalPlayBar = Bundle.main.loadNibNamed("GlobalPlayBar", owner: nil)?.last as! GlobalPlayBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        tabBarView.delegate = self
        addTabBarView()
        setupGlobalPlayBar()
        setup()
        
    }
    
    
    @objc func redirectToTabBar(noti : Notification)
    {
        if let dict : [String : Any] = noti.userInfo as? [String : Any]
        {
            if let index : Int = dict["tabIndex"] as? Int
            {
                tabBarView.resetAllButton()
                tabBarView.lastIndex = index
                tabBarView.selectTabButton()
                tabSelectedAtIndex(index: index)
            }
        }
    }
    
    //MARK: - TABBAR SETUP
    func setup()
    {
        var navigatonControllers = [UINavigationController]()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let forYouViewController = storyBoard.instantiateViewController(withIdentifier: "ForYouVC")
        let forNavigatioController : UINavigationController = UINavigationController(rootViewController: forYouViewController)
        navigatonControllers.append(forNavigatioController)
        
        let topTracksViewController = storyBoard.instantiateViewController(withIdentifier: "TopTracksVC")
        let topTracksNavigationController : UINavigationController = UINavigationController(rootViewController: topTracksViewController)
        navigatonControllers.append(topTracksNavigationController)
        
        self.viewControllers = navigatonControllers;
        self.tabSelectedAtIndex(index: 0)
    }
    
    func tabSelectedAtIndex(index: Int) {
        
        setSelectedViewController(selectedViewController: (self.viewControllers?[index])!, tabIndex: index)
    }
    
    func setSelectedViewController(selectedViewController:UIViewController, tabIndex:Int)
    {
        // pop to root if tapped the same controller twice
        if self.selectedViewController == selectedViewController {
            (self.selectedViewController as! UINavigationController).popToRootViewController(animated: true)
        }else{
            //            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: nil)
        }
        super.selectedViewController = selectedViewController
        
    }
    
    func addTabBarView()
    {
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabBarView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        
        tabBarViewHeightConstraint = self.tabBarView.heightAnchor.constraint(equalToConstant: 50 + (UIScreen.main.bounds.size.height >= 812 ? 34 : 0))
        tabBarViewHeightConstraint?.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    func setTabBarHidden(tabBarHidden:Bool)
    {
        UIView.animate(withDuration: 0.3) {
            self.tabBarViewHeightConstraint?.constant = tabBarHidden ? 0 : 50 + (UIScreen.main.bounds.size.height >= 812 ? 34 : 0)
            self.view.layoutIfNeeded()
        }
        self.tabBarView.isHidden = tabBarHidden
        self.tabBar.isHidden = true
    }
    
    func setupGlobalPlayBar() {
        self.tabBarView.addSubview(globalPlayBar)
        globalPlayBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            globalPlayBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            globalPlayBar.heightAnchor.constraint(equalToConstant: 65),
            globalPlayBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            globalPlayBar.bottomAnchor.constraint(equalTo: self.tabBarView.topAnchor)
        ])
        globalPlayBar.backgroundColor = .purple
//        globalPlayBar.backView.applyGradientColor(accentColor: "#C6C6DE")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

