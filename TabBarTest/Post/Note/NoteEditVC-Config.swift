//
//  NoteEditVC-Config.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/25.
//

import UIKit
import CoreData
import CoreLocation
import AMapLocationKit
import PopupDialog

extension NoteEditVC{
    
    func settingTextView(){
        //得到TextView左右的padding
        let padding = textView.textContainer.lineFragmentPadding
        //上下padding0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        //左右padding0
        //textView.textContainer.lineFragmentPadding = 0
        
        //让每行间隙变成6
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        //添加样式
        let typeString:[NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        textView.typingAttributes = typeString
        //修改textView的光标颜色
        textView.tintColorDidChange()
        
        //拿到xib文件的实例
        textView.inputAccessoryView = Bundle.loadNibView(name: "KeyBoardInputAccessory", class: KeyBoardInputAccessory.self)
        keyBoardInputAccessoryView.doneBtn.addTarget(self, action: #selector(resignKeyBoardInputAccessoryRespond), for: .touchUpInside)
        
        //textViewCountDisplay
        keyBoardInputAccessoryView.maxTextCount.text = "/\(kMaxTextViewInputCount)"
    }
    func settingLayout(){
        //使顶部照片视频可以和用户互动
        photoCollectionView.dragInteractionEnabled = true
        //TextField
        textCount.isHidden = true
        textCount.text = "\(kMaxTextFieldInputCount)"
        //设置TextView的界面
        settingTextView()
        //注册手势
        settingGesture()
        //请求位置
        requestLocation()
        //设置右上角PopUp
        setRightBarButtonItem()
    }
    func setRightBarButtonItem(){
        let config = UIImage.SymbolConfiguration(scale: .large)
        let icon = UIImage(systemName: "info.circle", withConfiguration: config)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(showPopUp))
    }
    func settingGesture(){
        //添加点击话题手势
        let topicTap = UITapGestureRecognizer(target: self, action: #selector(registerTopicTapGesture(tap:)))
        topicGesture.addGestureRecognizer(topicTap)
        //添加点击位置手势
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(registerLocationTapGesture(tap:)))
        locationGesture.addGestureRecognizer(locationTap)
        //存草稿功能
        let draftStoreTap = UITapGestureRecognizer(target: self, action: #selector(registerDraftStoreTapGesture(tap:)))
        storeStack.addGestureRecognizer(draftStoreTap)
    }
    func requestLocation(){
        //请求地址
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        //异步请求
        locationManager.requestLocation()
    }
    @objc func showPopUp(){
        let title = "发布小贴士"
        let message =
        """
        1.xxx
        2.yyy
        3.xixi
        """
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,transitionStyle: .zoomIn)
        let confirmBtn = CancelButton(title: "我知道了", action: nil)
        popup.addButtons([confirmBtn])
        // Present dialog
        self.present(popup, animated: true)
    }
    @objc func registerLocationTapGesture(tap: UITapGestureRecognizer){
        let searchVC = storyboard?.instantiateViewController(withIdentifier: kSearchLocationVCID) as! SearchLocationVC
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.delegate = self
        searchVC.poiName = poiName
        present(searchVC, animated: true)
    }
    @objc func registerTopicTapGesture(tap: UITapGestureRecognizer){
        view.endEditing(true)
        let topicVC = storyboard?.instantiateViewController(withIdentifier: kTopicViewControllerID) as! TopicViewController
        topicVC.topicDelegate = self
        present(topicVC, animated: true)
    }
    @objc func resignKeyBoardInputAccessoryRespond(){
        textView.resignFirstResponder()
    }
    
}
