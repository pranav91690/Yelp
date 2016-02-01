//
//  MapViewController.swift
//  Yelp
//
//  Created by Pranav Achanta on 1/31/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {    
    // To Get hold the info transferred from the List View controller
    var businesses : [Business]!
    
    @IBAction func onClickList(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Location
    var location : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Map View to the Location
        goToLocation(location)
        
        // Set the Annonatation Points for all the businesses
        for business in businesses{
            addAnnotationAtCoordinate(business)
        }
    }

    func goToLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Function to add the Annotation Point
    func addAnnotationAtCoordinate(business : Business) {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(business.latitude!), longitude: CLLocationDegrees(business.longitude!))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business.name!
        mapView.addAnnotation(annotation)
    }
    
    // Annotation View Code
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        if #available(iOS 9.0, *) {
            annotationView!.pinTintColor = UIColor.greenColor()
        } else {
            // Fallback on earlier versions
        }
        
        return annotationView
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
