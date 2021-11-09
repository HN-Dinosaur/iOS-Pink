//
//  PhotoFooter.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit

class PhotoFooter: UICollectionReusableView {
        
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.borderWidth =  1
        layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
}
