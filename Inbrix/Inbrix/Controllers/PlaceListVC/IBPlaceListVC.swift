//
//  IBPlaceListVC.swift
//  Inbrix
//
//  Created by Kavya on 08/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class IBPlaceListVC: AEAccordionTableViewController, SMSegmentViewDelegate, UISearchResultsUpdating, MKMapViewDelegate, CLLocationManagerDelegate {

    private var locationArray = [IBLocationModel]()
    
    var segmentView: SMSegmentView!
    var alphaSegmentView: SMBasicSegmentView!
    var margin: CGFloat = 0.0
    let searchBtn = UIButton()
    var isTitleBar : Bool = true
    var allAnnotationPins : Bool = true
    var currentAnnotationPin : Bool = true
    var searchArray = [AnyObject]()
    var placeListMapView : MKMapView?
    var tableHeaderView : UIView!
    var helperLocation : HelperLocationManager?
    var tableHeaderViewHeight = CGFloat()
    var userCurrentLocation : CLLocation = CLLocation()
    var annotationArray = [IBPlaceListAnnotations]()
    

    @IBOutlet var placelistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerViewMethods()
        self.mapViewMethods()
        self.navigationBarMethod()
        self.initializeView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addLeftMenuBarMenuButtonItem()
    }
    
    func addLeftMenuBarMenuButtonItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "Menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    deinit{
//        if let superView = locationSearchController.view.superview
//        {
//            superView.removeFromSuperview()
//        }
//    }
    
    func headerViewMethods(){
        // Set the table views header cell and delegate
        tableHeaderViewHeight = self.view.frame.height / 2
        placeListMapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, tableHeaderViewHeight))
        placeListMapView!.delegate = self
        placeListMapView!.showsUserLocation = true
        tableHeaderView = ParallaxTableHeaderView(size: CGSizeMake(self.view.frame.width, tableHeaderViewHeight), subView: placeListMapView!)
        tableView.tableHeaderView = tableHeaderView
        tableView.delegate = self
        tableView.dataSource = self
        title = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String
        registerCell()
//        expandFirstCell()
    }
    
    func initializeView() {
        let titleArray = ["Agra", "Ahemadabad", "Allahabad", "Andhra Pradesh", "Arunachal Pradesh","Maharashtra","Bangalore", "Karnataka", "Kolar"]
        var distanceArray = ["10.0m", "20.0m", "30.0m", "40.0m", "50.0m", "60", "70", "80", "90"]
        var latitudeArray = [ 27.17, 23.00, 25.25,  18.00,  28.00, 19.50, 12.59, 13.15, 13.12]
        var longitudeArray = [77.58,72.40, 81.58, 79.00, 95.00, 75.03, 77.40, 77.00, 78.15]
        for (index, value) in titleArray.enumerate() {
            let annotations = IBPlaceListAnnotations(title: value, coordinate: CLLocationCoordinate2D(latitude: latitudeArray[index], longitude: longitudeArray[index]), distance: distanceArray[index])
            annotationArray .append(annotations)
            
            let locationModel = IBLocationModel(locationName: value, locationId: "\(index)", locationNumber:"\(index)")
            locationArray.append(locationModel)
        }
        
    }
    
    func navigationBarMethod() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.defaultNavigationBarTintColor()
        self.navigationItem.hidesBackButton = true
        self.title = "NearBy"
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        searchBtn.setImage(UIImage(named: "SearchWhiteIcon"), forState: .Normal)
        searchBtn.frame = CGRectMake(0, 0, 30, 30)
        searchBtn.addTarget(self, action: #selector(IBPlaceListVC.addAction), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = searchBtn
        self.navigationItem.rightBarButtonItem = rightBarButton
        locationSearchController.searchResultsUpdater = self
    }
    
    func addAction() {
        
        if isTitleBar == true {
            self.navigationItem.titleView = locationSearchController.searchBar
            self.locationSearchController.searchBar.becomeFirstResponder()
            searchBtn.setImage(UIImage(named: "SearchGrayIcon"), forState: .Normal)
            isTitleBar = false
        } else {
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.navigationItem.titleView!.frame.size.width, self.navigationItem.titleView!.frame.size.height))
            label.text = "NearBy"
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            self.navigationItem.titleView = label
            
            searchBtn.setImage(UIImage(named: "SearchWhiteIcon"), forState: .Normal)
            isTitleBar = true
        }
    }
    
    // MARK: - Location update
    
    func getUserCurrentLocation() {
        
        self.placeListMapView!.showsUserLocation = true
        helperLocation = HelperLocationManager()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IBPlaceListVC.getCurrentAddressToViewController(_:)), name: "sendCurrentAddressToViewController", object: nil)
    }
    
    func getCurrentAddressToViewController(notification: NSNotification) {
        
        userCurrentLocation = (notification.object as? CLLocation)!
        let region = MKCoordinateRegion(center: userCurrentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta:0.5, longitudeDelta:0.5))
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "sendCurrentAddressToViewController", object: nil)
        if currentAnnotationPin == true {
            let thepoint = MKPointAnnotation()
            thepoint.coordinate = userCurrentLocation.coordinate
            thepoint.title = "Current Location"
            placeListMapView!.addAnnotation(thepoint)
            currentAnnotationPin = false
        }
        placeListMapView!.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            if (allAnnotationPins == false) {
                if #available(iOS 9.0, *) {
                    pinView!.pinTintColor = UIColor.orangeColor()
                } else {
                    // Fallback on earlier versions
                }
            }  else {
                if #available(iOS 9.0, *) {
                    pinView!.pinTintColor = UIColor.redColor()
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapViewMethods() {
        self.getUserCurrentLocation()
    }
    
// MARK: -Search controller Delegate
      var locationSearchController: UISearchController = ({
        
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.searchBarStyle = .Minimal
        controller.searchBar.tintColor = UIColor.whiteColor()
        controller.searchBar.layer.cornerRadius = 10
        controller.searchBar.clipsToBounds = true
        controller.searchBar.sizeToFit()
        return controller
    })()
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchArray.removeAll(keepCapacity: false)
        
        let array = locationArray.filter {
            $0.locationName!.rangeOfString(searchController.searchBar.text!) != nil
        }
        searchArray = array
        self.placelistTableView.reloadData()

    }
    
    // MARK: - Helpers
    
    func registerCell() {
        let cellNib = UINib(nibName:kIBCustomTableViewCellNibName , bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: kIBCustomTableViewCellNibName)
    }
    
    func expandFirstCell() {
        let firstCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        expandedIndexPaths.append(firstCellIndexPath)
    }
    
    
    /**
     Layout header content when table view scrolls
     */
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxTableHeaderView = self.tableView.tableHeaderView as! ParallaxTableHeaderView
        header.layoutForContentOffset(tableView.contentOffset)
        self.tableView.tableHeaderView = header
    }
}

