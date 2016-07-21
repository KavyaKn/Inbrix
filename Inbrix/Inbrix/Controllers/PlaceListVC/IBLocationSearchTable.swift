//
//  IBLocationSearchTable.swift
//  Inbrix
//
//  Created by Kavya on 21/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import MapKit

class IBLocationSearchTable: UITableViewController {

    var handleMapSearchDelegate:HandleMapSearch? = nil
    var titleArray = [IBLocations]()
    var searchArray = [IBLocations]()
    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        titleArray = IBLocations.fetchNearByPlaces()!
        print(titleArray)
    }
}

extension IBLocationSearchTable : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.active {
            searchArray.removeAll(keepCapacity: false)
            
            let array = titleArray.filter {
                $0.locationTitle!.rangeOfString(searchController.searchBar.text!) != nil
            }
            searchArray = array
        } else {
            if handleMapSearchDelegate != nil {
                handleMapSearchDelegate?.didPressSearchBarCancelButton()
            }
            print("Not Active")
        }
    }
}

extension IBLocationSearchTable {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let annotationObject: IBLocations = titleArray[indexPath.row]
        cell.textLabel?.text! = annotationObject.locationTitle!
        cell.detailTextLabel!.text = annotationObject.locationId!
        return cell
    }
}

extension IBLocationSearchTable {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = titleArray[indexPath.row]
        let coordinate = CLLocationCoordinate2D(latitude: Double(selectedItem.latitude!.doubleValue), longitude: Double(selectedItem.longitude!.doubleValue))
        handleMapSearchDelegate?.dropPinZoomIn(coordinate, title: selectedItem.locationTitle!, locationId: selectedItem.locationId!)
        dismissViewControllerAnimated(true, completion: nil)
    }
}