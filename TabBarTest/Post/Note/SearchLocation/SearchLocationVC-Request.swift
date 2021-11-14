//
//  SearchLocationVC-Request.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/13.
//
import CoreLocation
import AMapLocationKit
import AMapFoundationKit
import AMapSearchKit
import MJRefresh
extension SearchLocationVC{
    func request(){
        showLoad()
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoad()
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoad()
                    return
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            //unwrapped self
            guard let POIVC = self else {return}
            if let location = location{
                POIVC.latitude = location.coordinate.latitude
                POIVC.longitude = location.coordinate.longitude
                POIVC.aroundSearch()
                POIVC.footer.resetNoMoreData()
                POIVC.POITableVIew.mj_footer?.setRefreshingTarget(POIVC, refreshingAction: #selector(POIVC.refreshPOILocation))
            }


            if let reGeocode = reGeocode {
                guard !reGeocode.formattedAddress.isEmpty else {return}
                let province = reGeocode.province == reGeocode.city ? "" : reGeocode.province!
                let city = reGeocode.city!
                let district = reGeocode.district.unwarpString
                let street = reGeocode.street.unwarpString
                let number = reGeocode.number.unwarpString
                let poi = [reGeocode.poiName.unwarpString , province + city + district + street  + number]
                POIVC.pois.append(poi)
                
                //主线程执行UI  防止线程不安全
                DispatchQueue.main.async {
                    POIVC.POITableVIew.reloadData()
                }
            }
        })
    }
 
    func aroundSearch(_ page: Int = 1){
        aroundRearchRequest.page = page
        mapSearch?.aMapPOIAroundSearch(aroundRearchRequest)
    }
    @objc func refreshPOILocation(){
        aroundCurrentPageLocation += 1
        aroundSearch(aroundCurrentPageLocation)
        footer.endRefreshing()
    }
}

