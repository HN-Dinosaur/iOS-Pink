//
//  SearchLocationVC-Config.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/13.
//
import CoreLocation
import MJRefresh
extension SearchLocationVC{
    func config(){
        //定位
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 5
        locationManager.reGeocodeTimeout = 5
        
        POITableVIew.mj_footer = footer
        if let cancelBtn = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelBtn.isEnabled = true
        }
    }
}
