//
//  IBMobileFormVC.swift
//  Inbrix
//
//  Created by Kavya on 07/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBMobileFormVC: IBBaseVC {

    @IBOutlet weak var locationNumberTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var checkListTableView: UITableView!
    @IBOutlet weak var onelineTextField: UITextField!
    @IBOutlet weak var paraTextView: UITextView!
    
    var selectedArray = NSMutableArray()
    var array = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mobileFormSaveButtonClicked(sender: AnyObject) {
        
    }
}

extension IBMobileFormVC {
    
    func initializeView() {
        let gallaryImage   = UIImage(named:kIBGalleryPlaceHolderImageName)!
        let gallaryButton   = UIBarButtonItem(image: gallaryImage,  style: .Plain, target: self, action: #selector(IBMobileFormVC.didTapGallaryButton(_:)))
        navigationItem.rightBarButtonItems = [gallaryButton]
        self.addCustomBackButton()
        self.registerCell()
    }
    
    func didTapGallaryButton(sender: AnyObject){
        
    }
    
    func registerCell() {
        let checkListCellNib = UINib(nibName:kIBCheckListTableViewCellNibName , bundle: nil)
        checkListTableView.registerNib(checkListCellNib, forCellReuseIdentifier:kIBCheckListTableViewCellNibName)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension IBMobileFormVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kIBNumberOfSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier(kIBCheckListTableViewCellNibName, forIndexPath: indexPath) as! IBCheckListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.checkListLabel.text = "Task \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! IBCheckListTableViewCell
        cell.checkListButton.isChecked = !cell.checkListButton.isChecked
        
    }
}
