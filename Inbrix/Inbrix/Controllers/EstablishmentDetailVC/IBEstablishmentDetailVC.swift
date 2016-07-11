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
    
    var addButton : UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        self.registerCell()
        self.labelInitialData()
    }
    
    func initializeView () {
        self.establismentSegmentedControl.customSegmentView()
        self.establismentSegmentedControl.addTarget(self, action: #selector(IBPlaceDetailVC.segmentedControlClicked), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControlClicked((self.establismentSegmentedControl)!)
        self.addCustomBackButton()
        let addButtonImage   = UIImage(named: "add")!
        addButton = UIBarButtonItem(image: addButtonImage,  style: .Plain, target: self, action: #selector(IBEstablishmentDetailVC.didTapAddButton(_:)))
    }
    
    func registerCell() {
        let establishmentCellNib = UINib(nibName:"IBEstablishmentCell" , bundle: nil)
        establismentDetailTableView.registerNib(establishmentCellNib, forCellReuseIdentifier: "IBEstablishmentCell")
    }
    
    func labelInitialData() {
        self.establismentNameLabel.text = "BMW"
        self.establishmentIdLabel.text = "19503"
        self.establismentPhoneNoLabel.text = "1234567890"
        self.establismentEmailLabel.text = "info@bmw-parsolimotors.in"
        self.establishmentAddressLabel.text = "White Wagon, Rajkot-Ahmedabad Highway, Nr. Greenland Circle, Rajkot, Gujarat 360003"
        self.establishmentAddressLabel.numberOfLines = 0
        self.establishmentAddressLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.establishmentAddressLabel.sizeToFit()
    }
    
    func didTapAddButton(sender: AnyObject) {
        self.performSegueWithIdentifier("MobileFormSegue", sender: nil)
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = 15
            break
        case 1:
            returnValue = 5
            break
            
        case 2:
            returnValue = 15
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell : UIView = UIView()
        var baseView : UIView = UIView()
        if (establismentSegmentedControl.selectedSegmentIndex == 1) {
            headerCell = UIView(frame: CGRectMake(5, 5, tableView.frame.size.width - 10, 45))
            baseView = UIView(frame: CGRectMake(5, 5, tableView.frame.size.width - 10, 45))
            baseView.backgroundColor = UIColor.orangeColor()
            baseView.layer.cornerRadius = 2
            
            var frame = headerCell.frame
            frame.origin.x = 10
            frame.size.width -= 10
            
            var establishmentHeaderCellLabel = UILabel()
            establishmentHeaderCellLabel = UILabel(frame: frame)
            establishmentHeaderCellLabel.textColor = UIColor.whiteColor()
            establishmentHeaderCellLabel.backgroundColor = UIColor.orangeColor()
            switch section {
            case 0:
                establishmentHeaderCellLabel.text = "Mobile Forms"
            case 1:
                establishmentHeaderCellLabel.text = "Global Forms"
                
            default:
                establishmentHeaderCellLabel.text = ""
            }
            headerCell.addSubview(baseView)
            headerCell.addSubview(establishmentHeaderCellLabel)
        }
        return headerCell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (establismentSegmentedControl.selectedSegmentIndex == 1) {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let establishmentCell = tableView.dequeueReusableCellWithIdentifier("IBEstablishmentCell", forIndexPath: indexPath) as! IBEstablishmentCell
        
        switch(establismentSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            navigationItem.rightBarButtonItems = nil
            establishmentCell.establishmentCellLabel.text = "XML \(indexPath.row)"
            break
        case 1:
            navigationItem.rightBarButtonItems = [addButton]
            establishmentCell.establishmentCellLabel.text = "XML \(indexPath.row)"
            break
        case 2:
            navigationItem.rightBarButtonItems = nil
            establishmentCell.establishmentCellLabel.text = "XML \(indexPath.row)"
            break
            
        default:
            break
            
        }
        
        return establishmentCell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch (establismentSegmentedControl.selectedSegmentIndex) {
        case 1:
            return indexPath.section == 0 ? true : false
            
        default:
            break
        }
        return indexPath.section != 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            print("What u want while Pressed delete")
        }
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.performSegueWithIdentifier("MobileFormSegue", sender: nil)
            print("What u want while Pressed Edit")
        }
        edit.backgroundColor = UIColor.orangeColor()
        return [delete,edit]
    }
    
    func segmentedControlClicked(sender :UISegmentedControl) {
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
