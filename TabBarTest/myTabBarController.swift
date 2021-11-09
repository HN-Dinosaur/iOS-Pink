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
            picker.didFinishPicking { [unowned picker] items, _ in
                for item in items{
                    switch item{
                    case .photo(let photo):
                        print(photo.fromCamera) // Image source (camera or library)
                        print(photo.image) // Final image selected by the user
                        print(photo.originalImage) // original image selected by the user, unfiltered
                    case .video(let video):
                        print(video.fromCamera)
                    }

                    
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)

            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
