//
//  IBImageEditingVC.swift
//  InbrixImageSample
//
//  Created by Kavya on 12/04/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
import AVFoundation
import Photos

let editCellSize = CGSize(width: 80, height: 80)
var editCellImageViewTag : Int = 10

class IBImageEditingVC: UIViewController {
    
    @IBOutlet weak var editingImageCollectionView: UICollectionView!
    @IBOutlet weak var imageNameTextField: UITextField!
    @IBOutlet weak var imagedescriptin: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    lazy var imageManager = PHImageManager.defaultManager()
    var selectedImageModel: [String: AnyObject] = [:]
    var pickerController = DKImagePickerController()
    var imagesArray : [IBLocationImageModel] = []
    var numberOfOptions : NSInteger = 2
    var imageAssets: [PHAsset] = []
    var isuploading : Bool = false
    var selectedIndex : Int = -1
    var isGallary : Bool = false
    var items : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        self.registerCollectionViewNib()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        storingInDictionary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        print(self.imagesArray.count)
        IBLocationImages.addLocationImages(self.imagesArray)
        let imagePickerVC:IBPlaceDetailVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBPlaceDetailViewControllerIdentifier) as! IBPlaceDetailVC
        self.navigationController?.pushViewController(imagePickerVC, animated: true)
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.imageAssets.removeAll()
        self.imagesArray.removeAll()
        self.navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: Helper methods..

extension IBImageEditingVC {
    
    func registerCollectionViewNib() {
        editingImageCollectionView.registerNib(UINib(nibName: kIBCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kIBCollectionViewCellIdentifier)
    }
    
    func initializeView() {
        self.imageNameTextField.addTarget(self, action: #selector(IBImageEditingVC.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.imageNameTextField.delegate = self
    }
    
    func storingInDictionary() {
        imagesArray.removeAll()
        if (self.imageAssets.count != 0) {
            for (_, asset) in self.imageAssets.enumerate() {
                self.loadImageFromAssets(asset)
            }
        }
    }
    
    func loadImageFromAssets(asset : PHAsset)  {
        self.imageManager.requestImageDataForAsset(asset, options: nil, resultHandler: { (data: NSData?, dataStrig: String?, imageOrirntation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
            let imageModel = IBLocationImageModel()
            imageModel.imageName = String.localizedValueForKey("EmptyString")
            imageModel.imageId = NSProcessInfo.processInfo().globallyUniqueString
            imageModel.imageAddedTime = NSDate()
            imageModel.image = data
            self.imagesArray.append(imageModel)
            self.editingImageCollectionView.reloadData()
        })
    }
    
    func deleteImage(at index: Int) {
        if isuploading {return }
        if (imagesArray.count != 0){
            imagesArray.removeAtIndex(index)
            imageAssets.removeAtIndex(index)
            editingImageCollectionView.reloadData()
        }
        
        if imagesArray.count > 0 {
            selectLastImage()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func selectLastImage () {
        if imagesArray.count > 0  {
            selectedIndex = imagesArray.count-1 ;
            editingImageCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: selectedIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
        } else {
            selectedIndex = -1;
        }
        
    }
}

// MARK: UITextFieldDelegate methods..

extension IBImageEditingVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.imagesArray[selectedIndex].imageName = textField.text
        print(textField.text)
    }
    
    func textFieldDidChange(textField: UITextField) {
        self.imagesArray[selectedIndex].imageName = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: UICollectionViewDataSource methods..

extension IBImageEditingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kIBCollectionViewCellIdentifier, forIndexPath: indexPath) as? IBCollectionViewCell
        
        if indexPath.row == imagesArray.count {
            cell!.styleAddButton()
            cell!.collectionImageView.image = nil;
        } else {
            cell!.styleImage()
            let imagedata = self.imagesArray[indexPath.row].image!
            cell!.collectionImageView.image = UIImage(data: imagedata)
            cell?.deleteCallBack = {(sender: UIButton) -> Void in
                self.deleteImage(at: indexPath.row)
            }
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == imagesArray.count {
            self.showSelectionAlert()
        }else{
            selectedIndex = indexPath.row
            let imageModel = self.imagesArray[indexPath.row]
            
            let imageName = imageModel.imageName
            if (!imageName!.isEmpty) {
                self.imageNameTextField.text = imageName
            } else {
                self.imageNameTextField.text = ""
            }
            let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kIBImageEditingCollectionViewCellIdentifier, forIndexPath: indexPath)
            let imageView = cell.viewWithTag(editCellImageViewTag) as! UIImageView
            imageView.image = UIImage(data: imageModel.image!)
            self.selectedImage.image = imageView.image
            imageView.layer.borderWidth = 1.0
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.orangeColor().CGColor
            imageView.clipsToBounds = true
        }
    }
}

// MARK: RMImagePickerControllerDelegate methods..

extension IBImageEditingVC: RMImagePickerControllerDelegate {
    
    func rmImagePickerController(picker: RMImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        if assets.count != 0 {
            imageAssets.appendContentsOf(assets)
        }
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
    func rmImagePickerControllerDidCancel(picker: RMImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
}

// MARK: RNGridMenuDelegate methods..

extension IBImageEditingVC : RNGridMenuDelegate {
    
    func showSelectionAlert() {
        items = [RNGridMenuItem(image: UIImage(named:kIBCameraIconImageName), title:kIBCameraIconImageName),
                 RNGridMenuItem(image: UIImage(named:kIBGalleryIconImageName), title:kIBGalleryIconImageName)]
        let gridItems = RNGridMenu.init(items:items.subarrayWithRange(NSMakeRange(0, numberOfOptions)) )
        gridItems.delegate = self
        gridItems.showInViewController(self, center: CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2))
    }
    
    func gridMenu(gridMenu: RNGridMenu, willDismissWithSelectedItem item: RNGridMenuItem, atIndex itemIndex: Int) {
        if (itemIndex == 0) {
            self.takePhoto()
        } else if (itemIndex == 1) {
            self.presentPhotoLibraryView()
        }
    }
    
    func takePhoto() {
        isGallary = false
        print("ButtonTapped")
        let sourceType:DKImagePickerControllerSourceType = .Camera
        showImagePickerWithAssetType(.AllPhotos, allowMultipleType: true, sourceType: sourceType, allowsLandscape: true, singleSelect: true)
    }
    
    func presentPhotoLibraryView () {
        isGallary = true
        let newpicker =  RMImagePickerController()
        newpicker.pickerDelegate = self
        self.presentViewController(newpicker, animated: true, completion: nil)
    }
}

// MARK: DKImagePickerControllerDelegate methods..

extension IBImageEditingVC : DKImagePickerControllerDelegate {
    
    func dkImagePickerController(picker: DKImagePickerController, didFinishPickingAssets assets: [DKAsset]) {
        for asset in assets {
            self.imageAssets.append(asset.originalAsset!)
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
    
    func dismissPickerPopover() {
        let imageEditingVC:IBImageEditingVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBImageEditingViewControllerIdentifier) as! IBImageEditingVC
        imageEditingVC.imageAssets = self.imageAssets
        self.navigationController!.pushViewController(imageEditingVC , animated: true)
    }
}



