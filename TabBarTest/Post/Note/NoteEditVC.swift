//
//  NoteEditVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import CoreData
class NoteEditVC: UIViewController{
    
    var photos = [
        UIImage(named: "1")!,UIImage(named: "2")!
    ]
    var videoURL: URL?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //计算属性如果get的值没有改变则不再重新计算
    var photoCount: Int{
        photos.count
    }
    var isVideo: Bool {
        videoURL != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    func settingLayout(){
        photoCollectionView.dragInteractionEnabled = true
        textCount.isHidden = true
        textCount.text = "\(kMaxTextFieldInputCount)"
        //得到TextView左右的padding
        let padding = textView.textContainer.lineFragmentPadding
        //上下padding0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        //左右padding0
        //textView.textContainer.lineFragmentPadding = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typeString:[NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        textView.typingAttributes = typeString
        //修改textView的光标颜色
        textView.tintColorDidChange()

    }
    
}
