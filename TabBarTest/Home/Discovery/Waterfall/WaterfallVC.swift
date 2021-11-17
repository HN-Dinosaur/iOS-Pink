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
    var isDraft = true
    var draftNotes: [DraftNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    func config(){
        let layout = self.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
    }
    func getCoreData(){
        let request = DraftNote.fetchRequest()
        let draftNotes = try! viewContext.fetch(request)
        self.draftNotes = draftNotes
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

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftWaterfallCellID, for: indexPath) as! DraftWaterfallCell
            cell.draftNote = draftNotes[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallViewCell
            cell.cellImage.image = UIImage(named: "\(indexPath.item + 1)")
            return cell
        }

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIImage(named: "\(indexPath.item + 1)")!.size
    }
    
}
extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: channel)
    }
}
