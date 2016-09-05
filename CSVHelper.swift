//
//  CSVHelper.swift
//  UNC Campus Rec Attendence
//
//  Created by Chase on 9/4/16.
//  Copyright © 2016 LetsHangLLC. All rights reserved.
//

import Foundation

public class CSVReader{
    public static func getFacilities() -> [Facility]{
        let csvString = self.runFunctionOnRowsFromFile(["Facility", "Hour Type", "DAY", "1", "2", "3", "4", "5" , "6", "7", "8", "9",
             "10","11", "12", "13", "14", "15" , "16", "17", "18", "19", "20", "21", "22", "23", "24", "empty"]);
        
        let facilities = self.stringToFacilities(csvString);
        return facilities;
    }
    
    class func debug(string:String){
        print("CSVScanner: \(string)")
    }
    
    /* REturn the facilities given the csv strings */
    class func stringToFacilities(rows: [String]) -> [Facility]{
        var facilities = [Facility]();
        var rowIndex  = 1;
        for _ in 0...5{
            var avgNormalHours = [[Int]](count: 7, repeatedValue: [Int](count: 24, repeatedValue: 0));
            var avgFinalHours = [[Int]](count: 7, repeatedValue: [Int](count: 24, repeatedValue: 0));
            var avgSummerHours = [[Int]](count: 7, repeatedValue: [Int](count: 24, repeatedValue: 0));
            var avgBreakHours = [[Int]](count: 7, repeatedValue: [Int](count: 24, repeatedValue: 0));
            
            var facilityName = "";
            
            for d in 0...6{
                let row = rows[rowIndex];
                let objectColumns = row.componentsSeparatedByString(",")
                for j in 0...23{
                    avgNormalHours[d][j] = Int(objectColumns[j+3])!;
                }
                facilityName = objectColumns[0];
                rowIndex += 1;
            }
            for d in 0...6{
                let row = rows[rowIndex];
                let objectColumns = row.componentsSeparatedByString(",")
                for j in 0...23{
                    avgFinalHours[d][j] = Int(objectColumns[j+3])!;
                }
                facilityName = objectColumns[0];
                rowIndex += 1;
            }
            for d in 0...6{
                let row = rows[rowIndex];
                let objectColumns = row.componentsSeparatedByString(",")
                for j in 0...23{
                    avgBreakHours[d][j] = Int(objectColumns[j+3])!;
                }
                facilityName = objectColumns[0];
                rowIndex += 1;
            }
            for d in 0...6{
                let row = rows[rowIndex];
                let objectColumns = row.componentsSeparatedByString(",")
                for j in 0...23{
                    avgSummerHours[d][j] = Int(objectColumns[j+3])!;
                }
                facilityName = objectColumns[0];
                rowIndex += 1;
            }
            let avgHours = [avgNormalHours, avgFinalHours, avgBreakHours, avgSummerHours]
            facilities.append(Facility(avgNormalHours: avgNormalHours, avgFinalHours: avgFinalHours, avgBreakHours: avgBreakHours, avgSummerHours: avgSummerHours, avgHours: avgHours,
                                      name: facilityName));
            
            
        }//END Facility for loop
        
        
        return facilities;
    }
    
    /* Return the csv as strings */
    class func runFunctionOnRowsFromFile(theColumnNames:[String]) -> [String] {
        let theFileName = "avg_usage";
        var csvString = [String]();
        
        if let strBundle = NSBundle.mainBundle().pathForResource(theFileName, ofType: "csv") {
            
            let encodingError:NSError? = nil
            
            do{
                if let fileObject = try NSString(contentsOfFile: strBundle, encoding: NSUTF8StringEncoding) as NSString!{
                    
                    var fileObjectCleaned = fileObject.stringByReplacingOccurrencesOfString("\r", withString: "\n")
                    
                    fileObjectCleaned = fileObjectCleaned.stringByReplacingOccurrencesOfString("\n\n", withString: "\n")
                    
                    let objectArray = fileObjectCleaned.componentsSeparatedByString("\n")
                    
                    let s =  "rows " + objectArray.count.description + " \n";
                    print(s);
                    
                    for anObjectRow in objectArray {
                        
                        csvString.append(anObjectRow);
                        
//                        let objectColumns = anObjectRow.componentsSeparatedByString(",")
//                        
//                        var aDictionaryEntry = Dictionary<String, String>()
//                        
//                        var columnIndex = 0
//                        print(objectColumns.count.description);
//                        
//                        for anObjectColumn in objectColumns {
//                            
//                            aDictionaryEntry[theColumnNames[columnIndex]] = anObjectColumn.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
//                            
//                            columnIndex += 1;
//                        }
//                        
//                        if aDictionaryEntry.count>1{
//                            
//                        }else{
//                            
//                            CSVReader.debug("No data extracted from row: \(anObjectRow) -> \(objectColumns)")
//                        }
                    }
                }else{
                    CSVReader.debug("Unable to load csv file from path: \(strBundle)")
                    
                    if let errorString = encodingError?.description {
                        
                        CSVReader.debug("Received encoding error: \(errorString)")
                    }
                }

            } catch {
                CSVReader.debug("ERROR");
            }
            
        }else{
            CSVReader.debug("Unable to get path to csv file: \(theFileName).csv")
        }
        return csvString;
    }
}



