//
//  DistanceViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/9/14.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook
import SystemConfiguration
import Foundation

class DistanceViewController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var pwjAbstract: UITextView!
    
    @IBOutlet weak var aWebView: UIWebView!
    var distance:Double = 20.0
    
    //location
    var currLocation: CLLocation!
    var pv_lon_from:CLLocationDegrees!
    var pv_lat_from:CLLocationDegrees!
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    //x1,x2,y1,y2
    var pv_lon_from_x1:CLLocationDegrees!
    var pv_lon_from_x2:CLLocationDegrees!
    var pv_lat_from_y1:CLLocationDegrees!
    var pv_lat_from_y2:CLLocationDegrees!

    //added by wzy
//    var multi_dataArr_tmp:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
//    var multi_dataArr:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
    var multi_dataArr_tmp:[(Int64 , String, CLLocationDegrees, CLLocationDegrees)] = [(Int64 , String, CLLocationDegrees, CLLocationDegrees)]()
    var multi_dataArr:[(Int64 , String, CLLocationDegrees, CLLocationDegrees)] = [(Int64 , String, CLLocationDegrees, CLLocationDegrees)]()
    
    //用来存放抛丸机类型的数组
    var choosen_pwjs: [String] = []
    var database:OpaquePointer? = nil
    
    var userCount:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //for location
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "详细>", style: .plain , target: self, action: #selector(DistanceViewController.Click))
        

    }
    
    
    func Click()
    {
//        print("hi!\n", terminator: "")
        //let second = self.storyboard?.instantiateInitialViewController("secondViewController") as? secondViewController

        let detail = self.storyboard?.instantiateViewController(withIdentifier: "distancedetailviewcontroller") as? DistanceDetailViewController
        detail!.multi_dataArr = self.multi_dataArr
//        跨页面传递数值
        detail?.dv_lat_from = self.pv_lat_from
        detail?.dv_lon_from = self.pv_lon_from
        if (self.userCount > 0)
        {
            self.navigationController?.pushViewController(detail!, animated: true)
        }
        else
        {
//            print(self.userCount)
            let alert = UIAlertView()
            alert.title = "注意!"
            alert.message = "所选区域无客户信息"//这里最好给出错误的原因
            alert.addButton(withTitle: "Yes")
            alert.show()
        }
    }


    @IBAction func onSliderChanged(_ sender: UISlider) {
        
        let selectedValue = Float( sender.value )
        pwjAbstract.text = "距您" + String( stringInterpolationSegment: selectedValue) + "公里之内，共有???" + "个潜在用户"
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSliderTouchUpInside(_ sender: UISlider) {
        let selectedValue = Float( sender.value )
        
        self.distance = Double(selectedValue)
        
        if let variable = pv_lon_from {
            self.pv_lon_from_x1 = pv_lon_from - self.distance / 100.0 //pv_lon_from always be null here...
            self.pv_lon_from_x2 = pv_lon_from + self.distance / 100.0
            self.pv_lat_from_y1 = pv_lat_from - self.distance / 100.0
            self.pv_lat_from_y2 = pv_lat_from + self.distance / 100.0
            
            initSqlForDistanceViewController()
            
            locationManager.startUpdatingLocation()
            print("重新定位开始P1")
        }
        else//pv_lon_from is nil
        {
            let alert = UIAlertView()
            alert.title = "Attenation!"
            alert.message = "定位失败"
            alert.addButton(withTitle: "Yes")
            alert.show()
        }

        
        /*
        pwjAbstract.text = "距您" + String( stringInterpolationSegment: selectedValue) +  "公里之内，\n共有" + String(userCount) + "个潜在用户"
        */
    }
    
    //获取设备是否允许使用定位服务
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
            if status == CLAuthorizationStatus.notDetermined || status == CLAuthorizationStatus.denied{
                
            }else{
                //允许使用定位服务的话，开启定位服务更新
                locationManager.startUpdatingLocation()
                print("定位开始P1")
                

                
            }
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last! as CLLocation
        var geocoder:CLGeocoder = CLGeocoder()
//        let net:Int32 = SCNetworkConnectionStatus()  //联网status:
        //        var city_str:String = "联网失败"
        //        var geocoder_flag:Int8 = 0 //标记geocoder.reverseGeocodeLocation查询是否执行，tLabel.text可以显示定位
//        if net == 0 {       //没有网络连接
//            //tLabel.text = "请检查网络连接……"
//        }
        
        self.currLocation = locations[locations.count - 1] //as改为as!
        //presentViewController(vc, animated: true, completion: nil) could pass the var vc.lat and  vc.lon
        //        var vc = storyboard?.instantiateViewControllerWithIdentifier("UserContent") as! ViewController_content
        //获取经度
        //        println("经度：\(currLocation.coordinate.longitude),纬度：\(currLocation.coordinate.latitude)")
        pv_lon_from = currLocation.coordinate.longitude
        pv_lat_from = currLocation.coordinate.latitude
        
        /*
        //to debug
        pv_lon_from = 116.00
        pv_lat_from = 40.00
        */
            
        print("经度：\(pv_lon_from),纬度：\(pv_lat_from)")
        
        
        self.pv_lon_from_x1 = pv_lon_from - self.distance / 100.0 //pv_lon_from always be null here...
        self.pv_lon_from_x2 = pv_lon_from + self.distance / 100.0
        self.pv_lat_from_y1 = pv_lat_from - self.distance / 100.0
        self.pv_lat_from_y2 = pv_lat_from + self.distance / 100.0
        
        self.initSqlForDistanceViewController()
        
        //关闭定位
        locationManager.stopUpdatingLocation()
        
        pwjAbstract.text = "距您" +  String( stringInterpolationSegment: distanceSlider.value) + "公里之内，共有" + String(userCount) + "个潜在用户"
        
        /*
        for item in multi_dataArr_tmp
        {
            pwjAbstract.text = pwjAbstract.text + "\n" + item.1
        }
        
        var url:String  = "http://m.amap.com/?mk=39.989753,116.480927,方恒国际中心,A000A837FH|39.989175, 116.481590,食尚坊美食广场|38.989175, 116.481590,广场"
        
        var urlString = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let request = NSURLRequest(URL: urlString!)
        
        mapView.loadRequest(request)
        */
        
        //var url:String = "http://m.amap.com/?mk=39,116|39.989175, 116.481590"
//        var lon_lat_string:String = "http://m.amap.com/?mk="
        var lon_lat_string:String = "http://uri.amap.com/marker?markers="       //20170731,更新高德地图api
//        var lon_lat_string:String = "http://api.map.baidu.com/staticimage/v2?ak=4Cyw0W0rBw7VCdOshtdayYsY&center=" + String(format:"%3.5f", pv_lon_from) + "," + String(format:"%3.5f", pv_lat_from) + "&width=400&height=300&markers="
        var i:Int = 0
        for item in multi_dataArr_tmp
        {
//            i = i + 1
//            lon_lat_string = lon_lat_string + String(format:"%3.5f", item.2) + "," + String(format:"%3.5f", item.3) + ",潜在抛丸机客户\(i+1),| "
            lon_lat_string = lon_lat_string + String(format:"%3.5f", item.2) + "," + String(format:"%3.5f", item.3) + ",潜在抛丸机客户\(i+1)| "     //20170731,更新高德地图api
            i = i + 1
            if (i > 50)
            {
                break
            }
        }
//        print(lon_lat_string)
//        lon_lat_string = lon_lat_string + "&markerStyles=l,A|m,B|l,C|l,D|m,E|,|l,G|m,H "
//        lon_lat_string = "http://api.map.baidu.com/staticimage/v2?ak=4Cyw0W0rBw7VCdOshtdayYsY&center=116.403874,39.914889&width=400&height=300&zoom=11&markers=116.288891,40.004261|116.487812,40.017524|116.525756,39.967111|116.536105,39.872374|116.442968,39.797022|116.270494,39.851993|116.275093,39.935251|116.383177,39.923743|&markerStyles=l,A|m,B|l,C|l,D|m,E|,|l,G|m,H "
//        lon_lat_string = "http://api.map.baidu.com/marker?location=40.047669,116.313082&title=我的位置&content=百度奎科大厦|40.047669,118.313082&title=我的位置&content=百度奎科大厦2&output=html&src=yourComponyName|yourAppName"
        let url:String = lon_lat_string
        let urlString = URL(string:url.addingPercentEscapes(using: String.Encoding.utf8)!)
        let request = URLRequest(url: urlString!)
        aWebView.loadRequest(request)
        
    }
    
    //MARK: --Core Location委托方法用于实现位置的更新
    //    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    //
    //        //Swift1.1 -> Swift1.2修改点 start
    //        self.currLocation = locations[locations.count - 1] as! CLLocation //as改为as!
    ////        self.txtLat.text = String(format:"%3.5f", currLocation.coordinate.latitude)//NSString改为String
    ////        self.txtLng.text = String(format:"%3.5f", currLocation.coordinate.longitude)//NSString改为String
    ////        self.txtAlt.text = String(format:"%3.5f", currLocation.altitude)//NSString改为String
    //        //Swift1.1 -> Swift1.2修改点 end
    //        
    //        NSLog("%3.5f",  currLocation.coordinate.latitude)
    //        
    //    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {     //只在press时运行
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let detailviewcontroller = segue.destinationViewController as! DistanceDetailViewController//as改为as!
        
        if (segue.identifier == "Sendkeywords") {
            //
  
            detailviewcontroller.lon_x1 = self.pv_lon_from_x1
            detailviewcontroller.lon_x2 = self.pv_lon_from_x2
            detailviewcontroller.lat_y1 = self.pv_lat_from_y1
            detailviewcontroller.lat_y2 = self.pv_lat_from_y2

        }
    }
    */
    
    //database
    
    func initSqlForDistanceViewController() {             //区域数据的初始化
        let filePath:String = Bundle.main.path(forResource: "pwjcs", ofType: "jpg")!
        var sql_pwjkeywords:String = " AND ( main_products_using_pwj = \""
        let sql_lon_lat:String = " AND ( longitude > \(self.pv_lon_from_x1!) ) AND ( longitude < \(self.pv_lon_from_x2!) ) AND ( latitude > \(self.pv_lat_from_y1!) ) AND ( latitude < \(self.pv_lat_from_y2!) )"
        let count:Int = choosen_pwjs.count
        var i:Int = 0
        
        multi_dataArr_tmp.removeAll(keepingCapacity: true)
        
        while (i < count)
        {
            sql_pwjkeywords = sql_pwjkeywords + choosen_pwjs[i]
            if ( i == count - 1)
            {
                sql_pwjkeywords = sql_pwjkeywords + "\")"
            }
            else
            {
                sql_pwjkeywords = sql_pwjkeywords + "\" OR main_products_using_pwj = \""
            }
            i = i + 1
        }
        
        
        
        if sqlite3_open(filePath,&database) == SQLITE_OK {
            
            let sql_tableView = "SELECT ID,companyname,latitude,longitude FROM pwj_user WHERE 1=1 \(sql_pwjkeywords) \(sql_lon_lat);"
            //prefecture_level_city = '\(city)', updated by wzy
            recordSet(sql_tableView)
            //            println(loc_city)
            multi_dataArr = multi_dataArr_tmp
            self.userCount = multi_dataArr.count
            
        }else {
            sqlite3_close(database)
            print("open database failed")
        }
    }
    
    
    func recordSet(_ sql: String) {
        var stmt:OpaquePointer? = nil    // 准备语句
        /**
        1. 数据库句柄
        2. SQL 的 C 语言的字符串
        3. SQL 的 C 语言的字符串长度 strlen，-1 会自动计算
        4. stmt 的指针
        5. 通常传入 nil
        */
        if sqlite3_prepare_v2(database, sql.cString(using: String.Encoding.utf8)!, -1, &stmt, nil) == SQLITE_OK{
            //dataArr = context. stmt
            // 单步获取SQL执行的结果 -> sqlite3_setup 对应一条记录
            while sqlite3_step(stmt) == SQLITE_ROW {
                // 获取每一条记录的数据
                recordData(stmt!)
            }
        }
    }
    
    ///  获取每一条数据的记录
    ///
    ///  - parameter stmt: prepared_statement 对象
    func recordData(_ stmt:OpaquePointer)
    {
        let company_id:Int64 = sqlite3_column_int64(stmt, 0)
        
//        let chars = UnsafePointer<CChar>(sqlite3_column_text(stmt, 1))
//        let company_name = String(CString: chars, encoding: String.Encoding.utf8)
        let value = String(cString:sqlite3_column_text(stmt, 1)!)                     //swift2->swift3,20170728
        let company_name = String(cString: value, encoding: String.Encoding.utf8)              //swift2->swift3,20170728
    
        let tmp_latitude = sqlite3_column_double(stmt, 2)
        let tmp_longitude = sqlite3_column_double(stmt, 3)
        
        multi_dataArr_tmp.append(( Int64(company_id),company_name!,tmp_longitude,tmp_latitude))

    }


}
