//
//  PlaceDetailViewController.swift
//  MapGoogleAPIDemo
//
//  Created by Minea Chem on 3/13/17.
//  Copyright © 2017 Minea Chem. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class PlaceDetailViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var latitutePlace: UILabel!
    @IBOutlet weak var longtitute: UILabel!
    
    @IBOutlet weak var nameLocation: UILabel!
    
    @IBOutlet weak var descripLocat: UILabel!
    
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var nameLoc: String = ""
    var desc: String = ""
    // An array to hold the list of possible locations.
//    var likelyPlaces: [GMSPlace] = []
//    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latitutePlace.text = ("\(lat)")
        print(lat)
        longtitute.text = ("\(long)")
        print(long)
        nameLocation.text = ("\(nameLoc) ")
        descripLocat.text = ("\(desc)")
        
        
    }
    
   
}
