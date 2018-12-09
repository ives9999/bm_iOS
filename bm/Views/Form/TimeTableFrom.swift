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
    var eventWeekdayay: String?
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
        
        let eventWeekdayItem = FormItem(title: "星期日期")
        eventWeekdayItem.uiProperties.cellType = FormItemCellType.weekday
        eventWeekdayItem.segue = TO_WEEKDAY
        
        let eventStartTimeItem = FormItem(title: "開始時間")
        eventStartTimeItem.uiProperties.cellType = FormItemCellType.time
        eventStartTimeItem.segue = TO_SELECT_TIME
        eventStartTimeItem.timeType = SELECT_TIME_TYPE.play_start
        eventStartTimeItem.sender = ["type":eventStartTimeItem.timeType!,"time":""]
        
        let eventEndTimeItem = FormItem(title: "結束時間")
        eventEndTimeItem.uiProperties.cellType = FormItemCellType.time
        eventEndTimeItem.segue = TO_SELECT_TIME
        eventEndTimeItem.timeType = SELECT_TIME_TYPE.play_end
        eventEndTimeItem.sender = ["type":eventEndTimeItem.timeType!,"time":""]
        
        let eventLimitItem = FormItem(title: "限制人數", placeholder: "無限制請填-1")
        eventLimitItem.uiProperties.cellType = FormItemCellType.textField
        eventLimitItem.uiProperties.keyboardType = .numberPad
        eventLimitItem.value = eventLimit
        eventLimitItem.valueCompletion = {
            [weak self, weak eventLimitItem] value in self?.eventLimit = value
            eventLimitItem?.value = value
        }
        
        let eventColorItem = FormItem(title: "顏色")
        eventColorItem.uiProperties.cellType = FormItemCellType.color
        eventColorItem.segue = TO_SELECT_COLOR
        
        let eventStatusItem = FormItem(title: "狀態")
        eventStatusItem.uiProperties.cellType = FormItemCellType.status
        eventStatusItem.segue = TO_SELECT_STATUS
        eventStatusItem.status = STATUS.online
        eventStatusItem.value = STATUS.online.rawValue
        eventStatusItem.show = STATUS.online.toString()
        eventStatusItem.sender = STATUS.online
        
        let eventContentItem = FormItem(title: "詳細內容")
        eventContentItem.uiProperties.cellType = FormItemCellType.more
        eventContentItem.segue = TO_TEXT_INPUT
        eventContentItem.sender = ["type":TEXT_INPUT_TYPE.timetable_coach,"text":""]
        eventContentItem.isRequired = false
        
        formItems = [eventTitleItem, eventWeekdayItem, eventStartTimeItem, eventEndTimeItem, eventLimitItem, eventColorItem, eventStatusItem, eventContentItem]
    }
}
