//
//  Extensions.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import MBProgressHUD

extension UITextField{
    //计算属性  解包
    var unwarpText: String{
        text ?? ""
    }
}
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
    func cancelKeyBoardWhenClickAround(){
        let tap = UIGestureRecognizer(target: self, action: #selector(clickAround))
        //当点击类似于UIView控件时，不要优先响应
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func clickAround(){
        view.endEditing(true)
    }
}
