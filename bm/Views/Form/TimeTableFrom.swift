//
//  TimeTableFrom.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class TimeTableForm: BaseForm {
    
    var eventTitle: String?
    var eventDay: String?
    var eventStartTime: String?
    var eventEndTime: String?
    var eventLimit: String?
    var eventColor: String?
    var eventStatus: String?
    var eventContent: String?
    
    override func configureItems() {
        
        let eventTitleItem = FormItem(title: "標題", placeholder: "請輸入標題")
        eventTitleItem.uiProperties.cellType = FormItemCellType.textField
        eventTitleItem.value = eventTitle
        eventTitleItem.valueCompletion = {
            [weak self, weak eventTitleItem] value in self?.eventTitle = value
            eventTitleItem?.value = value
        }
        
        let eventDayItem = FormItem(title: "星期日期")
        eventDayItem.uiProperties.cellType = FormItemCellType.more
        eventDayItem.segue = TO_WEEKDAY
        
        let eventStartTimeItem = FormItem(title: "開始時間")
        eventStartTimeItem.uiProperties.cellType = FormItemCellType.more
        
        let eventEndTimeItem = FormItem(title: "結束時間")
        eventEndTimeItem.uiProperties.cellType = FormItemCellType.more
        
        let eventLimitItem = FormItem(title: "限制人數", placeholder: "無限制請填-1")
        eventLimitItem.uiProperties.cellType = FormItemCellType.textField
        eventLimitItem.uiProperties.keyboardType = .numberPad
        eventLimitItem.value = eventLimit
        eventLimitItem.valueCompletion = {
            [weak self, weak eventLimitItem] value in self?.eventLimit = value
            eventLimitItem?.value = value
        }
        
        let eventColorItem = FormItem(title: "顏色")
        eventColorItem.uiProperties.cellType = FormItemCellType.more
        
        let eventStatusItem = FormItem(title: "狀態")
        eventStatusItem.uiProperties.cellType = FormItemCellType.more
        
        let eventContentItem = FormItem(title: "詳細內容")
        eventContentItem.uiProperties.cellType = FormItemCellType.more
        
        formItems = [eventTitleItem, eventDayItem, eventStartTimeItem, eventEndTimeItem, eventLimitItem, eventColorItem, eventStatusItem, eventContentItem]
    }
}
