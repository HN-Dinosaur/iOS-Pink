//
//  TopicViewController.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/12.
//

import UIKit
import XLPagerTabStrip

class TopicViewController: ButtonBarPagerTabStripViewController {
    
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
        var vcs:[UIViewController] = []
        for i in kWaterfallChannel.indices{
            let vc = storyboard?.instantiateViewController(withIdentifier: kTopicTableViewController) as! TopicTableViewController
            vc.channel = kWaterfallChannel[i]
            vc.topicItems = kTopicItem[i]
            vcs.append(vc)
        }
        
        return vcs
    }

}
