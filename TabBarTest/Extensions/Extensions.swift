//
//  Extensions.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import MBProgressHUD
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
extension UIViewController{
    
    // MARK: 显示文字提示
    func showToast(text: String){
        let toast = MBProgressHUD.showAdded(to: view, animated: true)
        toast.mode = .text
        toast.label.text = text
        toast.hide(animated: true, afterDelay: 2)
    }
}
