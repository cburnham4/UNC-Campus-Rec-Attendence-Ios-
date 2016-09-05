//
//  Facility.swift
//  UNC Campus Rec Attendence
//
//  Created by Chase on 9/4/16.
//  Copyright © 2016 LetsHangLLC. All rights reserved.
//
import Foundation
public struct Facility{
    var avgNormalHours = [[Int]]();
    var avgFinalHours = [[Int]]();
    var avgBreakHours = [[Int]]();
    var avgSummerHours = [[Int]]();
    
    var avgHours = [[[Int]]]();
    var name : String;
    
    public func toString() -> String{
        return name;
    }
}

public struct FacilityNames {
    static let src = "Student Recreation Center";
    static let rams = "Rams Head Recreation Center";
    static let fetzer = "Fetzer Hall";
    static let bowman = "Bowman Gray Memorial Pool";
    static let woollen = "Woollen Gym";
    static let kessing = "Kessing Outdoor Pool";
    
    public static func getFacilityNames() -> NSMutableSet{
        let s  = NSMutableSet();
        s.addObject(src);
        s.addObject(rams);
        s.addObject(fetzer);
        s.addObject(bowman);
        s.addObject(woollen);
        s.addObject(kessing);
        return s;
    }
}

public struct FacilityTime{
    var openTime: String;
    var closeTime:String;
    var name: String;
    
    public func getOpenTime() -> String {
        let open = parseTimeString(openTime);
        return open;
    }
    
    public func getCloseTime() -> String {
        let close = parseTimeString(closeTime);
        return close;
    }
    
    public func getOpenHour() -> Int{
        let time = self.getOpenTime();
        let startIndex  = time.startIndex.advancedBy(2);
        var hour = Int(time.substringToIndex(startIndex))!;
        let endIndex = time.endIndex.advancedBy(-2);
        if(hour != 12 && time.substringFromIndex(endIndex) == "PM"){
            hour += 12;
        }
        if(hour == 12 && time.substringFromIndex(endIndex)  == "AM"){
            hour += 12;
        }
        return hour;
    }
    
    public func getCloseHour() -> Int{
        let time = self.getCloseTime();
        let startIndex  = time.startIndex.advancedBy(2);
        var hour = Int(time.substringToIndex(startIndex))!;
        let endIndex = time.endIndex.advancedBy(-2);
        if(hour != 12 && time.substringFromIndex(endIndex) == "PM"){
            hour += 12;
        }
        if(hour == 12 && time.substringFromIndex(endIndex)  == "AM"){
            hour += 12;
        }
        return hour;
    }
    
    private func parseTimeString(dateTime: String) -> String{
        let index11 = dateTime.startIndex.advancedBy(11);
        let index12 = dateTime.startIndex.advancedBy(12);
        
        var hour = Int(dateTime.substringWithRange(index11...index12))! as Int;
        let index14 = dateTime.startIndex.advancedBy(14);
        let index15 = dateTime.startIndex.advancedBy(15)
        
        let minute = Int(dateTime.substringWithRange(index14...index15))! as Int;

        var amPM = "AM";
        if(hour == 0){
            hour = 12;
        }else if(hour == 12){
            amPM = "PM";
        }else if(hour > 12){
            amPM = "PM";
            hour %= 12;
        }
        if(hour == 0){
            hour = 12;
            amPM = "AM";
    
        }
        return String(format: "%02d:%02d ", hour, minute) + amPM;
    }

}
