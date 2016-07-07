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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomBackButton()
        let gallaryImage   = UIImage(named: "GalleryPlaceHolder")!
        let gallaryButton   = UIBarButtonItem(image: gallaryImage,  style: .Plain, target: self, action: #selector(IBMobileFormVC.didTapGallaryButton(_:)))
        navigationItem.rightBarButtonItems = [gallaryButton]
    }
    
    func didTapGallaryButton(sender: AnyObject){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mobileFormSaveButtonClicked(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension IBMobileFormVC {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(kIBCustomTableViewCellNibName, forIndexPath: indexPath) as! CustomTableViewCell
//        
//        return cell
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellId: NSString = "CheckListCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId as String)! as UITableViewCell
        cell.textLabel?.text = "Test"
        
        
        return cell
    }
}
