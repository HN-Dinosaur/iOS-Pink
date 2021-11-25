//
//  myTabBarController.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/4.
//

import UIKit
import YPImagePicker

class myTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
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

            return false
        }
        return true
    }

}
