//
//  MapVC.swift
//  Sell4Bids
//
//  Created by admin on 2/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GoogleMaps
class MapVC: UIViewController,GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Printed")
        reverseGeocodeCoordinate(position.target)
    }
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    @IBOutlet weak var lblMapAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        locationManager.delegate = self
        // 4
        
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
       locationManager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
     func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            
            // 3
            //lines
            self.lblMapAddress.text = lines.joined(separator: "\n")
            print("Lines == \(lines.joined(separator: "\n"))")
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - CLLocationManagerDelegate
//1
extension MapVC: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}

