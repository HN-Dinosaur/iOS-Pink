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

class NoteEditVC: UIViewController{
    
    var photos = [
        UIImage(named: "1")!,UIImage(named: "2")!
    ]
    var videoURL: URL?
    
    var channel: String = ""
    var subTopic: String = ""
    var poiName: String = ""
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
        print(NSHomeDirectory() )
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    func settingLayout(){
        photoCollectionView.dragInteractionEnabled = true
        textCount.isHidden = true
        textCount.text = "\(kMaxTextFieldInputCount)"
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
        //添加点击话题手势
        let topicTap = UITapGestureRecognizer(target: self, action: #selector(registerTopicTapGesture(tap:)))
        topicGesture.addGestureRecognizer(topicTap)
        //添加点击位置手势
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(registerLocationTapGesture(tap:)))
        locationGesture.addGestureRecognizer(locationTap)
        //存草稿功能
        let draftStoreTap = UITapGestureRecognizer(target: self, action: #selector(registerDraftStoreTapGesture(tao:)))
        storeStack.addGestureRecognizer(draftStoreTap)
        
        //请求地址
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        //请求的位置精度
        //异步请求
        locationManager.requestLocation()
    }
    @objc func registerDraftStoreTapGesture(tao: UITapGestureRecognizer){
        
        guard keyBoardInputAccessoryView.currentTextCount <= kMaxTextViewInputCount else{
            showToast(text: "最多只能填写\(kMaxTextViewInputCount)个字")
            return
        }
        
        let draftNote = DraftNote(context: viewContext)
        
        //存储视频
        if isVideo{
            draftNote.video = try? Data(contentsOf: videoURL!)
        }
        //存储所有照片
        var images: [Data] = []
        for photo in self.photos{
            images.append(photo.pngData()!)
        }
        draftNote.images = try? JSONEncoder().encode(images)
        //存储压缩过的封面图片
        draftNote.converImage = photos[0].jpegCompress(.middle)
        
        draftNote.isVideo = isVideo
        draftNote.poiName = poiName
        draftNote.subTopic = subTopic
        draftNote.channel = channel
        draftNote.title = titleTextField.exctString
        draftNote.text = textView.exctString
        draftNote.updatedAt = Date()
        
        appDelegate.saveContext()
        
        
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
extension NoteEditVC: TopicDelegate{
    func updateTopic(topic: String, subTopic: String) {
        self.channel = topic
        self.subTopic = subTopic
        
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
            POIIcon.tintColor = .secondaryLabel
            POILabel.text = "添加地点"
            POILabel.textColor = .label
        }else{
            self.poiName = poiName
            POIIcon.tintColor = .systemBlue
            POILabel.text = poiName
            POILabel.textColor = .systemBlue
        }

    }
}


