//
//  ViewController.swift
//  Assignment 7
//
//  Created by user240738 on 3/13/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    let locationManager: CLLocationManager = CLLocationManager()
        var tripStartDate: Date?
        var tripDistance: CLLocationDistance = 0
        var maxSpeed: CLLocationSpeed = 0
        var totalSpeed: CLLocationSpeed = 0
        var maxAcceleration: Double = 0
        var previousSpeed: CLLocationSpeed = 0
        var previousLocation: CLLocation?
        let speedLimit: CLLocationSpeed = 115 / 3.6 // convert km/h to m/s
    let barColor = UIColor(red: 0/255.0, green: 216/255.0, blue: 0/255.0, alpha: 1.0)
    

    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBOutlet weak var maxSpeedLabel: UILabel!
    
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var maxAccelerationLabel: UILabel!
    
    @IBOutlet weak var topBarView: UIView!
    
    @IBAction func startTripButton(_ sender: Any) {
        bottomBarView.backgroundColor = barColor
        locationManager.startUpdatingLocation()
        tripStartDate = Date()
    }
    
    
    @IBOutlet weak var bottomBarView: UIView!
    
    @IBAction func stopTrip(_ sender: Any) {
        currentSpeedLabel.text = "0"
        locationManager.stopUpdatingLocation()
        bottomBarView.backgroundColor = UIColor.gray
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topBarView.isHidden = true
        locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            
            let speed = location.speed
            currentSpeedLabel.text = "\(speed * 3.6) km/h"
        
       
            if speed > maxSpeed {
                maxSpeed = speed
                maxSpeedLabel.text = "\(maxSpeed * 3.6) km/h"
            }
            
            if let previousLocation = previousLocation {
                let distance = location.distance(from: previousLocation)
                tripDistance += distance
                distanceLabel.text = "\(tripDistance/1000) km"
                
                let timeDifference = location.timestamp.timeIntervalSince(previousLocation.timestamp)
                let acceleration = abs((speed - previousSpeed) / timeDifference)
                
                if acceleration > maxAcceleration {
                    maxAcceleration = acceleration
                    maxAccelerationLabel.text = "\(maxAcceleration) m/s^2"
                }
                
                totalSpeed += speed
                let averageSpeed = totalSpeed / Double(locations.count)
                averageSpeedLabel.text = "\(averageSpeed * 3.6) km/h"
            }
            
            if speed > speedLimit {
                topBarView.isHidden = false
                
            }
            
            updateMapLocation(location: location)
            
            previousLocation = location
            previousSpeed = speed
        }
        
        func updateMapLocation(location: CLLocation) {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }


}

