//
//  SearchCityController.swift
//  sunshine
//
//  Created by Airing on 16/8/3.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchCityController: UIViewController {
    
    var dataUtil:DataUtil = DataUtil()
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchCity() {
        
        if self.txtCity.text == nil {
            let alertControllerFailed = UIAlertController(title: "晴宝",
                                                          message: "请输入城市名", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertControllerFailed.addAction(cancelAction)
        } else {
            
            let url = "https://apicloud.mob.com/v1/weather/query?key=f1fb6815bbb6&city=" + self.txtCity.text!
            let nsurl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            
            let jsonData = NSData(contentsOfURL: nsurl!)
            let json = JSON(data:jsonData!)
            
            if String(json["msg"]) == "success" {
                dataUtil.cacheSetString("city", value: self.txtCity.text!)
                print(dataUtil.cacheGetString("city"))
                // 搜索城市标记
                dataUtil.cacheSetString("first", value: "1")
                
                let alertControllerOk = UIAlertController(title: "晴宝",
                                                        message: "城市添加成功！♪(^∇^*)", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertControllerOk.addAction(cancelAction)
                self.presentViewController(alertControllerOk, animated: true, completion: nil)
                dismiss()
            } else {
                // 查无此城
                let alertControllerFailed = UIAlertController(title: "晴宝",
                                                        message: "查无此城……", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertControllerFailed.addAction(cancelAction)
                self.presentViewController(alertControllerFailed, animated: true, completion: nil)

            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtCity.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
