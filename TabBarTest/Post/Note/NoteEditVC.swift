//
//  NoteEditVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import PhotosUI
import YPImagePicker
import MBProgressHUD
import SKPhotoBrowser
class NoteEditVC: UIViewController {
    
    var photos = [
        UIImage(named: "1")!,UIImage(named: "2")!
    ]
    var videoURL: URL?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //计算属性如果get的值没有改变则不再重新计算
    var photoCount: Int{
        photos.count
    }
    var isVideo: Bool {
        videoURL == nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
extension NoteEditVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. create SKPhoto Array from UIImage
        var images: [SKPhoto] = []
        for photo in photos{
            images.append(SKPhoto.photoWithImage(photo))
        }
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
//        SKPhotoBrowserOptions.displayPagingHorizontalScrollIndicator = false
//        SKPhotoBrowserOptions.displayCounterLabel = false
        SKPhotoBrowserOptions.displayPagingHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayStatusbar = false
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.displayAction = false
        present(browser, animated: true)
    }
}
extension NoteEditVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! photoCell
        
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(handleClickAddPhotoBtn), for: .touchUpInside)
            
            return photoFooter
        default:
            fatalError("Footer出错")
        }
    }
    @objc func handleClickAddPhotoBtn(){
                if photoCount < kMaxExistPhotoCount{
                    var config = YPImagePickerConfiguration()
        
                    // MARK: photo
                    config.albumName = "Pink"
                    config.screens = [.library]
        
                    // MARK: library
                    config.library.mediaType = .photo
                    config.library.defaultMultipleSelection = true
                    config.library.maxNumberOfItems = kMaxExistPhotoCount - photoCount
                    config.library.spacingBetweenItems = 1.0
                    config.library.preSelectItemOnMultipleSelection = false
        
                    // MARK: Galery
                    config.gallery.hidesRemoveButton = false
        
        
                    let picker = YPImagePicker(configuration: config)
                    picker.didFinishPicking { [unowned picker] items, _ in
                        for item in items{
                            if case let .photo(photo) = item{
        //                        print(photo.fromCamera)
                                self.photos.append(photo.image)
                            }
                        }
                        self.photoCollectionView.reloadData()
                        picker.dismiss(animated: true)
                    }
                    present(picker, animated: true)
                }else{
                    let alert = MBProgressHUD.showAdded(to: self.view, animated: true)
                    alert.mode = .text
                    alert.label.text = "最多只能选择\(kMaxExistPhotoCount)张图片"
                    alert.hide(animated: true, afterDelay: 2)
        
                }
            }
        
        
    }
