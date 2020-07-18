//
//  GetDate.swift
//  SwiftUICloudKitDemo
//
//  Created by Paul Norris on 15/07/2020.
//

import SwiftUI
var increment = 0
class DateOperation {

static func getTheDate (direction: String) -> String {
     let previousSaturday = Date.today().previous(.saturday)
     
     var components = Calendar.current.dateComponents([.day], from: previousSaturday)
     if direction == "forward"
     {
         increment += 7
         components.day = increment
     } else if direction == "backward"
     {
         increment -= 7
         components.day = increment
     } else if direction == "reset"
     {
         increment = 0
         components.day = increment
     } else { components.day = 0 }
     let nextSaturday = Calendar.current.date(byAdding: components, to: previousSaturday)
     let daySuffix: String
     let cal = Calendar.current
     let day = cal.component(.day, from: nextSaturday!)
     switch day {
         case 11...13: daySuffix = "th"
     default:
         switch day % 10 {
         
         case 1: daySuffix = "st"
         case 2: daySuffix = "nd"
         case 3: daySuffix = "rd"
         default: daySuffix = "th"
         }
     }
     let formatter = DateFormatter()
        formatter.dateFormat = "E, d'\(daySuffix)' MMM yyyy"
     let fullnextSaturday = formatter.string(from: nextSaturday!)
     return(fullnextSaturday)
 
}
}

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_GB")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}


