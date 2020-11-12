//
//  MapVC.swift
//  bm
//
//  Created by ives on 2018/10/18.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import MapKit

class MyMapVC: BaseViewController, MKMapViewDelegate {
    
    internal var myMapView: MKMapView!
    var myTitleLbl: UILabel!
    var myTitle: String = ""
    
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTitleLbl.text = myTitle
        myMapView.delegate = self
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, title: String, subTitle: String="") {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        if subTitle.count > 0 {
            annotation.subtitle = subTitle
        }
        myMapView.addAnnotation(annotation)
        myMapView.selectAnnotation(annotation, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegion(center: location, span: span)
        myMapView.setRegion(region, animated: true)
    }
    
    func getCoordinateFromAddress(_ address: String, completion: @escaping CompletionHandler) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let location = placemarks?.first?.location
                else {
                    self.msg = "無法取得轉址服務"
                    completion(false)
                    return
            }
            self.lat = location.coordinate.latitude
            self.lng = location.coordinate.longitude
            //print(lat)
            //print(lng)
            completion(true)
        }
    }
    
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
