//
//  TimeTableFrom.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class TimeTableForm: BaseForm {
    
    override func configureItems() {
        
        let eventTitleItem = TextFieldFormItem(name: TT_TITLE, title: "標題", placeholder: "請輸入標題")
//        eventTitleItem.valueCompletion = {
//            [weak self, weak eventTitleItem] value in self?.eventTitle = value
//            eventTitleItem?.value = value
//        }
        
        let eventWeekdayItem = WeekdayFormItem(title: "星期幾", name: TT_WEEKDAY)
        let eventStartDateItem = DateFormItem(name: TT_START_DATE, title: "開始日期", dateType: SELECT_DATE_TYPE.start)
        let eventEndDateItem = DateFormItem(name: TT_END_DATE, title: "結束日期", dateType: SELECT_DATE_TYPE.end)
        
        let eventStartTimeItem = TimeFormItem(name: TT_START_TIME, title: "開始時間", timeType: SELECT_TIME_TYPE.play_start, tooltip: "設定出現在行事曆的日期，若不設定，就會一直出現")
        
        let eventEndTimeItem = TimeFormItem(name: TT_END_TIME, title: "結束時間", timeType: SELECT_TIME_TYPE.play_end)
        
        let eventChargeItem = TextFieldFormItem(name: TT_CHARGE, title: "費用", placeholder: "", value: nil, keyboardType: .numberPad, tooltip: "限填數字，如要加以說明，請在內容處填寫")
        let eventLimitItem = TextFieldFormItem(name: TT_LIMIT, title: "限制人數", placeholder: "", value: nil, keyboardType: .numberPad, tooltip: "無限制填-1，若不想提供報名，請填0")
        
        let eventColorItem = ColorFormItem(tooltip: "使用色塊來區分不同的課程")
        
        let eventStatusItem = StatusFormItem()
        
        let eventContentItem = ContentFormItem(name: TT_CONTENT, title: "詳細內容", type: TEXT_INPUT_TYPE.timetable_coach)
        
        formItems = [eventTitleItem, eventWeekdayItem, eventStartDateItem, eventEndDateItem, eventStartTimeItem, eventEndTimeItem, eventChargeItem, eventLimitItem, eventColorItem, eventStatusItem, eventContentItem]
    }
    
    override func fillValue() {
        super.fillValue()
    }
    
    override func isValid() -> (Bool, String?) {
        
        //check if empty
        let (isValid, msg) = super.isValid()
        if !isValid {
            return (isValid, msg)
        }
        
        //check end early to start
        var start: Date?
        var end: Date?
        for formItem in formItems {
            if formItem.title == "開始時間" {
                start = formItem.value?.toDateTime(format: "HH:mm")
            }
            if formItem.title == "結束時間" {
                end = formItem.value?.toDateTime(format: "HH:mm")
            }
        }
        if start != nil && end != nil {
            if start! > end! {
                return (isValid, "結束時間不能早於開始時間")
            }
        }
        
//        var isValid1 = false
//        for forItem in formItems {
//            if forItem.oldValue != nil {
//                if forItem.isRequired && forItem.value != nil {
//                    if forItem.value != forItem.oldValue {
//                        isValid1 = true
//                        break
//                    }
//                }
//            }
//        }
//        if !isValid1 {
//            return (isValid1, "沒有修改任何值，不用提交")
//        }
        
        return (true, nil)
    }
}
