//
//  SearchLocationVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/13.
//

import UIKit
import AMapLocationKit
import AMapFoundationKit
import AMapSearchKit
import CoreLocation

class SearchLocationVC: UIViewController {
    lazy var locationManager = AMapLocationManager()
    lazy var searchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        return request
    }()
    lazy var mapSearch = AMapSearchAPI()
    
    
    var longitude = 0.0
    var latitude = 0.0
    var pois = [["不显示任何位置" , ""]]
    
    @IBOutlet weak var POITableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()

        request()
        
        mapSearch?.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchLocationVC: UITableViewDelegate{
    
}
extension SearchLocationVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOICellID, for: indexPath) as! SearchLocationCell
        cell.poi = pois[indexPath.row]
        return cell
    }
    

}
extension SearchLocationVC: AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        hideLoad()
        if response.count == 0 {
            return
        }
        
        for poi in response.pois{
            let province = poi.province == poi.city ? "" : poi.province
            let address = poi.district == poi.address ? "" : poi.address
            
            let poi = [poi.name ?? kUnknowPOIName, province.unwarpString + poi.city.unwarpString + poi.district.unwarpString + address.unwarpString]
            pois.append(poi)
        }
        
        POITableVIew.reloadData()

    }
}
