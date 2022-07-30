//
//  MissData.swift
//  CalendError
//
//  Created by JMMac036 on 2022/07/15.
//

import Foundation
import RealmSwift

class missData: Object {
    @objc dynamic var dateValue = 20180101 //Int
    @objc dynamic var start_time: String = ""
    @objc dynamic var end_time: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var miss: String = ""
    var date: Date? {
        get {
            let year = (dateValue / 10000)
            let month = (dateValue % 10000) / 100
            let day = (dateValue % 100)
            let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            return dateComponent.date
        }
        set {
            if let date = newValue {
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                let day = Calendar.current.component(.day, from: date)
                dateValue = year * 10000 + month * 100 + day
            }
        }
    }
}
