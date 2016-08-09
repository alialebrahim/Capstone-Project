//
//  TimeIntervalManager.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/14/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation

class TimeIntervalManager {
    
    //correct time interval when from-time is less than to-time
    class func correctTimeInterval(FromTime FromTime: NSDate, ToTime: NSDate) -> Bool {
        if FromTime.isLessThanDate(ToTime) && !FromTime.equalToDate(ToTime) {
            return true
        }
        return false
    }
    /*
        Determine Whether Two Date Ranges Overlap:
        (StartA <= EndB) and (EndA >= StartB)
     
        Proof:
        Let ConditionA Mean that DateRange A Completely After DateRange B
        _                        |---- DateRange A ------|
        |---Date Range B -----|                           _
        (True if StartA > EndB)
     
        Let ConditionB Mean that DateRange A is Completely Before DateRange B
        |---- DateRange A -----|                       _
        _                          |---Date Range B ----|
        (True if EndA < StartB)
     
        Then Overlap exists if Neither A Nor B is true -
        (If one range is neither completely after the other,
        nor completely before the other, then they must overlap.)
     
        Now one of De Morgan's laws says that:
     
        Not (A Or B) <=>  Not A And Not B
     
        Which translates to: (StartA <= EndB)  and  (EndA >= StartB)
     
        NOTE: This includes conditions where the edges overlap exactly. If you wish to exclude that,
        change the >= operators to >, and <= to <
    */
    //determine if two given time conflicts using the above algorithem
    //this function has a bug, if fromTime is greater than toTim. Ex: 23:00 -> 02:00
    class func conflicts(TimeIntervalArray TimeIntervalArray: [(from: NSDate,to: NSDate)], TimeInterval: (fromB: NSDate, toB: NSDate)) -> Bool {
        for (fromA, toA) in TimeIntervalArray {
            if ((fromA.isLessThanDate(TimeInterval.toB) || fromA.equalToDate(TimeInterval.toB)) &&
                (TimeInterval.fromB.isLessThanDate(toA) || toA.equalToDate(TimeInterval.fromB)))
            {
                return true
            }
        }
        return false
    }
}