// MARK: - UITableViewDataSource
extension IBPlaceListVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        /*
         Init SMsegmentView
         Use a Dictionary here to set its properties.
         Each property has its own default value, so you only need to specify for those you are interested.
         */
        let segmentFrame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin * 2, height: 50.0)
        
        self.segmentView = SMSegmentView(frame: segmentFrame, separatorColour: UIColor.defaultNavigationBarTintColor() , separatorWidth: 1, segmentProperties: [keySegmentTitleFont: UIFont.systemFontOfSize(12.0), keySegmentOnSelectionColour: UIColor.defaultNavigationBarTintColor(), keySegmentOffSelectionColour: UIColor.whiteColor(), keyContentVerticalMargin: Float(10.0)])
        
        self.segmentView.delegate = self
        self.segmentView.backgroundColor = UIColor.clearColor()
        self.segmentView.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor
        self.segmentView.layer.borderWidth = 1.0
        
        let view = self.segmentView
        // Add segments
        view.addSegmentWithTitle("Near By", onSelectionImage: UIImage(named: "Location"), offSelectionImage: UIImage(named: "Location"))
        view.addSegmentWithTitle("All Locations", onSelectionImage: UIImage(named: "All Location"), offSelectionImage: UIImage(named: "All Location"))
        view.addSegmentWithTitle("Recents", onSelectionImage: UIImage(named: "Recent"), offSelectionImage: UIImage(named: "Recent"))
        view.addSegmentWithTitle("Overview", onSelectionImage: UIImage(named: "OverviewIcon"), offSelectionImage: UIImage(named: "OverviewIcon"))
        
        // Set segment with index 0 as selected by default
        segmentView.selectSegmentAtIndex(0)
        //        self.view.addSubview(view)
        
        return view
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch locationSearchController.active {
        case true:
            return searchArray.count
        case false:
            return locationArray.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 40.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kIBCustomTableViewCellNibName, forIndexPath: indexPath) as! CustomTableViewCell
        
        switch locationSearchController.active {
        case true:
            let locationModel = searchArray[indexPath.row]
            cell.headerView.locationLabel.text = locationModel.locationName
        case false:
            let locationModel = locationArray[indexPath.row]
            cell.headerView.locationLabel.text = locationModel.locationName
        }
        cell.detailView.nameLabel.text = "Kavya"
        cell.detailView.idLabel.text = "282"
        cell.detailView.emailLabel.text = "kavya.kn@tarento.com"
        cell.detailView.addressLabel.text = "Bangalore"
        cell.headerView.customizeView()
        cell.detailView.customizeCell()
        cell.detailView.detailButton.addTarget(self, action: #selector(IBPlaceListVC.detailViewClicked), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    func detailViewClicked() {
        print("Push To detail view")
        self.performSegueWithIdentifier("LocationDetailSegue", sender: nil)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("IBPlaceDetailVC") as! IBPlaceDetailVC
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
// MARK: -SMSegment Delegate
    func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        switch (index) {
        case 0:
            NSLog("First was selected");
            placeListMapView!.removeAnnotations(annotationArray)
            self.placeListMapView!.showsUserLocation = true
            getUserCurrentLocation()
            break;
        case 1:
            NSLog("Second was selected");
            placeListMapView!.addAnnotations(annotationArray)
            break;
        case 2:
            NSLog("Third was selected");
            placeListMapView!.removeAnnotations(annotationArray)
            self.placeListMapView!.showsUserLocation = true
            break;
        default:
            break;
        }
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        /*
         MARK: Replace the following line to your own frame setting for segmentView.
         */
        if toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight {
            self.segmentView.vertical = true
            self.segmentView.segmentVerticalMargin = 25.0
            self.segmentView.frame = CGRect(x: self.view.frame.size.width/2 - 40.0, y: 100.0, width: 80.0, height: 220.0)
            
            self.alphaSegmentView.vertical = true
            self.alphaSegmentView.frame = CGRect(x:  self.view.frame.size.width/2 + 60.0, y: 100.0, width: 80 , height: 220.0)
        }
        else {
            self.segmentView.vertical = false
            self.segmentView.segmentVerticalMargin = 10.0
            self.segmentView.frame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
            
            self.alphaSegmentView.vertical = false
            self.alphaSegmentView.frame = CGRect(x: self.margin, y: 200.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
        }
    }
}
