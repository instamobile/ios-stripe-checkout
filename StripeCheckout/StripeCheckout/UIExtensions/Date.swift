//
//  Date.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/11/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var threeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var fourDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var twoHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -2, to: noon)!
    }
    var fiveHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -5, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var oneYearAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -12, to: noon)!
    }
    var oneWeekAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var oneMonthAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: noon)!
    }
    var threeMonthsAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -3, to: noon)!
    }
    var infiniteAgo: Date {
        return Calendar.current.date(byAdding: .year, value: 100, to: noon)!
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
