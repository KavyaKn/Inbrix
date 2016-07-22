
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

class IBPlaceDetailVC: IBBaseVC, SwiftAlertViewDelegate {
    
    @IBOutlet weak var locationDetailTableView: UITableView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    lazy var imageManager = PHImageManager.defaultManager()
    var pickerController = DKImagePickerController()
    var imagePicker = RMImagePickerController()
    var imageAssets = [IBLocationImages]()
    var selectedIndexPath : NSIndexPath?
    var numberOfOptions : NSInteger = 2
    var isGallary : Bool = false
    var images: [PHAsset] = []
    var items : NSArray = []
    var totalPages = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let result = CoreDataManager.sharedInstance.fetchImages() {
        //            self.imageAssets = result
        //        }
        //        for (_, element) in imageAssets.enumerate() {
        //            print(element.valueForKey("imageId"))
        //        }
        totalPages = self.imageAssets.count
        self.initializeView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print(self.imageAssets.count)
        print(self.images.count)
        self.navigationController?.navigationBarHidden = false
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
    
    @IBAction func changePage(sender: AnyObject) {
        // Calculate the frame that should scroll to based on the page control current page.
        var newFrame = imageScrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(imagePageControl.currentPage)
        imageScrollView.scrollRectToVisible(newFrame, animated: true)
    }
}

// MARK : Helper Methods..

extension IBPlaceDetailVC {
    func initializeView() {
        let cameraImage   = UIImage(named: kIBCameraPlaceHolderImageName)!
        let locationImage = UIImage(named: kIBLocationIconImageName)!
        let cameraButton   = UIBarButtonItem(image: cameraImage,  style: .Plain, target: self, action: #selector(IBPlaceDetailVC.didTapCameraButton(_:)))
        let locationButton = UIBarButtonItem(image: locationImage,  style: .Plain, target: self, action: #selector(IBPlaceDetailVC.didTapLocationButton(_:)))
        navigationItem.rightBarButtonItems = [cameraButton, locationButton]
        self.locationDetailTableView.tag = 0
        self.registerCell()
    }
    
    func registerCell() {
        let locationDetailCellNib = UINib(nibName:kIBLocationDetailCellNibName , bundle: nil)
        locationDetailTableView.registerNib(locationDetailCellNib, forCellReuseIdentifier: kIBLocationDetailCellNibName)
        let segmentHeaderCellNib = UINib(nibName:kIBSegmentHeaderViewCellNibName , bundle: nil)
        locationDetailTableView.registerNib(segmentHeaderCellNib, forCellReuseIdentifier: kIBSegmentHeaderViewCellNibName)
        let brandHeaderCellNib = UINib(nibName:kIBBrandHeaderCellNibName , bundle: nil)
        locationDetailTableView.registerNib(brandHeaderCellNib, forCellReuseIdentifier: kIBBrandHeaderCellNibName)
        let expandedBrandDetailCellNib = UINib(nibName:kIBExpandedBrandDetailCellNibName , bundle: nil)
        locationDetailTableView.registerNib(expandedBrandDetailCellNib, forCellReuseIdentifier:kIBExpandedBrandDetailCellNibName)
        let establishmentCellNib = UINib(nibName:kIBEstablishmentCellNibName , bundle: nil)
        locationDetailTableView.registerNib(establishmentCellNib, forCellReuseIdentifier:kIBEstablishmentCellNibName)
    }
    
    func didTapCameraButton(sender: AnyObject){
        self.showSelectionAlert()
    }
    
    func didTapLocationButton(sender: AnyObject){
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
    
    //Custom Page control method implementation
    
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
}

// MARK: UIScrollViewDelegate Methods..

extension IBPlaceDetailVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.size.width);
        
        // Set the new page index to the page control.
        imagePageControl.currentPage = Int(currentPage)
    }
}

// MARK: RMImagePickerControllerDelegate

extension IBPlaceDetailVC : RMImagePickerControllerDelegate {
    
    func rmImagePickerController(picker: RMImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        self.images.appendContentsOf(assets)
        self.dismissPickerPopover()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rmImagePickerControllerDidCancel(picker: RMImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissPickerPopover() {
        let imageEditingVC:IBImageEditingVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBImageEditingViewControllerIdentifier) as! IBImageEditingVC
        imageEditingVC.imageAssets = self.images
        self.navigationController!.pushViewController(imageEditingVC , animated: true)
    }
}

// MARK: DKImagePickerControllerDelegate

extension IBPlaceDetailVC : DKImagePickerControllerDelegate {
    
    func dkImagePickerController(picker: DKImagePickerController, didFinishPickingAssets assets: [DKAsset]) {
        for asset in assets {
            self.images.append(asset.originalAsset!)
        }
        self.dismissPickerPopover()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dkImagePickerControllerDidCancel(picker: DKImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(pickerController, animated: true) {}
    }
    
}

// MARK: RNGridMenuDelegate methods..

extension IBPlaceDetailVC : RNGridMenuDelegate {
    
    func showSelectionAlert() {
        items = [RNGridMenuItem(image: UIImage(named:kIBCameraIconImageName), title: kIBCameraIconImageName),
                 RNGridMenuItem(image: UIImage(named:kIBGalleryIconImageName), title: kIBGalleryIconImageName)]
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
    
    func pickImages() {
        isGallary = true
        self.imagePicker = RMImagePickerController()
        imagePicker.pickerDelegate = self
        // Dissmissing AlertView
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        isGallary = false
        print("ButtonTapped")
        let sourceType:DKImagePickerControllerSourceType = .Camera
        showImagePickerWithAssetType(.AllPhotos, allowMultipleType: true, sourceType: sourceType, allowsLandscape: true, singleSelect: true)
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate

extension IBPlaceDetailVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.locationDetailTableView.tag == 0) {
            return kIBNumberOfSections
        } else {
            return kIBNumberOfSection
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
                locationDetailCell.locationNameLabel.text = "BMW"
                locationDetailCell.locationIdLabel.text = "19503"
                locationDetailCell.locationPhoneNoLabel.text = "1234567890"
                locationDetailCell.locationEmailLabel.text = "info@bmw-parsolimotors.in"
                locationDetailCell.locationAddressLabel.text = "White Wagon, Rajkot-Ahmedabad Highway, Nr. Greenland Circle, Rajkot, Gujarat 360003"
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
            let establishmentCell = tableView.dequeueReusableCellWithIdentifier(kIBEstablishmentCellNibName, forIndexPath: indexPath) as? IBEstablishmentCell
            establishmentCell!.establishmentCellLabel.text = "Establishment \(indexPath.row)"
            cell = establishmentCell
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell : UIView = UIView()
        if (section == 0) {
            let  segmentedHeaderView = NSBundle.mainBundle().loadNibNamed(kIBSegmentHeaderViewCellNibName, owner: nil, options: nil)[0] as! IBSegmentHeaderViewCell
            segmentedHeaderView.segmentedControl.addTarget(self, action: #selector(IBPlaceDetailVC.segmentedControlClicked), forControlEvents: UIControlEvents.ValueChanged)
            segmentedHeaderView.segmentedControl.selectedSegmentIndex = tableView.tag
            segmentedControlClicked((segmentedHeaderView.segmentedControl)!)
            headerCell = segmentedHeaderView
        } else {
            let  brandHeaderCell = NSBundle.mainBundle().loadNibNamed(kIBBrandHeaderCellNibName, owner: nil, options: nil)[0] as! IBBrandHeaderCell
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
            self.performSegueWithIdentifier(kIBEstablismentDetailSegueIdentifier , sender: nil)
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
}

