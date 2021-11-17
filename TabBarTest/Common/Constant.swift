//
//  Constant.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/2.
//

import UIKit


// MARK: StoryBoard
let kDiscoverVCID = "DiscoverVCID"
let kFollowVCID = "FollowVCID"
let kNearbyVCID = "NearbyVCID"
let kTopicTableViewControllerID = "TopicTableViewControllerID"
let kTopicViewControllerID = "TopicViewControllerID"
let kSearchLocationVCID = "SearchLocationVCID"
// MARK: Waterfall
let kWaterfallVCID = "WaterfallVCID"
let kPostVCID = "PostVCID"
let kPOICellID = "POICellID"
let kDraftWaterfallCellID = "DraftWaterfallCellID"
// MARK: CellID
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "photoCellID"
let kPhotoFooterID = "PhotoFooterID"
let kTopicItemCellID = "TopicItemCellID"
// MARK: WaterfallPadding
let kWaterfallPadding = CGFloat(4)
// MARK: discoverChannel
let kWaterfallChannel = ["旅行","美食","游戏","健身","美女","帅哥","白富美","宠物"]
// MARK: -YPImagePickerCosntant
let kMaxExistPhotoCount: Int = 9
let kMaxCameraZoomFactor: CGFloat = 10
let kSpacingBetweenItems: CGFloat = 1.0
let kMaxTextFieldInputCount = 20
let kMaxTextViewInputCount = 1000
let kTopicItem = [
    ["穿神马是神马", "就快瘦到50斤啦", "花5个小时修的靓图", "网红店入坑记"],
    ["魔都名媛会会长", "爬行西藏", "无边泳池只要9块9"],
    ["小鲜肉的魔幻剧", "国产动画雄起"],
    ["练舞20年", "还在玩小提琴吗,我已经尤克里里了哦", "巴西柔术", "听说拳击能减肥", "乖乖交智商税吧"],
    ["粉底没有最厚,只有更厚", "最近很火的法属xx岛的面霜"],
    ["我是白富美你是吗", "康一康瞧一瞧啦"],
    ["装x西餐厅", "网红店打卡"],
    ["我的猫儿子", "我的猫女儿", "我的兔兔"]
]

// MARK: gaodeSDK
let klocationSDKSecret = "ceeb4f7e3c332e2eba36f31b04fe44d0"
let kUnknowPOIName = "不知名的地点"
let kDefaultPageOffset = 20

// MARK: -Core Data
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let viewContext = appDelegate.persistentContainer.viewContext
