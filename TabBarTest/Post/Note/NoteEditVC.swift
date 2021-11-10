//
//  NoteEditVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
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
        photoCollectionView.dragInteractionEnabled = true
        textCount.isHidden = true
        textCount.text = "\(kMaxTextFieldInputCount)"
        // Do any additional setup after loading the view.
    }
    
}
