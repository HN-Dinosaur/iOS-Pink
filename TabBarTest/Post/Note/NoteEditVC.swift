//
//  NoteEditVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/8.
//

import UIKit
import PhotosUI
import YPImagePicker

class NoteEditVC: UIViewController {
    
    var photos = [
        UIImage(named: "1"),UIImage(named: "2")
    ]

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photoCount: Int{
        photos.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension NoteEditVC: UICollectionViewDelegate{
    
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
//        print("123")
        if photoCount < 9{
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
            
        }
    }
    
    
}
