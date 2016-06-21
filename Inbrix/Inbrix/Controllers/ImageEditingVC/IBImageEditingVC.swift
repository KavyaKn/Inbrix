//
//  IBImageEditingVC.swift
//  InbrixImageSample
//
//  Created by Kavya on 12/04/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import Photos

let editCellSize = CGSize(width: 80, height: 80)
var editCellImageViewTag : Int = 10

class IBImageEditingVC: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagedescriptin: UITextView!
    @IBOutlet weak var imageNameTextField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var editingImageCollectionView: UICollectionView!
    lazy var imageManager = PHImageManager.defaultManager()
    var gallaryAssets: [PHAsset] = []
    var cameraAssets: [DKAsset] = []
    var selectedImageModel: [String: AnyObject] = [:]
    var selectedIndex = 0
    var imagesArray : [[String: AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageNameTextField.addTarget(self, action: #selector(IBImageEditingVC.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.imageNameTextField.delegate = self
        self.navigationController?.navigationBarHidden = true
        self.storingInDictionary()
    }
    
    func storingInDictionary(){
        if (self.gallaryAssets.count != 0) {
            for (_, asset) in self.gallaryAssets.enumerate() {
                self.loadImageFromAssets(asset)
            }
        }
        
        if (self.cameraAssets.count != 0) {
            for (_, asset) in self.cameraAssets.enumerate() {
                self.loadImageFromAssets(asset.originalAsset!)
            }
        }
    }
    
    func loadImageFromAssets(asset : PHAsset)  {
        self.imageManager.requestImageDataForAsset(asset, options: nil, resultHandler: { (data: NSData?, dataStrig: String?, imageOrirntation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
            var dic: [String: AnyObject] = [:]
            dic["imageName"] = ""
            dic["imageId"] = NSProcessInfo.processInfo().globallyUniqueString
            dic["imageAddedTime"] = NSDate()
            dic["image"] = asset
            dic["imageData"] = data
            self.imagesArray.append(dic)
            self.editingImageCollectionView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kIBImageEditingCollectionViewCellIdentifier, forIndexPath: indexPath)
        let imagedata = self.imagesArray[indexPath.row]["imageData"] as! NSData
        let imageView = cell.viewWithTag(editCellImageViewTag) as! UIImageView
        imageView.image = UIImage(data: imagedata)
        self.selectedImage.image = imageView.image
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.orangeColor().CGColor
        imageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        selectedImageModel = self.imagesArray[indexPath.row]
        let imageName = selectedImageModel["imageName"] as! String
        if (!imageName.isEmpty) {
            self.imageNameTextField.text = imageName
        } else {
            self.imageNameTextField.text = ""
        }
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kIBImageEditingCollectionViewCellIdentifier, forIndexPath: indexPath)
        let imagedata = self.imagesArray[indexPath.row]["imageData"] as! NSData
        let imageView = cell.viewWithTag(editCellImageViewTag) as! UIImageView
        imageView.image = UIImage(data: imagedata)
        self.selectedImage.image = imageView.image
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.orangeColor().CGColor
        imageView.clipsToBounds = true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        self.imagesArray[selectedIndex]["imageName"] = textField.text
        print(textField.text)
    }
    
    func textFieldDidChange(textField: UITextField) {
        self.imagesArray[selectedIndex]["imageName"] = textField.text
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        CoreDataManager().saveImages(self.imagesArray)
        print(self.imagesArray.count)
        let imagePickerVC:IBPlaceDetailVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBPlaceDetailViewControllerIdentifier) as! IBPlaceDetailVC
        self.navigationController?.pushViewController(imagePickerVC, animated: true)
    }
    
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
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
