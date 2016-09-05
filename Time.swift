//
//  Time.swift
//  UNC Campus Rec Attendence
//
//  Created by Chase on 9/5/16.
//  Copyright © 2016 LetsHangLLC. All rights reserved.
//

import Foundation

enum HourType: Int{
    case NORMAL = 0
    case FINALS = 1
    case BREAK = 2
    case SUMMER = 3
}

public struct DateTuple{
    private var startDate = NSDate();
    private var endDate = NSDate();
    
    init(first: String, second: String){
        startDate = stringToDate(first);
        endDate = stringToDate(second)
    }
    
    private func stringToDate(sDate : String) -> NSDate{
        let dateFormatter  = NSDateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy";
        let date = dateFormatter.dateFromString(sDate)! as NSDate;
        return date;
    }
    
    public func isContained(date: NSDate) -> Bool{
        let afterStart = startDate.compare(date) == .OrderedAscending;
        let sameStart = startDate.compare(date) == .OrderedSame;
        let beforeEnd = endDate.compare(date) == .OrderedDescending;
        let sameEnd = endDate.compare(date) == .OrderedSame;
        return (sameEnd || sameStart) || (afterStart && beforeEnd);
    }
}

public struct FacilityHourType{
    var hourType: HourType;
    var dateTuples : [DateTuple];
    
    public func containsDate(date: NSDate) -> Bool{
        for dateTuple in dateTuples{
            if(dateTuple.isContained(date)){
                return true;
            }
        }
        return false;
    }
}

public struct HourTypeDates{
    /* Date dd-MM-yyyy */
    static let normalHourDates: FacilityHourType = FacilityHourType(hourType: HourType.NORMAL,
        dateTuples: [DateTuple(first: "23-08-2016",second: "31-08-2016"),
            DateTuple(first: "01-09-2016", second: "02-09-2016"),
            DateTuple(first: "06-09-2016", second: "16-09-2016"),
            DateTuple(first: "18-09-2016", second: "23-09-2016"),
            DateTuple(first: "25-09-2016", second: "30-09-2016"),
            DateTuple(first: "01-10-2016", second: "07-10-2016"),
            DateTuple(first: "09-10-2016", second: "18-10-2016"),
            DateTuple(first: "24-10-2016", second: "30-10-2016"),
            DateTuple(first: "01-11-2016", second: "04-11-2016"),
            DateTuple(first: "08-11-2016", second: "18-11-2016"),
            DateTuple(first: "20-11-2016", second: "21-11-2016"),
            DateTuple(first: "28-11-2016", second: "30-11-2016"),
            DateTuple(first: "01-12-2016", second: "06-12-2016"),
            
            /* Second Semester */
            DateTuple(first: "11-01-2017", second: "15-01-2017"),
            DateTuple(first: "17-01-2017", second: "31-01-2017"),
            DateTuple(first: "01-02-2017", second: "14-02-2017"),
            DateTuple(first: "16-02-2017", second: "28-02-2017"),
            DateTuple(first: "01-03-2017", second: "09-03-2017"),
            DateTuple(first: "20-03-2017", second: "31-03-2017"),
            DateTuple(first: "01-04-2017", second: "13-04-2017"),
            DateTuple(first: "17-04-2017", second: "27-04-2017")]);

    
    
    static let finalsHourDates : FacilityHourType = FacilityHourType(hourType: HourType.FINALS,
                                                                     dateTuples:
        [DateTuple(first: "07-12-2016", second: "16-12-2016"), DateTuple(first: "28-04-2017", second: "06-05-2017")]);
    
    
    static let breakHourDates : FacilityHourType = FacilityHourType(hourType: HourType.BREAK, dateTuples: [
        DateTuple(first: "03-09-2016",second: "05-09-2016"),
        DateTuple(first: "20-10-2016", second: "23-10-2016"),
        DateTuple(first: "27-11-2016", second: "27-11-2016"),
        
        DateTuple(first: "03-01-2017", second: "10-01-2017"),
        DateTuple(first: "16-01-2017", second: "16-01-2017"),
        DateTuple(first: "11-03-2017", second: "19-03-2017"),
        DateTuple(first: "10-05-2017", second: "12-05-2017"),
        DateTuple(first: "15-06-2017", second: "16-05-2017")
        ]);
    
    static let summerHourDates : FacilityHourType = FacilityHourType(hourType: HourType.SUMMER, dateTuples: [
            DateTuple(first: "17-05-2017", second: "26-05-2017"),
            DateTuple(first: "30-05-2017",second: "31-05-2017"),
            DateTuple(first: "01-06-2017", second: "30-06-2017"),
            DateTuple(first: "01-07-2017",second: "03-07-2017"),
            DateTuple(first: "05-07-2017", second: "01-08-2017")
            ]);
    
}

public let facilityHourTypes : [FacilityHourType] = [HourTypeDates.normalHourDates, HourTypeDates.finalsHourDates, HourTypeDates.breakHourDates, HourTypeDates.summerHourDates];