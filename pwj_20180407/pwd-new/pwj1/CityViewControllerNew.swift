//
//  CityViewControllerNew.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/12/4.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//


import UIKit
import CoreLocation
import AddressBook
import SystemConfiguration

class CityViewControllerNew: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var aWebView: UIWebView!
    var distance:Double = 20.0
    
    @IBOutlet weak var aLabel: UILabel!
    
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
    var multi_dataArr_tmp:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
    var multi_dataArr:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
    
    //用来存放抛丸机类型的数组
    var choosen_pwjs: [String] = []
    var database:OpaquePointer? = nil
    
    
    var userCount:Int = 0
    
    var cityLevel:Int = 0
    var cityName: String = "";
    
    var citySql: String = "";
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for location
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "详细>", style: .plain , target: self, action: #selector(CityViewControllerNew.Click))
        
        if (self.cityLevel == 0)
        {
            citySql = " AND (province = \"\(self.cityName)\") "
        }
        else if(self.cityLevel == 1)
        {
            citySql = " AND (prefecture_level_city = \"\(self.cityName)\") "
        }
        else if(self.cityLevel == 2)
        {
            citySql = " AND (county_level_city = \"\(self.cityName)\") "
        }
        else
        {
            print("ERROR: line 83 on CityViewControllerNews.swift", terminator: "")
        }
        
        //aWebView.sizeToFit()
        
        self.initSqlForDistanceViewController()
        
        self.aLabel.text = "在\(self.cityName)地区，共有\(self.userCount)个潜在用户"
        
        
        //var url:String = "http://m.amap.com/?mk=39,116|39.989175, 116.481590"
        
//        var lon_lat_string:String = "http://m.amap.com/?mk="
        var lon_lat_string:String = "http://uri.amap.com/marker?markers="             //20170731,更新高德地图api
        var i:Int = 0
        for item in multi_dataArr_tmp
        {
//            i = i + 1
//            lon_lat_string = lon_lat_string + String(format:"%3.5f", item.2) + "," + String(format:"%3.5f", item.3) + ",潜在抛丸机客户\(i+1),| "
            lon_lat_string = lon_lat_string + String(format:"%3.5f", item.2) + "," + String(format:"%3.5f", item.3) + ",潜在抛丸机客户\(i+1)| "     //20170731,更新高德地图api
                        i = i + 1
            //            print(lon_lat_string)
            if (i > 50)
            {
                break
            }
        }
//        print(lon_lat_string)
        
        let url:String = lon_lat_string
        let urlString = URL(string:url.addingPercentEscapes(using: String.Encoding.utf8)!)
        let request = URLRequest(url: urlString!)
        aWebView.loadRequest(request)
        //awebView.
        
    }
    
    
    
    func Click()
    {
//        print("hi!\n", terminator: "")
        //let second = self.storyboard?.instantiateInitialViewController("secondViewController") as? secondViewController
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "distancedetailviewcontroller") as? DistanceDetailViewController
        detail!.multi_dataArr = self.multi_dataArr
        detail?.dv_lat_from = self.pv_lat_from
        detail?.dv_lon_from = self.pv_lon_from
        if (self.userCount > 0) {
            //判断用户有没有注册
            
            let filePath:String = NSHomeDirectory() + "/Documents/my.plist"
            let fileManger = FileManager.default
            var exist = fileManger.fileExists(atPath: filePath)
            if (!exist)
            {
                
                
                self.loginFailed()
                return
                
            }
            
            var array:NSArray?
            array = NSArray(contentsOfFile: filePath)
            
            
            var username = global_telephone
            var password = global_password
            
            if (username == "" || password == "" || username.characters.count > 50 || password.characters.count > 50)
            {
                self.loginFailed()
                return
            }
            
            
            
            
            var path = String(format: "/thinkphp-login-register/index.php/Home/Login/login.html")
            path = path.addingPercentEscapes(using: String.Encoding.utf8)!
            
            var param = NSMutableDictionary()
            
            param.setValue(username, forKey: "mobile")
            param.setValue(password, forKey: "password")
            
            var engine = MKNetworkEngine(hostName: server_IP, customHeaderFields: nil)
            var op = engine?.operation(withPath: path, params: param as! [AnyHashable: Any], httpMethod: "POST")
            
            
            
            op?.addCompletionHandler({ (operation) -> Void in
                if let saveError = operation?.responseString() as? NSString
                {NSLog("MKNetwork请求错误 : %@", saveError)
                }
//                NSLog("responseData : %@", operation.responseString())
                
                /*
                let data  = operation.responseData()
                let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
                //self.reloadView(resDict)
                */
                
                
                //if success ...
                let data = operation?.responseData()
                
                //NSString * aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                let aString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                if (aString!.contains("LoginSuccess"))
                    //if (true)
                {
                    NSLog("ok")
                    
                    self.navigationController?.pushViewController(detail!, animated: true)
                    
                }
                else
                {
                    //return
                    self.loginFailed()
                }
                
                
                }, errorHandler: { (operation, err) -> Void in
                    if let saveError = err?.localizedDescription as? NSString
                    {NSLog("MKNetwork请求错误 : %@", saveError)
                    }
//                    NSLog("MKNetwork请求错误 : %@", err?.localizedDescription)
                    
                    self.loginFailed()
                    
                    var alert = UIAlertView()
                    alert.title = "注意!"
                    alert.message = err?.localizedDescription
                    alert.addButton(withTitle: "Yes")
                    alert.show()
                    
                    
                    
                }
                
                
            )
            engine?.enqueue(op)
  
        }
        else
        {
            var alert = UIAlertView()
            alert.title = "Attenation!"
            alert.message = "所选区域无客户信息"//这里最好给出错误的原因
            alert.addButton(withTitle: "Yes")
            alert.show()
        }
