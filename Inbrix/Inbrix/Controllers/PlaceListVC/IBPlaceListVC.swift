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

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:CLLocationCoordinate2D, title:String, locationId:String)
    func didPressSearchBarCancelButton()
}

class IBPlaceListVC: UIViewController, UISearchControllerDelegate {
    var locationSearchController: UISearchController = UISearchController()
    var userCurrentLocation : CLLocation = CLLocation()
    var annotationArray = [IBPlaceListAnnotations]()
    private var locationArray = [IBLocationModel]()
    var selectedPin:CLLocationCoordinate2D? = nil
    var helperLocation : HelperLocationManager?
    var alphaSegmentView: SMBasicSegmentView!
    let locationManager = CLLocationManager()
    var currentAnnotationPin : Bool = true
    var pointAnnotation:MKPointAnnotation!
    var titleArray = [IBLocations]()
    var segmentView: SMSegmentView!
    var isTitleBar : Bool = true
    let searchBtn = UIButton()
    var margin: CGFloat = 0.0
    var error:NSError!
    
    @IBOutlet weak var placeListMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addLeftMenuBarMenuButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeView() {
        self.navigationController?.navigationBarHidden = false
        self.locationSearchController.delegate = self
        self.locationSearchController.searchBar.delegate = self
        self.placeListMapView.delegate = self
        self.getUserCurrentLocation()
        self.customizeNavigationBar()
        self.annotationView()
        self.segmentedview()
        self.callPlaceListAPI()
    }
    
    func addLeftMenuBarMenuButtonItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "Menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
  
    deinit{
        if let superView = locationSearchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }
    
    func customizeNavigationBar() {
        self.title = "NearBy"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor.defaultNavigationBarTintColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        searchBtn.frame = CGRectMake(0, 0, 30, 30)
        searchBtn.setImage(UIImage(named: "SearchWhiteIcon"), forState: .Normal)
        searchBtn.addTarget(self, action: #selector(IBPlaceListVC.addAction), forControlEvents: .TouchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = searchBtn
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func annotationView() {
        titleArray = IBLocations.fetchNearByPlaces()!
        for placeModel in titleArray {
            let annotations = IBPlaceListAnnotations(title: placeModel.locationTitle!, coordinate: CLLocationCoordinate2D(latitude: Double(placeModel.latitude!.doubleValue), longitude: Double(placeModel.longitude!.doubleValue)), locationId:placeModel.locationId!, distance: placeModel.locationDistance!)
            [annotationArray.append(annotations)]
        }
    }
    
    func callPlaceListAPI() {
        let apiObject = IBPlaceListapi()
        APIManager.sharedInstance.makeAPIRequest(apiObject, completionHandler: {(response :Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            IBLocations.saveNearByPlaces(apiObject.nearByPlaceListArray)
            self.annotationView()
        })
    }
    
    func addAction() {
        if isTitleBar == true {
            self.searchBarMethods()
            isTitleBar = false
        } else {
            self.addLabel()
            searchBtn.setImage(UIImage(named: "SearchWhiteIcon"), forState: .Normal)
            isTitleBar = true
        }
    }
    
    func addLabel() {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.navigationItem.titleView!.frame.size.width, self.navigationItem.titleView!.frame.size.height))
        label.text = "NearBy"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    func searchBarMethods() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("IBLocationSearchTable") as! IBLocationSearchTable
        locationSearchController = UISearchController(searchResultsController: locationSearchTable)
        locationSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = locationSearchController.searchBar
        locationSearchController.searchBar.becomeFirstResponder()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = locationSearchController.searchBar
        locationSearchController.hidesNavigationBarDuringPresentation = false
        locationSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = placeListMapView
        locationSearchTable.handleMapSearchDelegate = self
    }
}

extension IBPlaceListVC : UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
}

// MARK: - Location update

extension IBPlaceListVC : MKMapViewDelegate {
    
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
    }
}

// MARK: - Segmented control

extension IBPlaceListVC : SMSegmentViewDelegate {
    
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

extension IBPlaceListVC : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            placeListMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension IBPlaceListVC: HandleMapSearch {
    
    func dropPinZoomIn(placemark:CLLocationCoordinate2D, title:String, locationId:String){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        placeListMapView.removeAnnotations(placeListMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark
        annotation.title = title
        annotation.subtitle = locationId
        placeListMapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(4, 4)
        let region = MKCoordinateRegionMake(placemark, span)
        placeListMapView.setRegion(region, animated: true)
    }
    
    func didPressSearchBarCancelButton(){
        self.locationSearchController.searchBar.hidden = true
        self.addLabel()
        isTitleBar = true
    }
}
