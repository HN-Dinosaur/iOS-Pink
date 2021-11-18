//
//  DraftWaterfallCell.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/17.
//

import UIKit
// MARK: -deleteBtn有Bug
class DraftWaterfallCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deleteBtn: UIImageView!
    @IBOutlet weak var isVideo: UIImageView!
    
    var draftNote: DraftNote?{
        didSet{
            guard let draftNote = draftNote else {return}
            let title = draftNote.title!
            titleLabel.text = title.isEmpty ? "还没有填写标题" : title
            
            isVideo.isHidden = !draftNote.isVideo
            imageView.image = UIImage(optionalData: draftNote.converImage)
            date.text = draftNote.updatedAt?.formattedTime
            
        }
    }
}
