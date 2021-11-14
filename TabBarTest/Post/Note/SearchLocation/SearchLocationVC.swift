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
import MJRefresh

class SearchLocationVC: UIViewController {
    
    var delegate: POIDelagate?
    
    lazy var locationManager = AMapLocationManager()
    lazy var aroundRearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.requireExtension = true
        request.offset = kDefaultPageOffset
        return request
    }()
    lazy var mapSearch = AMapSearchAPI()
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.requireExtension = true
        request.offset = kDefaultPageOffset
        return request
    }()
    lazy var footer = MJRefreshAutoNormalFooter()
    
    var poiName: String = ""
    var longitude = 0.0
    var latitude = 0.0
    var pois = [["不显示任何位置" , ""]]
    var aroundCurrentPageLocation: Int = 1
    var keyboardCurrentPageLocation: Int = 1
    var allPagesCount: Double = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var POITableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        request()
        
        mapSearch?.delegate = self
        searchBar.delegate = self
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
extension SearchLocationVC: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // MARK: -待做  防抖节流
        if searchText.isEmpty{
            aroundSearch()
            footer.resetNoMoreData()
            POITableVIew.mj_footer?.setRefreshingTarget(self, refreshingAction: #selector(refreshPOILocation))
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //点击搜索则更新tableView的地点
        guard let searchText = searchBar.text, !searchText.isBlank else {return }
        showLoad()
        newKeyboardSearch()
        keywordsSearchRequest.keywords = searchText
        //默认page = 1搜索
        keywordsSearch()
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchRefresh))
 
    }
    func newKeyboardSearch(){
        pois.removeAll()
        keyboardCurrentPageLocation = 1
    }
    @objc func keywordsSearchRefresh(){
        keyboardCurrentPageLocation += 1
        keywordsSearch(aroundCurrentPageLocation)
    }
    func keywordsSearch(_ page: Int = 1){
        keyboardCurrentPageLocation = page
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
        footer.endRefreshing() 
    }
    
}
extension SearchLocationVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        cell.selectionStyle = .none
        cell.tintColor = UIColor(named: "Main")!
        
        delegate?.updatePOI(poiName: pois[indexPath.row][0])
        dismiss(animated: true)
        
    }
}
extension SearchLocationVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOICellID, for: indexPath) as! SearchLocationCell
        cell.poi = pois[indexPath.row]
        if cell.poi[0] == poiName{
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(named: "Main")!
        }
        
        return cell
    }
    
    
}
extension SearchLocationVC: AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        hideLoad()
        //获取当前总页数
        allPagesCount = ceil(Double(response.count / kDefaultPageOffset))
        if aroundCurrentPageLocation >= Int(allPagesCount){
            footer.endRefreshingWithNoMoreData()
        }
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
