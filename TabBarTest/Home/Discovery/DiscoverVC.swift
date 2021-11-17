//
//  DiscoverVC.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/2.
//

import UIKit
import XLPagerTabStrip



class DiscoverVC: ButtonBarPagerTabStripViewController,IndicatorInfoProvider {

    override func viewDidLoad() {
        settings.style.selectedBarHeight = 0
        
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        
        super.viewDidLoad()
        
        containerView.bounces = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            oldCell?.label.font = UIFont.systemFont(ofSize: 14)
            newCell?.label.textColor = .label
            newCell?.label.font = UIFont.systemFont(ofSize: 16)
            
        }

    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "发现")
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]{
        var vcArray:[UIViewController] = []
        for channel in kWaterfallChannel{
            let waterfallVC = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
            waterfallVC.channel = channel
            vcArray.append(waterfallVC)
        }
        
        return vcArray
    }
}
