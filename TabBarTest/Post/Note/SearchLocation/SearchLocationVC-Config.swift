//
//  SearchLocationVC-Config.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/13.
//
import CoreLocation
extension SearchLocationVC{
    func config(){
        //定位
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 5
        locationManager.reGeocodeTimeout = 5
    }
}
