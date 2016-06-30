//
//  IBPlaceDetailVC.swift
//  Inbrix
//
//  Created by Kavya on 08/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer
import CoreData

let cellSize = CGSize(width: 80, height: 80)
var cellImageViewTag : Int = 1

class IBPlaceDetailVC: IBBaseVC, RMImagePickerControllerDelegate, DKImagePickerControllerDelegate, SwiftAlertViewDelegate, UIScrollViewDelegate, RNGridMenuDelegate {
    
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var locationDetailTableView: UITableView!
    lazy var imageManager = PHImageManager.defaultManager()
    var selectedIndexPath : NSIndexPath?
    var gallaryAssets: [PHAsset] = []
    var CameraAssets: [DKAsset]?
    var imageAssets = [IBLocationImages]()
    var numberOfOptions : NSInteger = 2
    var items : NSArray = []
    var imagePicker = RMImagePickerController()
    var pickerController = DKImagePickerController()
    var isGallary : Bool = false
    var totalPages = Int()
    
    var countriesinAsia = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let result = CoreDataManager.sharedInstance.fetchImages() {
            self.imageAssets = result
        }
        for (_, element) in imageAssets.enumerate() {
            print(element.valueForKey("imageId"))
        }
        countriesinAsia = ["Japan","China","India"]
        totalPages = self.imageAssets.count
        self.initializeView()
        self.registerCell()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureScrollView()
        configurePageControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        let cameraImage   = UIImage(named: "CameraPlaceHolder")!
        let locationImage = UIImage(named: "Location")!
        let cameraButton   = UIBarButtonItem(image: cameraImage,  style: .Plain, target: self, action: #selector(IBPlaceDetailVC.didTapCameraButton(_:)))
        let locationButton = UIBarButtonItem(image: locationImage,  style: .Plain, target: self, action: #selector(IBPlaceDetailVC.didTapLocationButton(_:)))
        navigationItem.rightBarButtonItems = [cameraButton, locationButton]
        self.locationDetailTableView.tag = 0
    }
    
    func registerCell() {
        let locationDetailCellNib = UINib(nibName:"IBLocationDetailCell" , bundle: nil)
        locationDetailTableView.registerNib(locationDetailCellNib, forCellReuseIdentifier: "IBLocationDetailCell")
        let segmentHeaderCellNib = UINib(nibName:"IBSegmentHeaderViewCell" , bundle: nil)
        locationDetailTableView.registerNib(segmentHeaderCellNib, forCellReuseIdentifier: "IBSegmentHeaderViewCell")
        let brandHeaderCellNib = UINib(nibName:"IBBrandHeaderCell" , bundle: nil)
        locationDetailTableView.registerNib(brandHeaderCellNib, forCellReuseIdentifier: "IBBrandHeaderCell")
        let expandedBrandDetailCellNib = UINib(nibName:"IBExpandedBrandDetailCell" , bundle: nil)
        locationDetailTableView.registerNib(expandedBrandDetailCellNib, forCellReuseIdentifier: "IBExpandedBrandDetailCell")
        let establishmentCellNib = UINib(nibName:"IBEstablishmentCell" , bundle: nil)
        locationDetailTableView.registerNib(establishmentCellNib, forCellReuseIdentifier: "IBEstablishmentCell")
    }
    
    func didTapCameraButton(sender: AnyObject){
        self.showGrid()
    }
    
    func didTapLocationButton(sender: AnyObject){
    }
    
    // MARK: - RMImagePickerControllerDelegate
    
    func rmImagePickerController(picker: RMImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        self.gallaryAssets.appendContentsOf(assets)
        self.dismissPickerPopover()
    }
    
    func rmImagePickerControllerDidCancel(picker: RMImagePickerController) {
        self.dismissPickerPopover()
    }
    
    // MARK: - Utility
    
    func dismissPickerPopover() {
        let imageEditingVC:IBImageEditingVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBImageEditingViewControllerIdentifier) as! IBImageEditingVC
        imageEditingVC.gallaryAssets = self.gallaryAssets
        self.navigationController!.pushViewController(imageEditingVC , animated: true)
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - DKImagePickerControllerDelegate
    
    func dkImagePickerController(picker: DKImagePickerController, didFinishPickingAssets assets: [DKAsset]){
        self.dismissCameraPopover()
    }
    
    func dkImagePickerControllerDidCancel(picker: DKImagePickerController){
        self.dismissCameraPopover()
    }
    
    func dismissCameraPopover(){
        let imageEditingVC:IBImageEditingVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBImageEditingViewControllerIdentifier) as! IBImageEditingVC
        imageEditingVC.cameraAssets = self.CameraAssets!
        self.navigationController!.pushViewController(imageEditingVC , animated: true)
        pickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showGrid() {
        items = [RNGridMenuItem(image: UIImage(named: "Camera"), title: "Camera"),
                 RNGridMenuItem(image: UIImage(named: "Gallery"), title: "Gallery")]
        let gridItems = RNGridMenu.init(items:items.subarrayWithRange(NSMakeRange(0, numberOfOptions)) )
        gridItems.delegate = self
        gridItems.showInViewController(self, center: CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2))
    }
    
