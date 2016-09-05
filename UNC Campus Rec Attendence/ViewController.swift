//
//  ViewController.swift
//  UNC Campus Rec Attendence
//
//  Created by Chase on 9/3/16.
//  Copyright © 2016 LetsHangLLC. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    
    @IBOutlet weak var imgNextDay: UIImageView!
    @IBOutlet weak var imgPrevDay: UIImageView!
    
    var calendar = NSCalendar.currentCalendar();
    var dateAdd = 0;
    
    /* Facilities */
    private var facilities = [Facility]();
    private let facilityNamesSet = FacilityNames.getFacilityNames();
    private var facilityTimesDict: [String: FacilityTime] = [:];
    private var currentFacility: String = "";
    private var facilityId: Int = 0;
    
    /* Day Variables */
    private var openTime: String = "";
    private var closeTime: String = "";
    private var dayOfWeek: Int = 0;
    private var startX: Int = 0;
    private var endX : Int = 24;
    private var currentHourType : HourType = HourType.NORMAL;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Load facilities from csv */
        facilities = CSVReader.getFacilities();
        
        /* Set up chart */
        self.configureChart();
        setupViews();
        requestData();
    }
    
    //MARK: SETUP VIEWS 
    func setupViews(){
        dateLabel.text = getFormattedDate();
        
        let nextDayOnClick = UITapGestureRecognizer(target: self, action:#selector(ViewController.nextDayClicked(_:)));
        imgNextDay.userInteractionEnabled = true;
        imgNextDay.addGestureRecognizer(nextDayOnClick);
        
        let prevDayOnClick = UITapGestureRecognizer(target: self, action:#selector(ViewController.prevDayClicked(_:)));
        imgPrevDay.userInteractionEnabled = true;
        imgPrevDay.addGestureRecognizer(prevDayOnClick);
        
        self.locationPicker.delegate = self;
        self.locationPicker.dataSource = self;
    }
    
    func prevDayClicked(img: AnyObject){
        print("Prev day Pressed");
        dateAdd -= 1;
        updateData();
    }
    
    func nextDayClicked(img: AnyObject){
        print("Next Day Pressed");
        dateAdd += 1;
        updateData();
    }
    
    func configureChart(){
        barChartView.legend.enabled = false;
        barChartView.xAxis.labelPosition = .Bottom;
        barChartView.xAxis.drawGridLinesEnabled = false;
        //barChartView.xAxis.labelCount = (endX-startX+1)/2;
        
        barChartView.descriptionText = "";
        barChartView.rightAxis.enabled = false;
        
        
        
    }
    
    //CONFIGURE Location Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return facilities.count;
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let facilityName = facilities[row].name;
        return NSAttributedString(string: facilityName, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(facilities[row].name);
        self.facilityId = row;
        currentFacility = facilities[row].name;
        updateValues();
    }

    //MARK: Get Data from Server
    
    // Request the initial data from the server
    func requestData(){
        let destFormat = NSDateFormatter()
        destFormat.dateFormat = "yyyy-MM-dd";
        destFormat.timeZone = NSTimeZone()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.NSDayCalendarUnit, value: dateAdd, toDate: NSDate(), options: []);
        let dateString  = destFormat.stringFromDate(date!);
        
        let requestURL = "https://www.googleapis.com/calendar/v3/calendars/0tsujpkp3toi9u3orsq3bapl04@" +
            "group.calendar.google.com/events?key=AIzaSyDb5Wf60m9_IOGjP3HSQsSjmBJN_Lg4FJc&sing" +
            "leEvents=true&timeMax="+dateString+"T23:59:59-04:00&timeMin="+dateString+"T00:00:00-04:00";
        
        //Create NSURL Object
        let myUrl = NSURL(string:requestURL)
        
        //Create URL request
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                print("Error=\(error)")
                return
            }
            
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("Response String =\(responseString)")
            
            //Convert json to nsDictionary
            do{
                print("Inside do")
                if let convertedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                    print("\nJSON: " + convertedJson.count.description)
                    /* put the json into the machines array */
                    self.parseJSON(convertedJson)
                    
                }else{
                    print("couldn't parse");
                }
            }catch let error as NSError{
                print(error.localizedDescription)
                
            }
        }
        task.resume();
    }
    
    /* Convert the JSON into the machines array  */
    func parseJSON(jsonObject: NSDictionary){
        print("parse JSON")
        facilityTimesDict = [:]
        if let itemsArray = jsonObject["items"] as? NSArray{
            for facilityJson in itemsArray {
                let facilityName = facilityJson["summary"] as? String;
                if(facilityNamesSet.containsObject(facilityName!)){
                
                    var start = "";
                    var end = "";
                    if let startDict = facilityJson["start"] as? NSDictionary{
                        start = (startDict["dateTime"] as? String)!;
                    }
                    if let startDict = facilityJson["end"] as? NSDictionary{
                        end = (startDict["dateTime"] as? String)!;
                    }
                    
                    facilityTimesDict[facilityName!] = FacilityTime(openTime: start, closeTime: end, name: facilityName!);
                }
            }

        }else{
            print("no items");
        }
        /* Dismiss the progress animation */

        self.updateValues();
        
    }
    
    //MARK: Update Views
    func updateValues(){
        if(currentFacility == ""){
            currentFacility = facilities[0].name;
        }
        if((facilityTimesDict.count==0 || facilityTimesDict[currentFacility] == nil)){
            print("Facility not available");
            dispatch_async(dispatch_get_main_queue(), {
                
                /* TODO: Update the graph */
                self.openTimeLabel.text = "CLOSED";
                self.closeTimeLabel.text = "CLOSED";
                self.startX = 0;
                self.endX = 0;
                self.barChartView.clear();
                return;
                
            })

        }else{

            let date = calendar.dateByAddingUnit(NSCalendarUnit.NSDayCalendarUnit, value: dateAdd, toDate: NSDate(), options: []);
            self.dayOfWeek = calendar.component(.Weekday, fromDate: date!) - 1;
            
            print ("Facility: " + currentFacility);
            print("Facility count: " + facilityTimesDict.count.description);
            let facilityTime = facilityTimesDict[currentFacility]!;
            openTime = facilityTime.getOpenTime();
            closeTime = facilityTime.getCloseTime();
            startX = facilityTime.getOpenHour();
            endX = facilityTime.getCloseHour();
            updateViews();
        }

    }
    
    private func updateViews(){
        dispatch_async(dispatch_get_main_queue(), {
            self.openTimeLabel.text = self.openTime;
            self.closeTimeLabel.text = self.closeTime;
            
            let hourType = self.currentHourType.rawValue;
            self.setChart(self.facilities[self.facilityId].avgHours[hourType][self.dayOfWeek]);
        })
    }
    
    func updateData(){
        self.requestData()
        dateLabel.text = getFormattedDate();
        let date = calendar.dateByAddingUnit(NSCalendarUnit.NSDayCalendarUnit, value: dateAdd, toDate: NSDate(), options: []);
        self.dayOfWeek = calendar.component(.Weekday, fromDate: date!) - 1;
    }
    

    
    
    func setChart(attendence : [Int]) {
        //barChartView.xAxis.valueFormatter = (TimeAxisFormatter.self as! IAxisValueFormatter);
        let formatter = TimeAxisFormatter();
        barChartView.xAxis.valueFormatter = formatter;
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        let length = endX - startX + 1;
        print("end x = " + String(endX));
        print(length);
        for i in 0..<length{
            let xVal = Double(i + startX);
            let dataEntry = BarChartDataEntry(x: xVal, y: Double(attendence[i + startX - 1]));
        
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData;
    }
    
    
    // MARK: Extra functions
    func getFormattedDate() -> String{
        let destFormat = NSDateFormatter()
        destFormat.dateFormat = "EEE, MMM dd, yyyy";
        destFormat.timeZone = NSTimeZone()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.NSDayCalendarUnit, value: dateAdd, toDate: NSDate(), options: []);
        let dateString  = destFormat.stringFromDate(date!);
        currentHourType = getHourTypeFromDate(date!);
        return dateString;
    }
    
    private func getHourTypeFromDate(date: NSDate) -> HourType {
        for facilityHourType in facilityHourTypes{
            if(facilityHourType.containsDate(date)){
                return facilityHourType.hourType;
            }
        }
        return HourType.NORMAL;
    }

}

