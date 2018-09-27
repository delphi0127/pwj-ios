//
//  DistanceViewController_content.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/9/23.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
//mapView.delegate = self需要使用Delegate的class
class DistanceViewController_content: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var pwjDetail: UITextView!
    @IBOutlet weak var cmapWebView: UIWebView!
    //    var mapView: BMKMapView!
    var data:NSString!
    var lon_from:CLLocationDegrees!
    var lat_from:CLLocationDegrees!
    var lon_to:CLLocationDegrees!
    var lat_to:CLLocationDegrees!
    
    //    var _mapManager: BMKMapManager!
    //    var locationService: BMKLocationService!
    //    当前用户位置
    //    var userLocation: BMKUserLocation!
    
    //    var navigationController: UINavigationController!
    //var mapView:BMKMapView = BMKMapView.alloc()
    //var mapView:BMKMapView = BMKMapView(frame: CGRectMake(0.0,400.0,320,480))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 要使用百度地图，请先启动BaiduMapManager
        //        _mapManager = BMKMapManager.alloc()
        //            // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        //        var ret:Bool = _mapManager.start("NSpYTUQez4GIweuSTYZRFaf5", generalDelegate: nil)
        //        if (!ret) {
        //            println("Manger start failed!!!!")
        
        //        var vc = storyboard!.instantiateViewControllerWithIdentifier("UserContent") as! ViewController_content
        //BMKMapView的创建
        //        bMapView = BMKMapView(frame: CGRectMake(0.0,0.0,32,48))
        //        self.view.viewWithTag(7) = bMapView.self()
//        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }

        let labelText = view.viewWithTag(6) as! UITextView
//        print("startpoint&to=\(lat_to!)")
//        labelText.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10, 10)
        labelText.sizeToFit()    //UITextView继承UIScrollView，navigationController让scrollView自动适应屏幕造成的不居上，sizeToFit()让UITextView内容居上，20170803
        
//        let url = URL(string: "http://m.amap.com/?from=\(lat_from),\(lon_from)(from)&to=\(lat_to),\(lon_to)(to)")
        let url = URL(string: "http://uri.amap.com/navigation?from=\(lon_from!),\(lat_from!),startpoint&to=\(lon_to!),\(lat_to!),endpoint")//20170731,更新高德地图api
//        print(url)
        let request = URLRequest(url: url!)
        
        //        println(lon)
        //        println(url)
        //        println(data)
        //self.view.addSubview(mapView)
        //        mapView = BMKMapView(frame: self.view.viewWithTag(7)!.frame)
        //        mapView.setTranslatesAutoresizingMaskIntoConstraints(true)
//        labelText.text = "\(data!)"
        pwjDetail.text = "\(data!)"
//        labelText.markedTextRange = NSMakeRange([labelText.text .lengthOfBytesUsingEncoding(<#T##encoding: NSStringEncoding##NSStringEncoding#>)], 0)
        cmapWebView.loadRequest(request)
        //self.view.viewWithTag(7)!.addSubview(mapView)
        
        //        // 设置定位精确度，默认：kCLLocationAccuracyBest
        //        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        //        BMKLocationService.setLocationDistanceFilter(10)
        //        // 定位功能初始化
        //        locationService = BMKLocationService()
        //        locationService.startUserLocationService()
        //
        //        mapView.showsUserLocation = false  //先关闭显示的定位图层
        //        mapView.userTrackingMode = BMKUserTrackingModeFollow  //设置定位的状态
        //        mapView.showsUserLocation = true //显示定位图层
        //        mapView.scrollEnabled = false     // 允许用户移动地图
        //        mapView.updateLocationData(userLocation)  // 更新当前位置信息，强制刷新定位图层
        //        println("启动定位2")
        
        // 创建地图视图约束
        //        var constraints = [NSLayoutConstraint]()
        //        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view.viewWithTag(7), attribute: .Leading, multiplier: 1, constant: 0))
        //        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view.viewWithTag(7), attribute: .Trailing, multiplier: 1, constant: 0))
        //        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view.viewWithTag(7), attribute: .Bottom, multiplier: 1, constant: 0))
        //        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: view.viewWithTag(7), attribute: .Bottom, multiplier: 1, constant: 8))
        //        self.view.addConstraints(constraints)
        //        self.bMapView.delegate = self
    }
    
    
    //    // MARK: - 定位协议实现
    //
    //    // 在地图将要启动定位时，会调用此函数
    //    func willStartLocatingUser() {
    //        println("启动定位……")
    //    }
    //
    //    // 用户位置更新后，会调用此函数
    //    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
    //        mapView.updateLocationData(userLocation)
    //        mapView.centerCoordinate = userLocation.location.coordinate
    //        self.userLocation = userLocation
    //        println("目前位置：\(userLocation.location.coordinate.longitude), \(userLocation.location.coordinate.latitude)")
    //    }
    //
    //    // 用户方向更新后，会调用此函数
    //    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
    //        mapView.updateLocationData(userLocation)
    //        println("目前朝向：\(userLocation.heading)")
    //    }
    //
    //    // 在地图将要停止定位时，会调用此函数
    //    func didStopLocatingUser() {
    //        println("关闭定位")
    //    }
    //
    //    // 定位失败的话，会调用此函数
    //    func didFailToLocateUserWithError(error: NSError!) {
    //        println("定位失败！")
    //    }
    
    @IBAction func btnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        //        println(lon)
    }
    //    @IBAction func submitBtnPressed(sender: AnyObject) {
    //        data.setValue(tfName.text, forKey: "name")
    //        data.setValue(tfAge.text.toInt(), forKey: "age")
    //
    //        data.managedObjectContext?.save(nil)
    //        dismissViewControllerAnimated(true, completion: nil)
    //
    //    }
    //    @IBAction func qxBtnPressed(sender: AnyObject) {
    //        dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        mapView.viewWillAppear()
        //        mapView.delegate = self
        //        locationService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        mapView.viewWillDisappear()
        //        mapView.delegate = nil
        //        locationService.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

