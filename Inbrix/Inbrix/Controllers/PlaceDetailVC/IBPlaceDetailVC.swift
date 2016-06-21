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

class IBPlaceDetailVC: IBBaseVC, UICollectionViewDataSource, UICollectionViewDelegate, RMImagePickerControllerDelegate, DKImagePickerControllerDelegate, SwiftAlertViewDelegate, UIScrollViewDelegate, RNGridMenuDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var imageScrollView: UIScrollView!
    lazy var imageManager = PHImageManager.defaultManager()
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
        imageCollectionView?.alwaysBounceHorizontal = true
        if let result = CoreDataManager.sharedInstance.fetchImages() {
            self.imageAssets = result
        }
        for (_, element) in imageAssets.enumerate() {
            print(element.valueForKey("imageId"))
        }
        countriesinAsia = ["Japan","China","India"]
        totalPages = self.imageAssets.count
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
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageAssets.count == 0{
            return 20
        } else {
            return self.imageAssets.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kIBCollectionViewCellIdentifier, forIndexPath: indexPath)
        if self.imageAssets.count != 0 {
            let locationImage = self.imageAssets[indexPath.row] as IBLocationImages
            let imageView: UIImageView = cell.viewWithTag(cellImageViewTag) as! UIImageView
            print(locationImage)
            if (locationImage.image != nil) {
                let data = locationImage.image
                imageView.image = UIImage(data: data!)
            }
            imageView.layer.borderWidth = 1.0
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.whiteColor().CGColor
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.clipsToBounds = true
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected")
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
    
    @IBAction func addImageButtonClicked(sender: AnyObject) {
        self.showGrid()
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
            self.imageCollectionView?.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(pickerController, animated: true) {}
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = countriesinAsia[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = NSBundle.mainBundle().loadNibNamed(kIBSegmentHeaderViewCellNibName, owner: nil, options: nil)[0] as? IBSegmentHeaderViewCell
        headerCell?.customHeaderView()
        headerCell?.segmentedHeaderView.addTarget(self, action: #selector(IBPlaceDetailVC.segmentedControlClicked), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControlClicked((headerCell?.segmentedHeaderView)!)
        return headerCell
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
        switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog("First was selected");
            break;
        case 1:
            NSLog("Second was selected");
            break;
        case 2:
            NSLog("Third was selected");
            break;
        default:
            break;
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
