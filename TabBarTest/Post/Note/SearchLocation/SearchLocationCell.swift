//
//  SearchLocationCell.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/13.
//

import UIKit

class SearchLocationCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var specificLabel: UILabel!
    
    
    var poi = ["", ""]{
        didSet{
            locationLabel.text = poi.first
            specificLabel.text = poi.last
        }
    }

}
