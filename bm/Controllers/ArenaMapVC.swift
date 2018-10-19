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

class ArenaMapVC: MyMapVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var address: String = ""
    var annotationTitle: String = ""
    
    override func viewDidLoad() {
        myMapView = mapView
        myTitleLbl = titleLbl
        myTitle = annotationTitle
        super.viewDidLoad()

        //print(address)
        getCoordinateFromAddress(address) { (success) in
            if success {
                let location = CLLocationCoordinate2DMake(self.lat!, self.lng!)
                self.centerMapOnLocation(location: location)
                self.addAnnotation(location: location, title: self.annotationTitle)
            } else {
                self.warning(self.msg)
            }
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}

