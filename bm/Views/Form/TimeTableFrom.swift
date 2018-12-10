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
        
        let eventWeekdayItem = WeekdayFormItem(title: "星期日期")
        //eventWeekdayItem.uiProperties.cellType = FormItemCellType.weekday
        //eventWeekdayItem.segue = TO_SELECT_WEEKDAY
        
        let eventStartTimeItem = TimeFormItem(title: "開始時間", timeType: SELECT_TIME_TYPE.play_start)
        //eventStartTimeItem.uiProperties.cellType = FormItemCellType.time
        //eventStartTimeItem.segue = TO_SELECT_TIME
        //eventStartTimeItem.timeType = SELECT_TIME_TYPE.play_start
        //eventStartTimeItem.sender = ["type":eventStartTimeItem.timeType!,"time":""]
        
        let eventEndTimeItem = TimeFormItem(title: "結束時間", timeType: SELECT_TIME_TYPE.play_end)
        //eventEndTimeItem.uiProperties.cellType = FormItemCellType.time
        //eventEndTimeItem.segue = TO_SELECT_TIME
        //eventEndTimeItem.timeType = SELECT_TIME_TYPE.play_end
        //eventEndTimeItem.sender = ["type":eventEndTimeItem.timeType!,"time":""]
        
        let eventLimitItem = FormItem(title: "限制人數", placeholder: "無限制請填-1")
        eventLimitItem.uiProperties.cellType = FormItemCellType.textField
        eventLimitItem.uiProperties.keyboardType = .numberPad
        eventLimitItem.value = eventLimit
        eventLimitItem.valueCompletion = {
            [weak self, weak eventLimitItem] value in self?.eventLimit = value
            eventLimitItem?.value = value
        }
        
        let eventColorItem = ColorFormItem(title: "顏色")
        
        let eventStatusItem = StatusFormItem(title: "狀態")
//        eventStatusItem.uiProperties.cellType = FormItemCellType.status
//        eventStatusItem.segue = TO_SELECT_STATUS
//        eventStatusItem.status = STATUS.online
//        eventStatusItem.value = STATUS.online.rawValue
//        eventStatusItem.show = STATUS.online.toString()
//        eventStatusItem.sender = STATUS.online
        
        let eventContentItem = FormItem(title: "詳細內容")
        eventContentItem.uiProperties.cellType = FormItemCellType.more
        eventContentItem.segue = TO_TEXT_INPUT
        eventContentItem.sender = ["type":TEXT_INPUT_TYPE.timetable_coach,"text":""]
        eventContentItem.isRequired = false
        
        formItems = [eventTitleItem, eventWeekdayItem, eventStartTimeItem, eventEndTimeItem, eventLimitItem, eventColorItem, eventStatusItem, eventContentItem]
    }
}
