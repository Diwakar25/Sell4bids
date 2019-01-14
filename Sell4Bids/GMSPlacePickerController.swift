//
//  MapPickerVC.swift
//  Sell4Bids
//
//  Created by admin on 2/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps

class GMSPlacePickerController: UIViewController {
  
  //MARK:- Properties
  
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet weak var viewGMSMap: GMSMapView!
  private let locationManager = CLLocationManager()
  var flagPermissionGranted = false
  var usersLocation : CLLocation?
  @IBOutlet weak var btnSelectAgain: UIButton!
  @IBOutlet weak var btnShareLocation: UIButton!
  var orderData: OrderModel?
  //MARK:- View life cycle
  weak var placePickerDelegate : GMSPlacePickerContProtocol!
  var userPickedThePlace : GMSPlace?
  override func viewDidLoad() {
    
    super.viewDidLoad()
    locationManager.delegate = self
    
    //check location auth status
    
    let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    if status == .denied || status == .restricted || status == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
    else if status == .authorizedWhenInUse {
      //get users location
      flagPermissionGranted = true
      locationManager.startUpdatingLocation()
      
    }
    setupViews()
    viewGMSMap.isMyLocationEnabled = true
    viewGMSMap.settings.myLocationButton = true
   
    // Do any additional setup after loading the view.
  }

  private func setupViews() {
    self.btnSelectAgain.addShadowAndRound()
    self.btnShareLocation.addShadowAndRound()
  }
  //MARK:- Private functions
  private func presentPlacePickerVC(location: CLLocation?) {
    var bounds = GMSCoordinateBounds()
    if let location = location {
      //bounds.
      print("using users location on place picker view controller")
      let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      let viewport = GMSCoordinateBounds(coordinate: center, coordinate: center)
      bounds = viewport
      
    }else {
      //we have not users location so use default
      print("Could not get users location because not permission. so present a place picker with hard coded location")
      let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
      let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
      //let northEas = CLLocationCoordinate2D(
      let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
      
      let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
      bounds = viewport
    }
    
    let gmsPlaceConfig = GMSPlacePickerConfig.init(viewport: bounds)
    let placePickerVC = GMSPlacePickerViewController(config: gmsPlaceConfig)
    placePickerVC.delegate = self
    self.present(placePickerVC, animated: false, completion: nil)
  }
  //MARK:- IBActions and user interaction
  
  @IBAction func btnSelectAgainTapped(_ sender: UIButton) {
    presentPlacePickerVC(location: usersLocation)
    
    
  }
  @IBAction func btnShareLocationTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Sharing Location", message: "Are you sure you want to share your location with Buyer", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (actionShareLocation) in
      //take the address and lat, long and store in
      //store location for this order
      self.saveLocationForThisOrder()
      
    }))
    alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
    self.present(alert, animated: true) {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  private func saveLocationForThisOrder() {
    guard let orderData = orderData else {
      print("guard let orderData = orderData failed in self. Going to return")
      self.alert(message: "Sorry, Could not share your location becuase your order data is not in correct format.")
      return
    }
    guard let place = userPickedThePlace else {
      print("guard let place = userPickedThePlace failed in \(self)")
      self.alert(message: "Sorry, could not share location with buyer. Please select a place to share.")
      return
    }
    
    placePickerDelegate.saveOrderDataInDB(orderData: orderData, place: place)
    self.navigationController?.popViewController(animated: true)
    
  }
  
}

protocol GMSPlacePickerContProtocol : class {
  func saveOrderDataInDB(orderData: OrderModel, place: GMSPlace)
}

extension GMSPlacePickerController: CLLocationManagerDelegate {
  // 2
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    guard status == .authorizedWhenInUse else {
      self.flagPermissionGranted = false
      //show map with hard coded location
      presentPlacePickerVC(location: usersLocation)
      return
    }
    // 4
    self.flagPermissionGranted = true
    locationManager.startUpdatingLocation()
    
    
    //5
    //mapView.isMyLocationEnabled = true
    //mapView.settings.myLocationButton = true
  }
  

  
  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    
    usersLocation = location
    //present a placePickerViewController with location set as users Location
    presentPlacePickerVC(location: location)
    locationManager.stopUpdatingLocation()
  }
}

extension GMSPlacePickerController: GMSPlacePickerViewControllerDelegate {
  
  func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
    print("did pick a place")
    self.userPickedThePlace = place
    //place.name
    if let address = place.formattedAddress {
      self.addressLabel.text = address
    }
    
    viewGMSMap.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    viewGMSMap.isMyLocationEnabled = true
    viewGMSMap.settings.compassButton = true
    viewGMSMap.settings.myLocationButton = true
    let marker = GMSMarker(position: place.coordinate)
    marker.title = place.formattedAddress
    marker.map = viewGMSMap
    self.dismiss(animated: true, completion: nil)
    
  }
  func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
    print("GMSPlacePickerViewController did fail with error")
    self.alert(message: "Sorry, we could not pick a place. ")
    
  }
  func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
    print("GMSPlacePickerViewController did cancel")
    self.dismiss(animated: true, completion: nil)
    
  }
  
  
}
