//
//  IBMenuVC.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

enum IBMenuOptions: Int {
    case IBMenuHome = 0
    case IBMenuAbout
    case IBMenuLogout
}

class IBMenuVC: IBBaseVC {

    @IBOutlet weak var menuTableView: UITableView!
    
    var menuDataSourceArray = [String]()
    var menuImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeDataSourceArray()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        menuTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        self.tableView(menuTableView, didSelectRowAtIndexPath: indexPath);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeDataSourceArray() {
        menuDataSourceArray = ["Home", "About", "Logout"]
        menuImagesArray = ["Home", "About", "Logout"]
    }
}

extension IBMenuVC: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataSourceArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuCell"
        var menuCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        
        if menuCell == nil {
            menuCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let detailText = menuDataSourceArray[indexPath.row]
        let imageName = menuImagesArray[indexPath.row]
        
        menuCell!.textLabel?.text = detailText
        menuCell?.textLabel?.font = UIFont.cellLabelFont()
        menuCell?.textLabel?.textColor = UIColor.menuCellTintColor()
        menuCell?.imageView?.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        menuCell?.imageView?.tintColor = UIColor.menuCellTintColor()
        
        menuCell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        return menuCell!
    }
    
}

extension IBMenuVC: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let array = NSBundle.mainBundle().loadNibNamed("IBMenuHeaderView", owner: self, options: nil)
        let headerView = array.first as! IBMenuHeaderView
        headerView.initializeView()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if ((cell?.selected) != nil) {
            cell?.imageView?.tintColor = UIColor.menuCellSelectedTintColor()
            cell?.textLabel?.textColor = UIColor.menuCellSelectedTintColor()
        }
        
        if let menu = IBMenuOptions(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.imageView?.tintColor = UIColor.menuCellTintColor()
        cell?.textLabel?.textColor = UIColor.menuCellTintColor()
        
    }
    
    func changeViewController(menu: IBMenuOptions) {
        var viewController: AnyObject?;
        
        switch menu {
        case .IBMenuHome:
            viewController = UIStoryboard.viewController("IBPlaceListVC", storyBoardName: "Main") as! IBPlaceListVC
            break
            
        case .IBMenuAbout:
            viewController = UIStoryboard.viewController("IBPlaceListVC", storyBoardName: "Main") as! IBPlaceListVC
            break
            
            
        case .IBMenuLogout:
            viewController = UIStoryboard.viewController("IBLoginVC", storyBoardName: "Main") as! IBLoginVC
            break
        }
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController as! UIViewController)
        
        self.slideMenuController()?.changeMainViewController(navigationController, close: true)
    }
    
}
