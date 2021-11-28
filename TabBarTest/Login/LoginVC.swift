//
//  LoginVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/27.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("一键登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginByClickOnce), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "Main")!
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginBtn)
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginBtn.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(80)
        }
        
        
        // Do any additional setup after loading the view.
    }
    @objc func loginByClickOnce(){
//        let config = JVAuthConfig()
//         config.appKey = "your appkey"
//         JVERIFICATIONService.setup(with: config)
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
