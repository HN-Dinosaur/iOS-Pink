//
//  TopicTableViewController.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/12.
//

import UIKit
import XLPagerTabStrip
class TopicTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var channel: String = ""
    var topicItems: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topicItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: kTopicItemCellID, for: indexPath)
        cell.textLabel?.text = "# \(topicItems[indexPath.row])"
        cell.textLabel?.font = .systemFont(ofSize: 16)

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        if let topicVC = parent as? TopicViewController{
            topicVC.topicDelegate?.updateTopic(topic: channel, subTopic: topicItems[indexPath.row])
        }
        dismiss(animated: true)
        
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: channel)
    }

}

