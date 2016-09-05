//
//  GraphCode.swift
//  UNC Campus Rec Attendence
//
//  Created by Chase on 9/5/16.
//  Copyright © 2016 LetsHangLLC. All rights reserved.
//

import Foundation
import Charts
import UIKit

public class TimeAxisFormatter : NSObject, IAxisValueFormatter{
    var values: [String] = [];
    
    @objc public func stringForValue(value: Double, axis: AxisBase?) -> String {
        let value = Int(value);
        if(value < 12){
            return String(format: "%d ", value) + "am";
        }else if(value < 24){
            if(value == 12){
                return String(format: "%d ", value) + "pm";
            }else{
                return String(format: "%d ", value%12) + "pm";
            }
        }else{
            return String(format: "%d ", 12) + "am";
        }
    }
    
    
    public func getDecimalDigits() -> Int{
        return 0;
    }
}