    func gridMenu(gridMenu: RNGridMenu, willDismissWithSelectedItem item: RNGridMenuItem, atIndex itemIndex: Int) {
        if (itemIndex == 0) {
            self.takePhoto()
        } else if (itemIndex == 1) {
            self.pickImages()
        }
    }
    
    // MARK: - Actions
    
    func pickImages() {
        isGallary = true
        self.imagePicker = RMImagePickerController()
        imagePicker.pickerDelegate = self
        // Dissmissing AlertView
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto(){
        isGallary = false
        print("ButtonTapped")
        let sourceType:DKImagePickerControllerSourceType = .Camera
        showImagePickerWithAssetType(.AllPhotos, allowMultipleType: true, sourceType: sourceType, allowsLandscape: true, singleSelect: true)
    }
    
    func updateProfileButtonOffsets(button: UIButton) {
        button.titleLabel!.textAlignment = .Center
        button.imageView!.contentMode = .Center
        // get the size of the elements here for readability
        let imageSize: CGSize = button.imageView!.frame.size
        var titleSize: CGSize = button.titleLabel!.frame.size
        // lower the text and push it left to center it
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, 0.0)
        // the text width might have changed (in case it was shortened before due to
        // lack of space and isn't anymore now), so we get the frame size again
        titleSize = button.titleLabel!.frame.size
        // raise the image and push it right to center it
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -titleSize.width)
    }
    
    func showImagePickerWithAssetType(assetType: DKImagePickerControllerAssetType,
                                      allowMultipleType: Bool,
                                      sourceType: DKImagePickerControllerSourceType = [.Camera, .Photo],
                                      allowsLandscape: Bool,
                                      singleSelect: Bool) {
        
        pickerController.dkPickerDelegate = self
        pickerController.assetType = assetType
        pickerController.allowsLandscape = allowsLandscape
        pickerController.allowMultipleTypes = allowMultipleType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        pickerController.defaultSelectedAssets = self.CameraAssets
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.CameraAssets = assets
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(pickerController, animated: true) {}
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.locationDetailTableView.tag == 0) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowCount = 0
        if (self.locationDetailTableView.tag == 0) {
            if section == 0 {
                numberOfRowCount = 1
            }
            if section == 1 {
                numberOfRowCount = 4
            }
        } else {
            numberOfRowCount = 10
        }
        return numberOfRowCount
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if ( self.locationDetailTableView.tag == 0) {
            if (indexPath.section == 0) {
                let locationDetailCell = tableView.dequeueReusableCellWithIdentifier("IBLocationDetailCell", forIndexPath: indexPath) as! IBLocationDetailCell
                locationDetailCell.locationNameLabel.text = ""
                locationDetailCell.locationIdLabel.text = ""
                locationDetailCell.locationPhoneNoLabel.text = ""
                locationDetailCell.locationEmailLabel.text = ""
                locationDetailCell.locationAddressLabel.text = ""
                cell = locationDetailCell
                
            } else {
                let expandedBrandDetailCell = tableView.dequeueReusableCellWithIdentifier("IBExpandedBrandDetailCell", forIndexPath: indexPath) as! IBExpandedBrandDetailCell
                expandedBrandDetailCell.checkHeight()
                expandedBrandDetailCell.brandTitleLabel.text = "BMW"
                expandedBrandDetailCell.storeNameLabel.text = "The BMW Store"
                expandedBrandDetailCell.storeNumberLabel.text = "19051"
                expandedBrandDetailCell.storeAddressLabel.text = "2040 Burrard Street Vancouver, B.C., V6J 3H5 Direct: 604-659-3200"
                cell = expandedBrandDetailCell
            }
        } else {
            let establishmentCell = tableView.dequeueReusableCellWithIdentifier("IBEstablishmentCell", forIndexPath: indexPath) as? IBEstablishmentCell
            establishmentCell!.establishmentCellLabel.text = "Establishment 1"
            cell = establishmentCell
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell : UIView = UIView()
        if (section == 0) {
            let  segmentedHeaderView = NSBundle.mainBundle().loadNibNamed(kIBSegmentHeaderViewCellNibName, owner: nil, options: nil)[0] as! IBSegmentHeaderViewCell
            segmentedHeaderView.customHeaderView()
            segmentedHeaderView.segmentedControl.addTarget(self, action: #selector(IBPlaceDetailVC.segmentedControlClicked), forControlEvents: UIControlEvents.ValueChanged)
            segmentedHeaderView.segmentedControl.selectedSegmentIndex = tableView.tag
            segmentedControlClicked((segmentedHeaderView.segmentedControl)!)
            headerCell = segmentedHeaderView
        } else {
            let  brandHeaderCell = NSBundle.mainBundle().loadNibNamed("IBBrandHeaderCell", owner: nil, options: nil)[0] as! IBBrandHeaderCell
            brandHeaderCell.brandHeaderLabel.text = "Brands"
            headerCell = brandHeaderCell
        }
        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.locationDetailTableView.tag == 0) {
            let previousIndexPath = selectedIndexPath
            if indexPath == selectedIndexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
            
            var indexPaths : Array<NSIndexPath> = []
            if let previous = previousIndexPath{
                indexPaths += [previous]
            }
            if let current = selectedIndexPath {
                indexPaths += [current]
            }
            if indexPaths.count > 0 {
                tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        } else {
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight : CGFloat
        if (self.locationDetailTableView.tag == 0) {
            if (indexPath.section == 0) {
                rowHeight = 155
            } else {
                if indexPath == selectedIndexPath {
                    rowHeight = IBExpandedBrandDetailCell.expandedHeight
                } else {
                    rowHeight = IBExpandedBrandDetailCell.defaultHeight
                }
            }
        } else {
            rowHeight = 40
        }
        return rowHeight
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
        if (locationDetailTableView.tag != sender.selectedSegmentIndex) {
            self.locationDetailTableView.tag = sender.selectedSegmentIndex
            self.locationDetailTableView.reloadData()
        }
    }
    
    // MARK: Custom Page control method implementation
    
    func configureScrollView() {
        // Enable paging.
        imageScrollView.pagingEnabled = true
        
        // Set the following flag values.
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.scrollsToTop = false
        
        // Set the scrollview content size.
        imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * CGFloat(totalPages), imageScrollView.frame.size.height)
        
        // Set self as the delegate of the scrollview.
        imageScrollView.delegate = self
        
        // Load the TestView view from the TestView.xib file and configure it properly.
        for i in 0 ..< totalPages {
            // Load the TestView view.
            let testView = NSBundle.mainBundle().loadNibNamed(kIBPageControlerImageViewNibName, owner: self, options: nil)[0] as! UIView
            
            // Set its frame and the background color.
            testView.frame = CGRectMake(CGFloat(i) * imageScrollView.frame.size.width, 0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)
            
            let pageImage = testView.viewWithTag(1) as! UIImageView
            let locationImage = self.imageAssets[i] as IBLocationImages
            let data = locationImage.image
            pageImage.image = UIImage(data: data!)
            
            // Add the test view as a subview to the scrollview.
            imageScrollView.addSubview(testView)
        }
    }
    
    
    func configurePageControl() {
        // Set the total pages to the page control.
        imagePageControl.numberOfPages = totalPages
        
        // Set the initial page.
        imagePageControl.currentPage = 0
    }
    
    
    // MARK: UIScrollViewDelegate method implementation
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.size.width);
        
        // Set the new page index to the page control.
        imagePageControl.currentPage = Int(currentPage)
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func changePage(sender: AnyObject) {
        // Calculate the frame that should scroll to based on the page control current page.
        var newFrame = imageScrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(imagePageControl.currentPage)
        imageScrollView.scrollRectToVisible(newFrame, animated: true)
        
    }
    
    
}
