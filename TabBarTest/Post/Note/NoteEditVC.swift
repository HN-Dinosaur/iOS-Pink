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
    
    var draftNote: DraftNote?
    var photos = [
        UIImage(named: "1")!,UIImage(named: "2")!
    ]
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
        let draftStoreTap = UITapGestureRecognizer(target: self, action: #selector(registerDraftStoreTapGesture(tap:)))
        storeStack.addGestureRecognizer(draftStoreTap)
        
        //请求地址
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        //异步请求
        locationManager.requestLocation()
    }
    @objc func registerDraftStoreTapGesture(tap: UITapGestureRecognizer){
        guard isValid() else {return}
  
        //更新草稿
        if let draftNote = self.draftNote {
            handleDraftUpdate(draftNote)
        }else{
            //创建草稿
            createDraft()
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
    //新建草稿
    func createDraft(){
        //后台执行
        backgroundContext.perform {
            self.backgroundCreateDraft()
            //主线程执行UI
            DispatchQueue.main.async {
                self.showToast(text: "保存草稿成功", false)
            }
        }
        dismiss(animated: true)
    }
    //执行创建草稿功能
    func backgroundCreateDraft(){
        let draftNote = DraftNote(context: backgroundContext)
        //存储视频
        if isVideo{
            draftNote.video = try? Data(contentsOf: videoURL!)
        }
        handleDraftPhoto(draftNote)
        draftNote.isVideo = isVideo
        handleDraftOthers(draftNote)
    }
    //更新草稿
    func handleDraftUpdate(_ draftNote: DraftNote){
        backgroundContext.perform {
            DispatchQueue.main.async {
                self.backgroundUpdateDraft(draftNote)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func backgroundUpdateDraft(_ draftNote: DraftNote){
        if !isVideo{
            handleDraftPhoto(draftNote)
        }
        handleDraftOthers(draftNote)
        finishUpdateDraft?()
    }
    func handleDraftPhoto(_ draftNote: DraftNote){
        //存储所有照片
        let images:[Data] = photos.map { $0.pngData() ?? imagePlacehold.pngData()! }
        draftNote.images = try? JSONEncoder().encode(images)
        //存储压缩过的封面图片
        draftNote.converImage = photos[0].jpegCompress(.middle)
    }
    func handleDraftOthers(_ draftNote: DraftNote){
        DispatchQueue.main.async {
            draftNote.title = self.titleTextField.exctString
            draftNote.text = self.textView.exctString
        }
        draftNote.poiName = poiName
        draftNote.subTopic = subTopic
        draftNote.channel = channel
        draftNote.updatedAt = Date()
        appDelegate.saveBackgroundContext()
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


