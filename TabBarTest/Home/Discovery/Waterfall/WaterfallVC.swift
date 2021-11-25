//
//  WaterfallVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/2.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import CoreData



class WaterfallVC: UICollectionViewController {
    var channel: String = ""
    var isDraft = false
    var draftNotes: [DraftNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        getCoreData()
    }
    // MARK: -待做  进入草稿页面后左上角back Button不显示文字
    func config(){
        let layout = self.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        if isDraft{
            layout.sectionInset = UIEdgeInsets(top:  0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }else{
            layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }
        navigationItem.title = "编辑草稿"
    }
    func getCoreData(){
        let request = DraftNote.fetchRequest()
//        request.fetchOffset = 0
//        request.fetchLimit = 20
//        request.predicate = NSPredicate(format: "title = %@", "iOS")
//        request.returnsObjectsAsFaults  fault in fired
        request.propertiesToFetch = ["title","updatedAt","isVideo"] 
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        showLoad()
        backgroundContext.perform {
            let draftNotes = try! backgroundContext.fetch(request)
            self.draftNotes = draftNotes
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.hideLoad()

        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDraft{
            return draftNotes.count
        }else{
            return 13
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        //如果是草稿页面
        if isDraft{
            let draftNote = draftNotes[indexPath.item]
            
            if let dataImages = draftNote.images, let decodeDataImages = try? JSONDecoder().decode([Data].self, from: dataImages){
                let imageArray = decodeDataImages.map { UIImage(data: $0) ?? imagePlacehold }
                
                let videoURL = FileManager.default.save(draftNote.video, dirName: "video", fileName: UUID().uuidString + ".mp4")
                
                let noteEditVC = storyboard?.instantiateViewController(withIdentifier: kNoteEditVCID) as! NoteEditVC
                noteEditVC.draftNote = draftNote
                noteEditVC.videoURL = videoURL
                noteEditVC.photos = imageArray 
                //回调闭包的思想
                noteEditVC.finishUpdateDraft = {
                    self.getCoreData()
                    self.collectionView.reloadData()
                }
                navigationController?.pushViewController(noteEditVC, animated: true)
            }else{
                showToast(text: "加载草稿失败")
            }
            //是Discovery页面
        }else{
            
        }

    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftWaterfallCellID, for: indexPath) as! DraftWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
//            cell.deleteBtn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showAlert))
            tap.numberOfTapsRequired = indexPath.item
            cell.deleteBtn.addGestureRecognizer(tap)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallViewCell
            cell.cellImage.image = UIImage(named: "\(indexPath.item + 1)")
            return cell
        }

    }
    func deleteDraftNote(index: Int){
        backgroundContext.perform {
            self.backgroundDeleteDraftNote(index: index)
        }
    }
    func backgroundDeleteDraftNote(index: Int){
        let draftNote = draftNotes[index]
        //Core Data
        backgroundContext.delete(draftNote)
        appDelegate.saveBackgroundContext()
        //本地数据
        draftNotes.remove(at: index)
        DispatchQueue.main.async {
            self.showToast(text: "删除草稿成功")
            //UI
//            self.collectionView.performBatchUpdates {
//                self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
//            }
            self.collectionView.reloadData()
        }
    }
    @objc private func showAlert(tap: UITapGestureRecognizer){
        let index = tap.numberOfTapsRequired
        let alert = UIAlertController(title: "提示", message: "确认要删除该草稿吗?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let confirm = UIAlertAction(title: "确认", style: .destructive) { _ in
            self.deleteDraftNote(index: index)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if isDraft{
            let cellW = (screenWidth - kWaterfallPadding * 3) / 2
            var cellH: CGFloat = 0
            let draft = draftNotes[indexPath.item]
            let imageSize = UIImage(optionalData: draft.converImage)!.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            let imageRatio = imageH / imageW
            cellH = imageRatio * cellW + kWaterfallCellBottomHeight
            return CGSize(width: cellW, height: cellH)
        }else{
            return UIImage(named: "\(indexPath.item + 1)")!.size
        }

    }
    
}
extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: channel)
    }
}
