//
//  NoteEditVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import CoreData
import CoreLocation
import AMapLocationKit
import LeanCloud

class NoteEditVC: UIViewController{
    
    var draftNote: DraftNote?
    var photos :[UIImage] = []
    var videoURL: URL?
    
    var channel: String = ""
    var subTopic: String = ""
    var poiName: String = ""
    
    var finishUpdateDraft: (() -> ())?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationGesture: UIStackView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var topicGesture: UIStackView!
    @IBOutlet weak var topicIcon: UIImageView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var selectTopicLabel: UILabel!
    @IBOutlet weak var POIIcon: UIImageView!
    @IBOutlet weak var POILabel: UILabel!
    @IBOutlet weak var storeStack: UIStackView!
    @IBAction func sendBtn(_ sender: Any) {
        guard isValid() else {return}
        
        do {
            let tableObject = LCObject(className: kNoteTable)
            try tableObject.set("title", value: titleTextField.exctString)
            try tableObject.set("text", value: textView.exctString)
            try tableObject.set("channel", value: channel.isEmpty ? "推荐" : channel)
            try tableObject.set("poiName", value: poiName)
            try tableObject.set("subTopic", value: subTopic)
            let result = tableObject.save()
            if let error = result.error {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    //计算属性如果get的值没有改变则不再重新计算
    var photoCount: Int{
        photos.count
    }
    var isVideo: Bool {
        videoURL != nil
    }
    var keyBoardInputAccessoryView: KeyBoardInputAccessory{
        textView.inputAccessoryView as! KeyBoardInputAccessory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingLayout()
        setUI()
    }
    func setUI(){
        settingDraftNoteUI()
    }
    func settingDraftNoteUI(){
        if let draftNote = draftNote {
            titleTextField.text = draftNote.title!
            textView.text = draftNote.text!
            channel = draftNote.channel!
            subTopic = draftNote.subTopic!
            poiName = draftNote.poiName!
            
            if !subTopic.isEmpty{
                updateChannelUI()
            }
            if !poiName.isEmpty{
                updatePOIUI()
            }
        }
    }

    func isValid() -> Bool{
        guard !photos.isEmpty else {
            showToast(text: "至少添加一张照片")
            return false
        }
        
        guard keyBoardInputAccessoryView.currentTextCount <= kMaxTextViewInputCount else{
            showToast(text: "最多只能填写\(kMaxTextViewInputCount)个字")
            return false
        }
        return true
    }
    
}
extension NoteEditVC: TopicDelegate{
    func updateTopic(topic: String, subTopic: String) {
        self.channel = topic
        self.subTopic = subTopic
        
        updateChannelUI()
    }
    func updateChannelUI(){
        self.topicIcon.tintColor = .systemBlue
        self.topicLabel.text = subTopic
        self.topicLabel.textColor = .systemBlue
        self.selectTopicLabel.isHidden = true
    }
}

extension NoteEditVC: POIDelagate{
    func updatePOI(poiName: String) {
        
        if poiName == "不显示任何位置"{
            self.poiName = ""
        }else{
            self.poiName = poiName
        }
        updatePOIUI()
    }
    func updatePOIUI(){
        if poiName == ""{
            POIIcon.tintColor = .secondaryLabel
            POILabel.text = "添加地点"
            POILabel.textColor = .label
        }else{
            POIIcon.tintColor = .systemBlue
            POILabel.text = poiName
            POILabel.textColor = .systemBlue
        }
    }
}


