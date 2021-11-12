//
//  Protocol.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/12.
//

import Foundation


protocol TopicDelegate{
    /// 为传值做准备
    /// - Parameter topic : 话题块
    /// - Parameter subTopic : 选择的话题
    /// - Returns: nil
    func updateTopic(topic: String, subTopic: String)
}
