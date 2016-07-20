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

class IBPlaceListVC: UIViewController,SMSegmentViewDelegate , UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private var locationArray = [IBLocationModel]()
    var segmentView: SMSegmentView!
    var alphaSegmentView: SMBasicSegmentView!
    var margin: CGFloat = 0.0
    let searchBtn = UIButton()
    var isTitleBar : Bool = true
    var allAnnotationPins : Bool = true
    var currentAnnotationPin : Bool = true
    var searchArray = [AnyObject]()
    var tableHeaderView : UIView!
    var helperLocation : HelperLocationManager?
    var tableHeaderViewHeight = CGFloat()
    var userCurrentLocation : CLLocation = CLLocation()
    var titleArray = [IBLocations]()
    var annotationArray = [IBPlaceListAnnotations]()
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var locationSearchController: UISearchController = UISearchController()
    
    @IBOutlet weak var placeListMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewMethods()
        self.navigationBarMethod()
        self.annotationView()
        self.segmentedview()
        self.callPlaceListAPI()
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
    
    deinit{
        if let superView = locationSearchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }
    
    func callPlaceListAPI() {
        let apiObject = IBPlaceListapi()
        APIManager.sharedInstance.makeAPIRequest(apiObject, completionHandler: {(response :Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            IBLocations.saveNearByPlaces(apiObject.nearByPlaceListArray)
            self.annotationView()
        })
    }
    
    
    func annotationView() {
        titleArray = IBLocations.fetchNearByPlaces()!
        for placeModel in titleArray {
            let annotations = IBPlaceListAnnotations(title: placeModel.locationTitle!, coordinate: CLLocationCoordinate2D(latitude: Double(placeModel.latitude!.doubleValue), longitude: Double(placeModel.longitude!.doubleValue)), locationId:placeModel.locationId!, distance: placeModel.locationDistance!)
            [annotationArray.append(annotations)]
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
    }
    
    func addAction() {
        locationSearchController = UISearchController(searchResultsController: nil)
        locationSearchController.hidesNavigationBarDuringPresentation = true
        locationSearchController.dimsBackgroundDuringPresentation = false
        locationSearchController.searchBar.tintColor = UIColor.whiteColor()
        locationSearchController.searchBar.backgroundColor = UIColor.defaultNavigationBarTintColor()
        locationSearchController.searchBar.searchBarStyle = .Minimal
        locationSearchController.searchBar.clipsToBounds = true
        self.locationSearchController.searchBar.delegate = self
        locationSearchController.searchBar.sizeToFit()
        presentViewController(locationSearchController, animated: true, completion: nil)
    }
    
    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.placeListMapView.annotations.count != 0{
            annotation = self.placeListMapView.annotations[0]
            self.placeListMapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.placeListMapView.centerCoordinate = self.pointAnnotation.coordinate
            self.placeListMapView.addAnnotation(self.pinAnnotationView.annotation!)
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
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? MKPinAnnotationView { // 2
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 3
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let imageview = UIImageView(frame: CGRectMake(0, 0, 30, 50))
            imageview.image = UIImage(named: "right-arrow")
            
            let button   = UIButton(type: UIButtonType.Custom) as UIButton
            button.frame = CGRectMake(0, 0, 30, 50)
            button.setImage(imageview.image, forState: .Normal)
            view.rightCalloutAccessoryView = button
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let imagePickerVC:IBPlaceDetailVC = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(kIBPlaceDetailViewControllerIdentifier) as! IBPlaceDetailVC
        self.navigationController?.pushViewController(imagePickerVC, animated: true)
        print("Callout tapped")
    }
    
    func mapViewMethods() {
        self.placeListMapView.delegate = self
        self.getUserCurrentLocation()
    }
    
    // MARK: - Segmented control
    
    func segmentedview() {
        /*
         Init SMsegmentView
         Use a Dictionary here to set its properties.
         Each property has its own default value, so you only need to specify for those you are interested.
         */
        self.placeListMapView.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height - 40)
        let segmentFrame = CGRect(x:0, y: self.view.frame.size.height - 40, width: self.view.frame.size.width, height: 40.0)
        
        self.segmentView = SMSegmentView(frame: segmentFrame, separatorColour: UIColor.defaultNavigationBarTintColor() , separatorWidth: 1, segmentProperties: [keySegmentTitleFont: UIFont.systemFontOfSize(12.0), keySegmentOnSelectionColour: UIColor.defaultNavigationBarTintColor(), keySegmentOffSelectionColour: UIColor.whiteColor(), keyContentVerticalMargin: Float(10.0)])
        
        self.segmentView.delegate = self
        self.segmentView.backgroundColor = UIColor.clearColor()
        self.segmentView.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor
        self.segmentView.layer.borderWidth = 1.0
        
        //        let view = self.segmentView
        // Add segments
        self.segmentView.addSegmentWithTitle("Near By", onSelectionImage: UIImage(named: "Location"), offSelectionImage: UIImage(named: "Location"))
        self.segmentView.addSegmentWithTitle("All Locations", onSelectionImage: UIImage(named: "All Location"), offSelectionImage: UIImage(named: "All Location"))
        self.segmentView.addSegmentWithTitle("Recents", onSelectionImage: UIImage(named: "Recent"), offSelectionImage: UIImage(named: "Recent"))
        self.segmentView.addSegmentWithTitle("Overview", onSelectionImage: UIImage(named: "OverviewIcon"), offSelectionImage: UIImage(named: "OverviewIcon"))
        
        // Set segment with index 0 as selected by default
        segmentView.selectSegmentAtIndex(0)
        self.view.addSubview(self.segmentView)
        
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
