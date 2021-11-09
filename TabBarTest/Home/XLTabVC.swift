//
//  XLTabVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/1.
//

import UIKit
import XLPagerTabStrip

class XLTabVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3
        settings.style.selectedBarBackgroundColor = UIColor(named: "Main")!
        
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16)
        
        
        super.viewDidLoad()

        
        containerView.bounces = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            oldCell?.label.font = UIFont.systemFont(ofSize: 16)
            newCell?.label.textColor = .label
            newCell?.label.font = UIFont.systemFont(ofSize: 18)
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]{
        let FollowVC = storyboard!.instantiateViewController(identifier: kFollowVCID)
        let NearbyVC = storyboard!.instantiateViewController(identifier: kNearbyVCID)
        let DiscoverVC = storyboard!.instantiateViewController(identifier: kDiscoverVCID)
        
        return [FollowVC, DiscoverVC, NearbyVC ]
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
