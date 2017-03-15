//
//  ViewController.swift
//  MapGoogleAPIDemo
//
//  Created by Minea Chem on 3/10/17.
//  Copyright © 2017 Minea Chem. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController,GMSMapViewDelegate{
    
//Declare the location manager, current location, map view, places client, and default zoom level at the class level
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 17.0
    
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // Update the map once the user has made their selection.
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()
        
        // Add a marker to the map.
        if selectedPlace != nil {
            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
            marker.title = selectedPlace?.name
            marker.snippet = selectedPlace?.formattedAddress
            marker.map = mapView
        }
        
        listLikelyPlaces()
    }   
       //11.537513, 104.886385
    let camara = GMSCameraPosition.camera(withLatitude: 11.537513, longitude: 104.886385, zoom: 15.0)
    
    // Update the map once the user has made their selection.
        override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        
        DispatchQueue.main.async {
            
            self.locationManager.startUpdatingLocation()
        }

        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        // Create a map
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camara)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.mapType = kGMSTypeTerrain
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.setMinZoom(10, maxZoom: 30)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
       mapView.delegate = self
        // add the map to the view , hide it until we've got a location update.
        view.addSubview(mapView)
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
       performSegue(withIdentifier: "locationdetail", sender: self)
    
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationdetail"{
            if let placeDetail = segue.destination as? PlaceDetailViewController {
                
                let lat:CLLocationDegrees = 11.537513
                let long:CLLocationDegrees = 104.886385
                let markerLocal = GMSMarker()
                markerLocal.title = "my location"
                markerLocal.snippet = "Im here!"
                
                placeDetail.lat = lat
                placeDetail.long = long
                placeDetail.nameLoc = markerLocal.title!
                placeDetail.desc = markerLocal.snippet!
             
            }
        }
    }
    
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
  
  }

extension ViewController: CLLocationManagerDelegate {
    // Handle incoming location events.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last!
        print("Location: \(currentLocation)")
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude,zoom: zoomLevel)
        
        let markerLocal = GMSMarker()
        markerLocal.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        markerLocal.title = "my location"
        print("mylocation \(markerLocal)")
        markerLocal.snippet = "Im here!"
        markerLocal.icon = UIImage(named: "pin-2")
        markerLocal.map = mapView
      mapView.isMyLocationEnabled = true
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
            
        }else {
            
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    
}

