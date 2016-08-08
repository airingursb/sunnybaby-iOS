//
//  FutureViewController.swift
//  sunshine
//
//  Created by Airing on 16/8/1.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftyJSON

class FutureViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var d1Image: UIImageView!
    @IBOutlet weak var d1Week: UILabel!
    @IBOutlet weak var d1Weather: UILabel!
    @IBOutlet weak var d2Image: UIImageView!
    @IBOutlet weak var d2Week: UILabel!
    @IBOutlet weak var d2Weather: UILabel!
    @IBOutlet weak var d3Image: UIImageView!
    @IBOutlet weak var d3Week: UILabel!
    @IBOutlet weak var d3Weather: UILabel!
    @IBOutlet weak var d4Image: UIImageView!
    @IBOutlet weak var d4Week: UILabel!
    @IBOutlet weak var d4Weather: UILabel!
    @IBOutlet weak var d5Image: UIImageView!
    @IBOutlet weak var d5Week: UILabel!
    @IBOutlet weak var d5Weather: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblAir: UILabel!
    @IBOutlet weak var lblProvince: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    var weekToken:Int = 1
    var dataUitl: DataUtil = DataUtil()
    var city = ""
    var weathers:Array = [""]
    var temperatures:Array = [""]
    var weeks:Array = [""]
    var weatherImages:Array = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FutureViewController.back))
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)
        
        self.city = dataUitl.cacheGetString("city")
        self.lblProvince.text = dataUitl.cacheGetString("province").stringByApplyingTransform("Hans-Hant", reverse: false)!
        self.lblCity.text = (dataUitl.cacheGetString("city") + "市").stringByApplyingTransform("Hans-Hant", reverse: false)!
        
        getWeatherByJuhe(self.city)
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func d1Click() {
        self.weekToken = 1
        changeState(self.weekToken)
        if dataUitl.cacheGetInt("net") == 1 {
            self.lblWeek.text = "明天"
            self.lblWeather.text = self.weathers[1]
            self.lblTemperature.text = self.temperatures[1]
            self.imgWeather.image = UIImage(named:weatherImages[1])
        }
    }
    
    @IBAction func d2Click() {
        self.weekToken = 2
        changeState(self.weekToken)
        if dataUitl.cacheGetInt("net") == 1 {
            self.lblWeek.text = "周" + self.weeks[2]
            self.lblWeather.text = self.weathers[2]
            self.lblTemperature.text = self.temperatures[2]
            self.imgWeather.image = UIImage(named:weatherImages[2])
        }
    }
    
    @IBAction func d3Click() {
        self.weekToken = 3
        changeState(self.weekToken)
        if dataUitl.cacheGetInt("net") == 1 {
            self.lblWeek.text = "周" + self.weeks[3]
            self.lblWeather.text = self.weathers[3]
            self.lblTemperature.text = self.temperatures[3]
            self.imgWeather.image = UIImage(named:weatherImages[3])
        }
    }
    
    @IBAction func d4Click() {
        self.weekToken = 4
        changeState(self.weekToken)
        if dataUitl.cacheGetInt("net") == 1 {
            self.lblWeek.text = "周" + self.weeks[4]
            self.lblWeather.text = self.weathers[4]
            self.lblTemperature.text = self.temperatures[4]
            self.imgWeather.image = UIImage(named:weatherImages[4])
        }
    }
    
    @IBAction func d5Click() {
        self.weekToken = 5
        changeState(self.weekToken)
        if dataUitl.cacheGetInt("net") == 1 {
            self.lblWeek.text = "周" + self.weeks[5]
            self.lblWeather.text = self.weathers[5]
            self.lblTemperature.text = self.temperatures[5]
            self.imgWeather.image = UIImage(named:weatherImages[5])
        }
    }
    
    func changeState(weekToken:Int) {
        switch weekToken {
        case 1:
            d1Image.image = UIImage(named:"rect_dark")
            d2Image.image = UIImage(named:"rect_light")
            d3Image.image = UIImage(named:"rect_light")
            d4Image.image = UIImage(named:"rect_light")
            d5Image.image = UIImage(named:"rect_light")
            d1Week.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d2Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d1Weather.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d2Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        case 2:
            d1Image.image = UIImage(named:"rect_light")
            d2Image.image = UIImage(named:"rect_dark")
            d3Image.image = UIImage(named:"rect_light")
            d4Image.image = UIImage(named:"rect_light")
            d5Image.image = UIImage(named:"rect_light")
            d1Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Week.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d3Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d1Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Weather.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d3Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            
        case 3:
            d1Image.image = UIImage(named:"rect_light")
            d2Image.image = UIImage(named:"rect_light")
            d3Image.image = UIImage(named:"rect_dark")
            d4Image.image = UIImage(named:"rect_light")
            d5Image.image = UIImage(named:"rect_light")
            d1Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Week.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d4Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d1Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Weather.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d4Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            
        case 4:
            d1Image.image = UIImage(named:"rect_light")
            d2Image.image = UIImage(named:"rect_light")
            d3Image.image = UIImage(named:"rect_light")
            d4Image.image = UIImage(named:"rect_dark")
            d5Image.image = UIImage(named:"rect_light")
            d1Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Week.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d5Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d1Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Weather.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d5Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            
        case 5:
            d1Image.image = UIImage(named:"rect_light")
            d2Image.image = UIImage(named:"rect_light")
            d3Image.image = UIImage(named:"rect_light")
            d4Image.image = UIImage(named:"rect_light")
            d5Image.image = UIImage(named:"rect_dark")
            d1Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Week.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Week.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            d1Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d2Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d3Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d4Weather.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            d5Weather.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
        default:
            break
        }
    }
    
    func getWeatherByJuhe(city:String) {
        let url = "https://op.juhe.cn/onebox/weather/query?key=178058f2f64003a22805b167c2583075&cityname=" + city
        let nsurl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        let jsonData = NSData(contentsOfURL: nsurl!)
        
        if jsonData != nil {
            dataUitl.cacheSetInt("net", value: 1)
            let json = JSON(data:jsonData!)
            
            var d1weather = String(json["result"]["data"]["weather"][0]["info"]["day"][1])
            var d2weather = String(json["result"]["data"]["weather"][1]["info"]["day"][1])
            var d3weather = String(json["result"]["data"]["weather"][2]["info"]["day"][1])
            var d4weather = String(json["result"]["data"]["weather"][3]["info"]["day"][1])
            var d5weather = String(json["result"]["data"]["weather"][4]["info"]["day"][1])
            let weatherImage1 = String(json["result"]["data"]["weather"][0]["info"]["day"][0])
            let weatherImage2 = String(json["result"]["data"]["weather"][1]["info"]["day"][0])
            let weatherImage3 = String(json["result"]["data"]["weather"][2]["info"]["day"][0])
            let weatherImage4 = String(json["result"]["data"]["weather"][3]["info"]["day"][0])
            let weatherImage5 = String(json["result"]["data"]["weather"][4]["info"]["day"][0])
            let d1temperatureNight = String(json["result"]["data"]["weather"][0]["info"]["night"][2])
            let d2temperatureNight = String(json["result"]["data"]["weather"][1]["info"]["night"][2])
            let d3temperatureNight = String(json["result"]["data"]["weather"][2]["info"]["night"][2])
            let d4temperatureNight = String(json["result"]["data"]["weather"][3]["info"]["night"][2])
            let d5temperatureNight = String(json["result"]["data"]["weather"][4]["info"]["night"][2])
            let d1temperatureDay = String(json["result"]["data"]["weather"][0]["info"]["day"][2])
            let d2temperatureDay = String(json["result"]["data"]["weather"][1]["info"]["day"][2])
            let d3temperatureDay = String(json["result"]["data"]["weather"][2]["info"]["day"][2])
            let d4temperatureDay = String(json["result"]["data"]["weather"][3]["info"]["day"][2])
            let d5temperatureDay = String(json["result"]["data"]["weather"][4]["info"]["day"][2])
            let d1week = String(json["result"]["data"]["weather"][0]["week"])
            let d2week = String(json["result"]["data"]["weather"][1]["week"])
            let d3week = String(json["result"]["data"]["weather"][2]["week"])
            let d4week = String(json["result"]["data"]["weather"][3]["week"])
            let d5week = String(json["result"]["data"]["weather"][4]["week"])
            
            var d1temperature = "当日温度" + d1temperatureNight + "~" + d1temperatureDay + "℃"
            var d2temperature = "当日温度" + d2temperatureNight + "~" + d2temperatureDay + "℃"
            var d3temperature = "当日温度" + d3temperatureNight + "~" + d3temperatureDay + "℃"
            var d4temperature = "当日温度" + d4temperatureNight + "~" + d4temperatureDay + "℃"
            var d5temperature = "当日温度" + d5temperatureNight + "~" + d5temperatureDay + "℃"
            d1weather = d1weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d2weather = d2weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d3weather = d3weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d4weather = d4weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d5weather = d5weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d1temperature = d1temperature.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d2temperature = d2temperature.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d3temperature = d3temperature.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d4temperature = d4temperature.stringByApplyingTransform("Hans-Hant", reverse: false)!
            d5temperature = d5temperature.stringByApplyingTransform("Hans-Hant", reverse: false)!
            
            if weatherImage1 == "0" {
                self.weatherImages.append("wid_00")
            } else if weatherImage1 == "1" {
                self.weatherImages.append("wid_01")
            } else if weatherImage1 == "2" {
                self.weatherImages.append("wid_02")
            } else if weatherImage1 == "4" {
                self.weatherImages.append("wid_04")
            } else {
                self.weatherImages.append("wid_03")
            }
            
            if weatherImage2 == "0" {
                self.weatherImages.append("wid_00")
            } else if weatherImage2 == "1" {
                self.weatherImages.append("wid_01")
            } else if weatherImage2 == "2" {
                self.weatherImages.append("wid_02")
            } else if weatherImage2 == "4" {
                self.weatherImages.append("wid_04")
            } else {
                self.weatherImages.append("wid_03")
            }
            
            if weatherImage3 == "0" {
                self.weatherImages.append("wid_00")
            } else if weatherImage3 == "1" {
                self.weatherImages.append("wid_01")
            } else if weatherImage3 == "2" {
                self.weatherImages.append("wid_02")
            } else if weatherImage3 == "4" {
                self.weatherImages.append("wid_04")
            } else {
                self.weatherImages.append("wid_03")
            }
            
            if weatherImage4 == "0" {
                self.weatherImages.append("wid_00")
            } else if weatherImage4 == "1" {
                self.weatherImages.append("wid_01")
            } else if weatherImage4 == "2" {
                self.weatherImages.append("wid_02")
            } else if weatherImage4 == "4" {
                self.weatherImages.append("wid_04")
            } else {
                self.weatherImages.append("wid_03")
            }
            
            if weatherImage5 == "0" {
                self.weatherImages.append("wid_00")
            } else if weatherImage5 == "1" {
                self.weatherImages.append("wid_01")
            } else if weatherImage5 == "2" {
                self.weatherImages.append("wid_02")
            } else if weatherImage5 == "4" {
                self.weatherImages.append("wid_04")
            } else {
                self.weatherImages.append("wid_03")
            }
            
            self.weeks.append(d1week)
            self.weeks.append(d2week)
            self.weeks.append(d3week)
            self.weeks.append(d4week)
            self.weeks.append(d5week)
            
            self.weathers.append(d1weather)
            self.weathers.append(d2weather)
            self.weathers.append(d3weather)
            self.weathers.append(d4weather)
            self.weathers.append(d5weather)
            
            self.temperatures.append(d1temperature)
            self.temperatures.append(d2temperature)
            self.temperatures.append(d3temperature)
            self.temperatures.append(d4temperature)
            self.temperatures.append(d5temperature)
            
            self.d1Week.text = "周" + self.weeks[1]
            self.d1Weather.text = self.weathers[1]
            self.d2Week.text = "周" + self.weeks[2]
            self.d2Weather.text = self.weathers[2]
            self.d3Week.text = "周" + self.weeks[3]
            self.d3Weather.text = self.weathers[3]
            self.d4Week.text = "周" + self.weeks[4]
            self.d4Weather.text = self.weathers[4]
            self.d5Week.text = "周" + self.weeks[5]
            self.d5Weather.text = self.weathers[5]
            
            print("weeks:\(self.weeks)")
            print("weathers:\(self.weathers)")
            print("temperatures:\(self.temperatures)")
            d1Click()
        } else {
            dataUitl.cacheSetInt("net", value: 0)
            let alertControllerNetFailed = UIAlertController(title: "晴宝", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertControllerNetFailed.addAction(cancelAction)
            self.presentViewController(alertControllerNetFailed, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
