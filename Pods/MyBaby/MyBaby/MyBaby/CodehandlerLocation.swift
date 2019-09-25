//
//  CodehandlerLocation.swift
//  MyBaby
//
//  Created by Pawan Kumar on 13/07/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

public protocol LocationDelegateMB {
    func locationUpdateFetch(latitude : Double,longitude : Double)
}

public class CodeHandlerLocation : NSObject,CLLocationManagerDelegate{

    var locationManager: CLLocationManager?
    var ControllerGet : UIViewController? = nil

    public func StartLocationFetch(Controller : UIViewController){

        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        ControllerGet = Controller
        if CLLocationManager.locationServicesEnabled()
        {

            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
  
        }
      
    }

   public func StopLocationFetch(){
        locationManager?.delegate = nil
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let Delegate : LocationDelegateMB? = ControllerGet as? LocationDelegateMB
        Delegate?.locationUpdateFetch(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }

}





