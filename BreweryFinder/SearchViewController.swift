//
//  SearchViewController.swift
//  BreweryFinder
//
//  Created by Jason Allen on 7/18/19.
//  Copyright © 2019 Jason Allen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct results: Decodable {
    let totalResults: Int?
    let data:[Brewery2]
}
struct Brewery2: Decodable {
    let name: String?
    let locality: String?
    let region: String?
    let latitude: Double?
    let longitude: Double?
    let isPrimary: String?
    let inPlanning: String?
    let isClosed: String?
    let openToPublic: String?
    let locationType: String?
    let locationTypeDisplay: String?
}


class SearchViewController: UIViewController {
    
    var searchTextString = "Hi"
    var addressInput:String = "1 infinite Loop, Cupertine, CA 95014"
    var svlat:Double = 0
    var svlong:Double = 0
    //var lat:Double = 0
    //var long:Double = 0
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    
    
    @IBOutlet weak var sMapView: MKMapView!
    @IBOutlet weak var searchText: UILabel!
    
    func getLocation(forPlaceCalled address: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinate:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinate.latitude) -- Long:\(coordinate.longitude)")
                self.svlat = coordinate.latitude
                self.svlong = coordinate.longitude
                print("SVLat: \(self.svlat) -- SVLong:\(self.svlong)")
            }
        })
    }
    
    override func loadView() {
        super.loadView()
        addressInput = searchTextString;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation(forPlaceCalled: searchTextString)
        { placemark in
            if let place = placemark {
                //self.svlat = place.coordinate.latitude
                //self.svlong = place.coordinate.longitude
            }

        }
        checkLocationServices()
        
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
        
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            sMapView.setRegion(region, animated: true)
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
            
            sMapView.showsUserLocation = true
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
        
     func addBreweryAnnotations() {
        
        let apiString = "https://www.brewerydb.com/browse/map/get-breweries?lat=\(svlat)&lng=\(svlong)&radius=25&key=e47292bba0dce5d44ddb5b6e2f3c7672"
        
        guard let url = URL(string:apiString) else
        { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let breweryData = data else {return}
            
            do {
                let bData = try JSONDecoder().decode(results.self, from: breweryData)
                //print(bData)
                DispatchQueue.main.async {
                    for brewSpot in bData.data {
                        let brewAnnotation = MKPointAnnotation()
                        brewAnnotation.title = brewSpot.name
                        brewAnnotation.coordinate = CLLocationCoordinate2D(latitude: brewSpot.latitude!, longitude: brewSpot.longitude!)
                        self.sMapView.addAnnotation(brewAnnotation)
                        print(brewSpot.name)
                    }
                    self.searchText.text = bData.totalResults == 1 ? "You have \(bData.totalResults!) brewery" : "You have \(bData.totalResults!) breweries"
                }
            } catch let jsonErr {
                print("You've got the following jsonError \(jsonErr)")
            }
            }.resume()
        
    }
        
        
        
        //searchText.text = searchTextString
        
        //@IBAction func searchByAddress(_ sender: Any) {
            
        //}
        
        
        

        // Do any additional setup after loading the view.

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchViewController: CLLocationManagerDelegate {
    
//    private func addBreweryAnnotations() {
//
//        let apiString = "https://www.brewerydb.com/browse/map/get-breweries?lat=\(svlat)&lng=\(svlong)&radius=25&key=e47292bba0dce5d44ddb5b6e2f3c7672"
//
//        guard let url = URL(string:apiString) else
//        { return }
//
//        URLSession.shared.dataTask(with: url){(data, response, error) in
//            guard let breweryData = data else {return}
//
//            do {
//                let bData = try JSONDecoder().decode(results.self, from: breweryData)
//                //print(bData)
//                DispatchQueue.main.async {
//                    for brewSpot in bData.data {
//                        let brewAnnotation = MKPointAnnotation()
//                        brewAnnotation.title = brewSpot.name
//                        brewAnnotation.coordinate = CLLocationCoordinate2D(latitude: brewSpot.latitude, longitude: brewSpot.longitude)
//                        self.mapView.addAnnotation(brewAnnotation)
//                        print(brewSpot.name)
//                    }
//                    self.searchText.text = bData.totalResults == 1 ? "You have \(String(bData.totalResults)) brewery" : "You have \(String(bData.totalResults)) breweries"
//
//                }
//            } catch let jsonErr {
//                print("You've got the following jsonError \(jsonErr)")
//            }
//            }.resume()
//
//    }
//
//    func centerViewOnUserLocation() {
//        if let location = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//            mapView.setRegion(region, animated: true)
//        }
//    }
//
//    func checkLocationAuthorization() {
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedWhenInUse:
//            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
//            locationManager.startUpdatingLocation()
//            break
//        case .denied:
//            // Show alert instructing them how to turn on permissions
//            break
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            // Show an alert letting them know whats up
//            break
//        case .authorizedAlways:
//            break
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: svlat, longitude: svlong)
        //lat = center.latitude
        //long = center.longitude
        
        //lat = svlat
        //long = svlong
        
        print("Location Manager Lat: \(svlat) -- Long:\(svlong)")
        let region = MKCoordinateRegion.init(center:center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        sMapView.setRegion(region, animated: true)
        addBreweryAnnotations()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


