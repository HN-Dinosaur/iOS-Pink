//
//  Extensions.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import MBProgressHUD

extension String{
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String{
    var unwarpString: String{ self ?? "" }

}

extension UITextField{
    //计算属性  解包
    var unwarpText: String{
        text ?? ""
    }
    var exctString: String {
        unwarpText.isBlank ? "" : unwarpText
    }
}
extension UITextView{
    //计算属性  解包
    var unwarpText: String{
        text ?? ""
    }
    var exctString: String {
        unwarpText.isBlank ? "" : unwarpText
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
    
    func showLoad(_ text: String? = nil){
        let load = MBProgressHUD.showAdded(to: view, animated: true)
        load.label.text = text
    }
    func hideLoad(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
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
//main是单例对象
extension Bundle{
    static func loadNibView<T>(name: String, class: T.Type) -> T{
        if let view = main.loadNibNamed(name, owner: nil, options: nil)?.first as? T{
            return view
        }
        fatalError("获取BundleView出现问题")
    }
}
