//
//  IBEstablishmentDetailVC.swift
//  Inbrix
//
//  Created by Kavya on 21/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBEstablishmentDetailVC: IBBaseVC, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var establismentNameLabel: UILabel!
    @IBOutlet weak var establishmentIdLabel: UILabel!
    @IBOutlet weak var establismentPhoneNoLabel: UILabel!
    @IBOutlet weak var establismentEmailLabel: UILabel!
    @IBOutlet weak var establishmentAddressLabel: UILabel!
    @IBOutlet weak var establismentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var establismentDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        self.registerCell()
    }
    
    func initializeView () {
        self.establismentSegmentedControl.customSegmentView()
        self.establismentSegmentedControl.addTarget(self, action: #selector(IBPlaceDetailVC.segmentedControlClicked), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControlClicked((self.establismentSegmentedControl)!)
        self.addCustomBackButton()
    }
    
    func registerCell() {
        let establishmentCellNib = UINib(nibName:"IBEstablishmentCell" , bundle: nil)
        establismentDetailTableView.registerNib(establishmentCellNib, forCellReuseIdentifier: "IBEstablishmentCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var returnValue = 0
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = 1
            break
        case 1:
            returnValue = 2
            break
            
        case 2:
            returnValue = 1
            break
            
        default:
            break
            
        }
        
        return returnValue
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = 10
            break
        case 1:
            returnValue = 5
            break
            
        case 2:
            returnValue = 10
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var returnValue = ""
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = ""
            break
        case 1:
            switch section {
            case 0:
                returnValue = "Mobile Forms"
                
            case 1:
                returnValue = "Global Forms"
                
            default:
                returnValue = ""
            }
            break
            
        case 2:
            returnValue = ""
            break
            
        default:
            break
            
        }
        
        return returnValue
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell : UIView = UIView()
        let  formsHeaderCell = NSBundle.mainBundle().loadNibNamed("IBEstablishmentCell", owner: nil, options: nil)[0] as! IBEstablishmentCell
        formsHeaderCell.establishmentCellLabel.text = "Brands"
        headerCell = formsHeaderCell
        return headerCell
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let establishmentCell = tableView.dequeueReusableCellWithIdentifier("IBEstablishmentCell", forIndexPath: indexPath) as! IBEstablishmentCell
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            establishmentCell.establishmentCellLabel.text = "XML 1"
            break
        case 1:
            establishmentCell.establishmentCellLabel.text = "XML 1"
            break
            
        case 2:
            establishmentCell.establishmentCellLabel.text = "XML 1"
            break
            
        default:
            break
            
        }
        
        return establishmentCell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
        switch (establismentSegmentedControl.selectedSegmentIndex) {
        case 1:
            return indexPath.section == 0 ? true : false
            
        default:
            break
        }
        return indexPath.section != 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            print("What u want while Pressed delete")
        }
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            print("What u want while Pressed Edit")
        }
        
        edit.backgroundColor = UIColor.orangeColor()
        return [delete,edit]
    }
    
    func segmentedControlClicked(sender :UISegmentedControl){
        let sortedViews = sender.subviews.sort( { $0.frame.origin.x < $1.frame.origin.x } )
        
        for (index, view) in sortedViews.enumerate() {
            if index == sender.selectedSegmentIndex {
                view.tintColor = UIColor.orangeColor()
            } else {
                view.tintColor = UIColor.orangeColor()
            }
        }
        if (establismentDetailTableView.tag != sender.selectedSegmentIndex) {
            self.establismentDetailTableView.tag = sender.selectedSegmentIndex
            self.establismentDetailTableView.reloadData()
        }
    }
}
