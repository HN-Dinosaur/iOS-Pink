//
//  NoteEditVC-DraftNote.swift
//  TabBarTest
//
//  Created by LongDengYu on 2021/11/25.
//

import UIKit
extension NoteEditVC{
    @objc func registerDraftStoreTapGesture(tap: UITapGestureRecognizer){
        guard isValid() else {return}
  
        //更新草稿
        if let draftNote = self.draftNote {
            handleDraftUpdate(draftNote)
        }else{
            //创建草稿
            createDraft()
        }
    }
    //新建草稿
    func createDraft(){
        //后台执行
        backgroundContext.perform {
            self.backgroundCreateDraft()
            //主线程执行UI
            DispatchQueue.main.async {
                self.showToast(text: "保存草稿成功", false)
            }
        }
        dismiss(animated: true)
    }
    //执行创建草稿功能
    func backgroundCreateDraft(){
        let draftNote = DraftNote(context: backgroundContext)
        //存储视频
        if isVideo{
            draftNote.video = try? Data(contentsOf: videoURL!)
        }
        handleDraftPhoto(draftNote)
        draftNote.isVideo = isVideo
        handleDraftOthers(draftNote)
    }
    //更新草稿
    func handleDraftUpdate(_ draftNote: DraftNote){
        backgroundContext.perform {
            DispatchQueue.main.async {
                self.backgroundUpdateDraft(draftNote)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func backgroundUpdateDraft(_ draftNote: DraftNote){
        if !isVideo{
            handleDraftPhoto(draftNote)
        }
        handleDraftOthers(draftNote)
        finishUpdateDraft?()
    }
    func handleDraftPhoto(_ draftNote: DraftNote){
        //存储所有照片
        let images:[Data] = photos.map { $0.pngData() ?? imagePlacehold.pngData()! }
        draftNote.images = try? JSONEncoder().encode(images)
        //存储压缩过的封面图片
        draftNote.converImage = photos[0].jpegCompress(.middle)
    }
    func handleDraftOthers(_ draftNote: DraftNote){
        DispatchQueue.main.async {
            draftNote.title = self.titleTextField.exctString
            draftNote.text = self.textView.exctString
        }
        draftNote.poiName = poiName
        draftNote.subTopic = subTopic
        draftNote.channel = channel
        draftNote.updatedAt = Date()
        appDelegate.saveBackgroundContext()
    }
}
