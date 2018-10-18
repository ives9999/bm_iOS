//
//  MapVC.swift
//  bm
//
//  Created by ives on 2018/10/16.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: BaseViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var address: String = ""
    var annotationTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = annotationTitle
        mapView.delegate = self

        //print(address)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let location = placemarks?.first?.location
                else {
                    return
            }
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            //print(lat)
            //print(lng)
            let initialLocation = CLLocationCoordinate2DMake(lat, lng)
            self.centerMapOnLocation(location: initialLocation)
            self.addAnnotation(location: initialLocation, title: self.annotationTitle)
            
            
            //self.centerMapOnLocation(location: initialLocation)
            // show artwork on map
//            let artwork = Artwork(title: self.annotationTitle,
//                                  locationName: self.annotationTitle,
//                                  discipline: "Sculpture",
//                                  coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            //self.mapView.addAnnotation(artwork)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, title: String, subTitle: String="") {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        if subTitle.count > 0 {
            annotation.subtitle = subTitle
        }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        annotationView?.image = UIImage(named: "marker")
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print("aaa")
    }
}

//class ArtworkView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let artwork = newValue as? Artwork else {return}
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
//            if let imageName = artwork.imageName {
//                image = UIImage(named: imageName)
//            } else {
//                image = nil
//            }
//        }
//    }
//}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
