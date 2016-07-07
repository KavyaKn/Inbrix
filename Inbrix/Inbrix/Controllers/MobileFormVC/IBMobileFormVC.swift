//
//  IBMobileFormVC.swift
//  Inbrix
//
//  Created by Kavya on 07/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBMobileFormVC: IBBaseVC , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var locationNumberTextField: UITextField!
    @IBOutlet weak var onelineTextField: UITextField!
    @IBOutlet weak var paraTextView: UITextView!
    @IBOutlet weak var checkListTableView: UITableView!
    
    var array : NSMutableArray = NSMutableArray()
    var selectedArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomBackButton()
        self.registerCell()
        let gallaryImage   = UIImage(named: "GalleryPlaceHolder")!
        let gallaryButton   = UIBarButtonItem(image: gallaryImage,  style: .Plain, target: self, action: #selector(IBMobileFormVC.didTapGallaryButton(_:)))
        navigationItem.rightBarButtonItems = [gallaryButton]
    }
    
    func didTapGallaryButton(sender: AnyObject){
        
    }
    
    func registerCell() {
        let checkListCellNib = UINib(nibName:"IBCheckListTableViewCell" , bundle: nil)
        checkListTableView.registerNib(checkListCellNib, forCellReuseIdentifier: "IBCheckListTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mobileFormSaveButtonClicked(sender: AnyObject) {
        
    }
}

// MARK: - UITableViewDataSource
extension IBMobileFormVC {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("IBCheckListTableViewCell", forIndexPath: indexPath) as! IBCheckListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.checkListLabel.text = "Task \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! IBCheckListTableViewCell
        cell.checkListButton.isChecked = !cell.checkListButton.isChecked
        
    }
}