//        self.navigationController?.pushViewController(detail!, animated: true)
    }

    func loginFailed()
    {
        let alertController = UIAlertController(title: "您还没有登录", message: "如果您想查看详细信息，请您注册并登录", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "现在登录", style: .cancel) { (action) in
            print(action)
            let login = self.storyboard?.instantiateViewController(withIdentifier: "loginviewcontroller")
            self.present(login!, animated: true, completion: nil)
            
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "以后再说", style: .destructive) { (action) in
            print(action)
        }
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
 
    
    //获取设备是否允许使用定位服务
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
            if status == CLAuthorizationStatus.notDetermined || status == CLAuthorizationStatus.denied{
                
            }else{
                //允许使用定位服务的话，开启定位服务更新
                locationManager.startUpdatingLocation()
//                print("定位开始P1")

                
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
        
//        print("经度：\(pv_lon_from),纬度：\(pv_lat_from)")
        
        
        self.pv_lon_from_x1 = pv_lon_from - self.distance / 100.0 //pv_lon_from always be null here...
        self.pv_lon_from_x2 = pv_lon_from + self.distance / 100.0
        self.pv_lat_from_y1 = pv_lat_from - self.distance / 100.0
        self.pv_lat_from_y2 = pv_lat_from + self.distance / 100.0
        
//        self.initSqlForDistanceViewController()
//        
//        //关闭定位
//        locationManager.stopUpdatingLocation()
//        
//        
//        self.aLabel.text = "在\(self.cityName)地区，共有\(self.userCount)个潜在用户"
//        
//        
//        //var url:String = "http://m.amap.com/?mk=39,116|39.989175, 116.481590"
//        
//        var lon_lat_string:String = "http://m.amap.com/?mk="
//        var i:Int = 0
//        for item in multi_dataArr_tmp
//        {
//            i = i + 1
//            lon_lat_string = lon_lat_string + String(format:"%3.5f", item.2) + "," + String(format:"%3.5f", item.3) + ",潜在抛丸机客户\(i),| "
////            i = i + 1
////            print(lon_lat_string)
//            if (i > 10)
//            {
//                break
//            }
//        }
//        
//        
//        let url:String = lon_lat_string
//        let urlString = NSURL(string:url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
//        let request = NSURLRequest(URL: urlString!)
//        aWebView.loadRequest(request)
//        //awebView.
        
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
            
            let sql_tableView = "SELECT ID,companyname,latitude,longitude FROM pwj_user WHERE 1=1 \(sql_pwjkeywords) \(citySql);"
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
