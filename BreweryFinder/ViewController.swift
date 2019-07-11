//
//  ViewController.swift
//  BreweryFinder
//
//  Created by Jason Allen on 7/11/19.
//  Copyright © 2019 Jason Allen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Results: Decodable {
   let breweries:[Brewery]
}
struct Brewery: Decodable {
   let name: String
   let locality: String
   let region: String
   let latitude: Int
   let longitude: Int
   let isPrimary: String
   let inPlanning: String
   let isClosed: String
   let openToPublic: String
   let locationType: String
   let locationTypeDisplay: String
}

class ViewController: UIViewController {
    
   
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // mapView.delegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager .locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know whats up
            break
        case .authorizedAlways:
            break
        }
    }
    
    private func addAnnotations() {
        
        let parthenonAnnotation = MKPointAnnotation()
        parthenonAnnotation.title = "The Parthenon"
        parthenonAnnotation.coordinate = CLLocationCoordinate2D(latitude: 36.1497, longitude: -86.8133)
        
        let vanderbiltAnnotation = MKPointAnnotation()
        vanderbiltAnnotation.title = "Vanderbilt University"
        vanderbiltAnnotation.coordinate = CLLocationCoordinate2D(latitude: 36.1447, longitude: -86.8027)
        
        mapView.addAnnotation(parthenonAnnotation)
        mapView.addAnnotation(vanderbiltAnnotation)
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center:center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        addAnnotations()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MKDelegate Stuff


//extension ViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        }
//
//        if let title = annotation.title, title == "The Parthenon" {
//            annotationView?.image = UIImage(named: "beerPic")
//        } else if let title = annotation.title, title == "Vanderbilt University" {
//            annotationView?.image = UIImage(named: "beerPic")
//        } else if annotation === mapView.userLocation {
//            annotationView?.image = UIImage(named: "personPic")
//        }
//
//        annotationView?.canShowCallout = true
//
//        return annotationView
//    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("The annotation was selected: \(String(describing: view.annotation?.title))")
//    }
//}

