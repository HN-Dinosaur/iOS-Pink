//
//  KeyBoardInputAccessory.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/11.
//

import UIKit

class KeyBoardInputAccessory: UIView {

    @IBOutlet weak var textDisplay: UIStackView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var maxTextCount: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var currentTextCount = 0{
        didSet{
            //大于限制字数
            if currentTextCount >= kMaxTextViewInputCount{
                textDisplay.isHidden = false
                doneBtn.isHidden = true 
                textCount.text = "\(currentTextCount)"
            }else{
                textDisplay.isHidden = true
                doneBtn.isHidden = false
            }
        }
    }

}
