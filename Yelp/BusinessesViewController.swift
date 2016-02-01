//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate, CLLocationManagerDelegate{

    var businesses: [Business]!
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
    
    // Define a Search Controller
    var searchController: UISearchController!
    
    // Define an Offset value for getting more data
    var offset = 0
    
    // Current Search term
    var currentSearchterm = "Restaurants"
    
    // InfiniteScrollActivity View
    var loadingMoreView:InfiniteScrollActivityView?
    
    // Variable to Store the Current Location
    var currentLocation: CLLocationCoordinate2D!
    
    var locationAlreadySet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizing the Navigation Bar Properties
        if let navigationBar = navigationController?.navigationBar{
            navigationBar.barStyle = UIBarStyle.Black
        }
        
        // Add the Infinite Activty Indicator View
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        // Customizing the Navigation Item for this View Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = currentSearchterm
        searchController.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
        // Setting the Table View Properties
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        // Get the Location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()

        
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Location Manager Specific Methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    // Location Manager Service
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Try to Do Something here
        if let location = locations.first {
            if(!locationAlreadySet){
                locationAlreadySet = true
                currentLocation = location.coordinate
                loadData(currentSearchterm)
            }

        }
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Error while updating location " + error.localizedDescription)
    }

    
    // Table View Specific Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
    // Methods to Handle Search Functionality
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // TODO - No Real TIme Updating here!!
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        //TODO
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            currentSearchterm = searchText
            searchController.searchBar.placeholder = currentSearchterm
            loadData(searchText)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loadData(searchText : String){
        Business.searchWithTerm(searchText, offset : 0, location: currentLocation, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }
    
    func loadMoreData(){
        offset += 20
        print(offset)
        Business.searchWithTerm(currentSearchterm, offset : offset, location: currentLocation, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            self.businesses.appendContentsOf(businesses)
            self.tableView.reloadData()
        })
    }
    
    
    // To Handle the Infinite Scrolling Feature
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                // Update the Flag
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Get the Next Screen -- Do something based on the screen
        if let identifier = segue.identifier{
            if(identifier == "mapView"){
                let mapViewNavController = segue.destinationViewController as! UINavigationController
                let viewControllers = mapViewNavController.viewControllers
                let mapViewController = viewControllers[0] as! MapViewController
                mapViewController.location = currentLocation
                mapViewController.businesses = businesses
            }
        }
        
    }


}
