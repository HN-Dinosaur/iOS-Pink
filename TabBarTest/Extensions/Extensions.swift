//
//  Extensions.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
