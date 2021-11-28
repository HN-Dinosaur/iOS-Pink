//
//  myTabBarController.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/4.
//

import UIKit
import YPImagePicker

class myTabBarController: UITabBarController, UITabBarControllerDelegate {

    var isLogin: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }
// MARK: -待做登录验证
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if isLogin{
            if viewController is PostVC{
                var config = YPImagePickerConfiguration()

                // MARK: photo
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.albumName = "Pink"
                config.startOnScreen = .library
                config.screens = [.library, .photo, .video]
                config.bottomMenuItemSelectedTextColour = .label
                config.bottomMenuItemUnSelectedTextColour = .secondaryLabel
                config.maxCameraZoomFactor = kMaxCameraZoomFactor

                // MARK: library
                config.library.mediaType = .photoAndVideo
                config.library.defaultMultipleSelection = true
                config.library.maxNumberOfItems = kMaxExistPhotoCount
                config.library.spacingBetweenItems = kSpacingBetweenItems
                config.library.preSelectItemOnMultipleSelection = false

                
                let picker = YPImagePicker(configuration: config)
                //传入closure
                picker.didFinishPicking { [unowned picker] items, cancel in
                    if cancel{
                        picker.dismiss(animated: true)
                    }else{
                        var photos: [UIImage] = []
                        var videoURL: URL?
                        for item in items{
                            switch item{
                            case .photo(let photo):
                                photos.append(photo.image)
                            case .video(let video):
                                photos.append(video.thumbnail)
                                videoURL = video.url
                            }
                        }
                        guard let noteVC = self.storyboard!.instantiateViewController(withIdentifier: kNoteEditVCID) as? NoteEditVC else{
                            picker.dismiss(animated: true)
                            return
                        }
                        noteVC.photos = photos
                        noteVC.videoURL = videoURL
                        
                        picker.pushViewController(noteVC, animated: true)
                    }
                    
                }
                
                present(picker, animated: true, completion: nil)
            }else{
                //前往“我的”去登录
                let alert = UIAlertController(title: "提示", message: "还为登录，是否前往登录页面", preferredStyle: .alert)
                let cancelBtn = UIAlertAction(title: "取消", style: .cancel)
                let goBtn = UIAlertAction(title: "前往", style: .default) { _ in
                    self.selectedIndex = 4
                }
                alert.addAction(cancelBtn)
                alert.addAction(goBtn)
                present(alert, animated: true)
            }
            return false
        }
        return true
    }

}
