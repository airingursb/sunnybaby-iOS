//
//  ViewController.swift
//  sunshine
//
//  Created by Airing on 16/7/31.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import NVActivityIndicatorView

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var lblProvince: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblPm: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindPower: UILabel!
    @IBOutlet weak var lblAirCondition: UILabel!
    @IBOutlet weak var lblMoon: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var locationManager:CLLocationManager!
    var dataUtil: DataUtil = DataUtil()
    var city:String = ""
    var weatherImageToken = ""
    
    override func viewWillAppear(animated: Bool) {

        if dataUtil.cacheGetString("first") != nil {
            // 已使用搜索城市
            self.city = dataUtil.cacheGetString("city")!
            self.getWeather(self.city)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let mainColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        self.lblPm.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2));
        self.custonGestureLeft()

        if dataUtil.cacheGetString("first") == nil {
            // 首次登陆，自动定位城市
            self.locate()
        } else {
            // 已使用搜索城市
            self.city = dataUtil.cacheGetString("city")!
            self.getWeather(self.city)
        }
    }
    
    func locate() {
        locationManager = CLLocationManager()
        
        // 设置定位的精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 设置定位变化的最小距离 距离过滤器
        locationManager.distanceFilter = 50
        
        // 设置请求定位的状态
        locationManager.requestWhenInUseAuthorization()
        
        // 设置代理为当前对象
        locationManager.delegate = self;
        
        if CLLocationManager.locationServicesEnabled(){
            // 开启定位服务
            locationManager.startUpdatingLocation()
        }else{
            print("没有定位服务")
        }
    }
    
    /**
     定位失败调用的代理方法
     
     - parameter manager: CLLocationManager
     - parameter error:   NSError
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("定位失败调用的代理方法")
        dataUtil.cacheSetString("city", value: "广州")
        self.city = "广州"
        self.getWeather(self.city)
    }
    
    /**
     定位更新地理信息调用的代理方法
     
     - parameter manager:   CLLocationManager
     - parameter locations: CLLocation
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("定位更新地理信息调用的代理方法")
        if locations.count > 0 {
            let locationInfo = locations.last!
            print("经度：\(locationInfo.coordinate.longitude)，纬度：\(locationInfo.coordinate.latitude)")
            geocoding(locationInfo.coordinate.latitude, lon: locationInfo.coordinate.longitude)
        }
    }
    
    
    /**
     根据定位的经纬度获取城市名称
     
     - parameter lat: 纬度
     - parameter lon: 经度
     */
    func geocoding(lat:Double, lon:Double) {
        let url = "http://api.map.baidu.com/geocoder/v2/?ak=SifOGPQtBo3soE1x0MY3GF5yQmcH3vCr&output=json&pois=1&location=" + String(lat) + "%2C" + String(lon)
        
        let nsurl = NSURL(string: url)
        
        let boxView = UIView(frame: CGRect(x: UIScreen.mainScreen().bounds.width / 2 - 70, y: UIScreen.mainScreen().bounds.height / 2 - 40, width: 140, height: 80))
        boxView.backgroundColor = UIColor(red: CGFloat(230 / 255.0), green: CGFloat(230 / 255.0), blue: CGFloat(230 / 255.0), alpha: 0.9)
        boxView.layer.cornerRadius = 10
        self.view.addSubview(boxView)
        
        let frame = CGRect(x: 70 - 20, y: 40 - 20, width: 40, height: 40)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .BallSpinFadeLoader, color: UIColor.whiteColor())
        boxView.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimation()
        
        let jsonData = NSData(contentsOfURL: nsurl!)
        
        if jsonData != nil {
            let json = JSON(data:jsonData!)
            var city = String(json["result"]["addressComponent"]["city"])
            
            city = (city as NSString).substringToIndex(2)
            
            self.dataUtil.cacheSetString("city", value: city)
            self.city = city
            
            print(city)
            
            self.getWeather(city)
            
            activityIndicatorView.stopAnimation()
            boxView.removeFromSuperview()
            
        } else {
            let alertControllerNetFailed = UIAlertController(title: "晴宝", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertControllerNetFailed.addAction(cancelAction)
            self.presentViewController(alertControllerNetFailed, animated: true, completion: nil)
        }
    }
    
    /**
     通过 mob.com 获取天气信息
     
     - parameter city: 城市名
     */
    func getWeather(city:String) {
        let url = "https://apicloud.mob.com/v1/weather/query?key=f1fb6815bbb6&city=" + city
        let nsurl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        let jsonData = NSData(contentsOfURL: nsurl!)
        
        if jsonData != nil {
            
            let json = JSON(data:jsonData!)
            
            print("通过 mob.com 获取天气信息")
            print(json)
            
            if String(json["msg"]) == "success" {
                
                let temperature = String(json["result"][0]["temperature"])
                var city = String(json["result"][0]["city"])
                var province = String(json["result"][0]["province"])
                var aircondition = String(json["result"][0]["airCondition"])
                
                dataUtil.cacheSetString("province", value: province)
                
                if aircondition != "轻度污染" && aircondition != "中度污染" && aircondition != "重度污染" {
                    aircondition = "空气：" + aircondition
                }
                
                city = city + "市"
                
                aircondition = aircondition.stringByApplyingTransform("Hans-Hant", reverse: false)!
                city = city.stringByApplyingTransform("Hans-Hant", reverse: false)!
                province = province.stringByApplyingTransform("Hans-Hant", reverse: false)!
                
                self.lblTemperature.text = temperature
                self.lblCity.text = city
                self.lblProvince.text = province
                self.lblAirCondition.text = aircondition
                
                self.getWeatherByJuhe(self.city)
                dataUtil.cacheSetString("exist", value: "1")

                
            } else {
                // 城市不存在
                print("城市不存在")
                let alertControllerCityFailed = UIAlertController(title: "晴宝", message: "城市不存在，请定位国内城市", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertControllerCityFailed.addAction(cancelAction)
                self.presentViewController(alertControllerCityFailed, animated: true, completion: nil)
                
                dataUtil.cacheSetString("exist", value: "0")

            }
        } else {
            let alertControllerNetFailedAnother = UIAlertController(title: "晴宝", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertControllerNetFailedAnother.addAction(cancelAction)
            self.presentViewController(alertControllerNetFailedAnother, animated: true, completion: nil)
        }
    }
    
    /**
     通过聚合数据获取天气信息
     
     - parameter city: 城市名
     */
    func getWeatherByJuhe(city:String) {
        let url = "https://op.juhe.cn/onebox/weather/query?key=178058f2f64003a22805b167c2583075&cityname=" + city
        
        print(url)
        
        let nsurl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        let jsonData = NSData(contentsOfURL: nsurl!)
        let json = JSON(data:jsonData!)
        
        print("通过聚合数据获取天气信息")
        print(json)
        
        var weather = String(json["result"]["data"]["realtime"]["weather"]["info"])
        var windpower = String(json["result"]["data"]["realtime"]["wind"]["power"])
        var moon = String(json["result"]["data"]["realtime"]["moon"])
        var humidity = String(json["result"]["data"]["realtime"]["weather"]["humidity"])
        var pm25 = String(json["result"]["data"]["pm25"]["pm25"]["pm25"])
        var weatherTime = String(json["result"]["data"]["realtime"]["time"])
        let wid = String(json["result"]["data"]["realtime"]["weather"]["img"])
        
        humidity = "湿度：" + humidity + " %"
        windpower = "风力：" + windpower
        pm25 = "PM2.5：" + pm25 + "μg/m³"
        weatherTime = (weatherTime as NSString).substringToIndex(2)
        
        var timeNote:String = ""
        switch Int(weatherTime)! {
        case 0:
            timeNote = "灯火阑珊"
        case 1:
            timeNote = "更深夜阑"
        case 2:
            timeNote = "更深夜阑"
        case 3:
            timeNote = "斗转参横"
        case 4:
            timeNote = "斗转参横"
        case 5:
            timeNote = "东方未明"
        case 6:
            timeNote = "东方未明"
        case 7:
            timeNote = "晨光熹微"
        case 8:
            timeNote = "晨光熹微"
        case 9:
            timeNote = "日出三竿"
        case 10:
            timeNote = "日出三竿"
        case 11:
            timeNote = "当午日明"
        case 12:
            timeNote = "当午日明"
        case 13:
            timeNote = "午后风和"
        case 14:
            timeNote = "午后风和"
        case 15:
            timeNote = "桑榆暮景"
        case 16:
            timeNote = "桑榆暮景"
        case 17:
            timeNote = "华灯初上"
        case 18:
            timeNote = "华灯初上"
        case 19:
            timeNote = "月白风清"
        case 20:
            timeNote = "月白风清"
        case 21:
            timeNote = "更深夜阑"
        case 22:
            timeNote = "更深夜阑"
        case 23:
            timeNote = "灯火阑珊"
        default:
            timeNote = "网络错误"
        }
        
        if wid == "0" {
            self.weatherImageToken = "wid_00"
        } else if wid == "1" {
            self.weatherImageToken = "wid_01"
        } else if wid == "2" {
            self.weatherImageToken = "wid_02"
        } else if wid == "4" {
            self.weatherImageToken = "wid_04"
        } else {
            self.weatherImageToken = "wid_03"
        }
        
        
        weather = weather.stringByApplyingTransform("Hans-Hant", reverse: false)!
        humidity = humidity.stringByApplyingTransform("Hans-Hant", reverse: false)!
        windpower = windpower.stringByApplyingTransform("Hans-Hant", reverse: false)!
        moon = moon.stringByApplyingTransform("Hans-Hant", reverse: false)!
        timeNote = timeNote.stringByApplyingTransform("Hans-Hant", reverse: false)!
        
        self.lblWindPower.text = windpower
        self.lblHumidity.text = humidity
        self.lblMoon.text = moon
        self.lblPm.text = pm25
        self.lblWeather.text = weather
        self.lblTime.text = timeNote
        self.weatherImage.image = UIImage(named:self.weatherImageToken)
    }
    
    /**
     左滑手势
     */
    func custonGestureLeft() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.viewCustom(_:)))
        gesture.direction = .Left
        self.view.addGestureRecognizer(gesture)
    }
    
    /**
     页面跳转
     
     - parameter sender: 左滑手势
     */
    func viewCustom(sender: LeftGestureRecognizer) {
        self.performSegueWithIdentifier("DetailSegue", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

