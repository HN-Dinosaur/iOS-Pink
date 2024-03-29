//
//  NoteEditVC-Extension.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/10.
//

import UIKit
import PhotosUI
import YPImagePicker
import SKPhotoBrowser
import AVKit
import CoreLocation
import AMapFoundationKit
import AMapLocationKit

extension NoteEditVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if isVideo{
            let avPlayer = AVPlayerViewController()
            let player = AVPlayer(url: videoURL!)
            avPlayer.player = player
            //全屏
            avPlayer.modalPresentationStyle = .fullScreen
            present(avPlayer, animated: true)
            player.play()
        }else{
            // 1. create SKPhoto Array from UIImage
            var images: [SKPhoto] = []
            for photo in photos{
                images.append(SKPhoto.photoWithImage(photo))
            }
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
            //实现删除照片功能
            browser.delegate = self
            //        SKPhotoBrowserOptions.displayPagingHorizontalScrollIndicator = false
            //        SKPhotoBrowserOptions.displayCounterLabel = false
            SKPhotoBrowserOptions.displayPagingHorizontalScrollIndicator = false
            SKPhotoBrowserOptions.displayStatusbar = false
            SKPhotoBrowserOptions.displayDeleteButton = true
            SKPhotoBrowserOptions.displayAction = false
            present(browser, animated: true)
        }
    }
}
extension NoteEditVC: SKPhotoBrowserDelegate{
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        
        photos.remove(at: index)
        photoCollectionView.reloadData()
        reload()
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
            showToast(text: "最多只能添加\(kMaxExistPhotoCount)张图片")
        }
    }
    
    
}
extension NoteEditVC: UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let photo = photos[indexPath.item]
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: photo))
        dragItem.localObject = photo
        return [dragItem]
    }
    
    
}
extension NoteEditVC: UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: UIDropOperation.move, intent: .insertIntoDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: UIDropOperation.forbidden)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        //1.Iterate over the items property in the provided drop coordinator object.
        if coordinator.proposal.operation == .move,
           let item = coordinator.items.first,
           let destinationIndexPath = coordinator.destinationIndexPath,
           let sourceIndexPath = item.sourceIndexPath{
            
            collectionView.performBatchUpdates {
                photos.remove(at: sourceIndexPath.item)
                photos.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.item)
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
         
            
        }
        
    }
    
    
}
extension NoteEditVC: UITextFieldDelegate{
    //开始输入
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textCount.isHidden = false
    }
    //正在输入
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //当前输入框高亮时退出
        guard textField.markedTextRange == nil else{ return}
        if textField.unwarpText.count > kMaxTextFieldInputCount{
            //截去超出的字
            textField.text = String(textField.unwarpText.prefix(kMaxTextFieldInputCount))
            showToast(text: "最多只能输入\(kMaxTextFieldInputCount)个字")
            DispatchQueue.main.async {
                let end = textField.endOfDocument
                textField.selectedTextRange = textField.textRange(from: end, to: end)
            }
            //让光标位于粘贴后的最后一位
        }
        textCount.text = "\(kMaxTextFieldInputCount - textField.unwarpText.count)"

    }
    //结束输入
    func textFieldDidEndEditing(_ textField: UITextField) {

        textCount.isHidden = true
  
    }
    //当点击键盘完成时，收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //将要输入
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        //如果当前输入的第一个字母的索引>=最大字符数 ｜｜ 当前textField.court + 输入.count大于最大字符数
//        let isExceed = range.location >= kMaxTextFieldInputCount || (textField.unwarpText.count + string.count) > kMaxTextFieldInputCount
//        if isExceed{
//            showToast(text: "最大输入\(kMaxTextFieldInputCount)个字符")
//        }
//        return !isExceed
//    }
    
}
extension NoteEditVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {return}
        keyBoardInputAccessoryView.currentTextCount = textView.text.count
        
    }
}
extension NoteEditVC: CLLocationManagerDelegate{

    //成功获取用户位置一次
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //经度
//        let lon = locations[0].coordinate.longitude
//        //纬度
//        let lat = locations[0].coordinate.latitude
        //通过第三方包的Http请求Api获取天气信息参数（经纬度）&（key）
        AMapLocationManager.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        AMapLocationManager.updatePrivacyAgree(.didAgree)
        

    }
    //不能获取用户位置
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AMapLocationManager.updatePrivacyAgree(.unknow)
        AMapLocationManager.updatePrivacyShow(.unknow, privacyInfo: .unknow)
        showToast(text: "获取位置失败")
    }
}

