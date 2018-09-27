//
//  DistanceDetailViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/9/23.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//
//
//  TableViewController.swift
//  pwj1
//
//  Created by Apollo on 15/5/29.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
let url_secondhand = URL(string: "http://103.72.164.2/pwjstore/advlist.php")
/*
class ProductsCell: UITableViewCell{
    @IBOutlet weak var productsName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contactLable: UILabel!
    
}
*/

//class AccessoriesTableViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate {

class AccessoriesTableViewController: UIViewController{

    @IBOutlet weak var adWeb: UIWebView!
    @IBOutlet weak var refresh: UITabBarItem!
    //@IBOutlet weak var m19Web: UIWebView!
    
    


    //图片、规格产品、价格、联系人几电话
//    var products:[(String,String,String,String)] = [(String,String,String,String)]()

    //var pro:[(String,String,String,String)] = [(String, String,String,String)]()
    
    var defaultTimeZonesStr:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ad web pag
//        let url = NSURL(string: "http://m.amap.com/?from=\(lat_from),\(lon_from)(from)&to=\(lat_to),\(lon_to)(to)")
//        let url = URL(string: "http://103.72.164.2/pwjstore/advlist.php")     //http://42.200.33.22/pwjstore/advlist.php
        let request = URLRequest(url: url_secondhand!)
        
        //        println(lon)
        //        println(url)
        //        println(data)
        //self.view.addSubview(mapView)
        //        mapView = BMKMapView(frame: self.view.viewWithTag(7)!.frame)
        //        mapView.setTranslatesAutoresizingMaskIntoConstraints(true)
        //        labelText.text = "\(data!)"
//        pwjDetail.text = "\(data!)"
        adWeb.loadRequest(request)
        
        self.title = "二手市场"
        /*
        products.append(("./accessories/jiaodai.jpg","125平胶带","9.5元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        
        products.append(("./accessories/jiaodai.jpg","150平胶带","13元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/jiaodai.jpg","175平胶带","15元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/jiaodai.jpg","200平胶带","25元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/jiaodai.jpg","250平胶带","42元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/jiaodai.jpg","300平胶带","47元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/jiaodai.jpg","400平胶带","58元/米","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/yangmaozhan.jpg","5公厘米羊毛毡","15元/张","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/yangmaozhan.jpg","8公厘米羊毛毡","18元/张","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/naimopi.jpg","耐磨皮","5元/公斤","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/ruanguan.jpg","100软管","17元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/ruanguan.jpg","150软管","27元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/ruanguan.jpg","200软管","43元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/ruanguan.jpg","250软管","65元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/loushaban.jpg","Q376普通漏沙板","40元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/loushaban.jpg","Q376耐磨漏沙板","45元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/loushaban.jpg","Q378普通漏沙板","60元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/loushaban.jpg","Q378耐磨漏沙板","65元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/gangbanmenpi.jpg","600#，500*550钢板门皮","6.5元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","650#，500*550钢板门皮","7.5元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","750#，500*550钢板门皮","8.5元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","800#，500*550钢板门皮","9元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","850#，500*550钢板门皮","10元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","900#，500*550钢板门皮","11.5元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/gangbanmenpi.jpg","950#，500*550钢板门皮","12元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/lvdai.jpg","青岛盛泰Q3210履带","3300元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛盛泰Q326履带","1550元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛崂山Q3210履带","4500元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛崂山Q326履带","1900元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛崂山Q328履带","2250元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛宏昆Q3210履带","3800元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛盛泰Q326履带","1800元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/lvdai.jpg","青岛盛泰Q324履带","1000元/件","联系人：徐莉，13851005856，可托运，运费另计"))

        
        
        products.append(("./accessories/mentiao.jpg","5#门条","35元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/mentiao.jpg","8#门条","80元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/mentiao.jpg","10#门条","80元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        
        products.append(("./accessories/luoshaguan.jpg","50#落沙管","140元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/luoshaguan.jpg","60#落沙管","250元/件","联系人：徐莉，13851005856，可托运，运费另计"))
        
        
        products.append(("./accessories/haimianzhi.jpg","5#海绵纸","10元/张","联系人：徐莉，13851005856，可托运，运费另计"))
        products.append(("./accessories/haimianzhi.jpg","8#海绵纸","15元/张","联系人：徐莉，13851005856，可托运，运费另计"))
        */
        
       
        /*
        
        self.initSqlForDistanceViewController()
        
        //searchbar
        //设置搜索栏委托对象为当前视图控制器
        self.searchBar.delegate = self
        //        println(self.dataArr)
        //self.listTerms = NSArray(array: multi_dataArr) //dataArr as NSArray<String>
        //        println(self.listTerms)      //数据类型print
        self.filterContentForSearchText("", scope:-1)   //初始查询全部数据

        */
        //statistics
        let currentDate = Date()
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        defaultTimeZonesStr = formatter.string(from: currentDate)
        
        self.report_statistics()
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.viewDidLoad()
        //打开二手页面
        let request = URLRequest(url: url_secondhand!)
        adWeb.loadRequest(request)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//touch the black to close keyboard
        self.view.endEditing(true)
    }
    
    //下面这个函数是网络应用相关的，这里用来统计访问Accessories的数量，statistics
    //telephone, access_time
    func report_statistics() {
        
        var path = String(format: "/pwjstore/statistics.php?phone=%@",global_telephone)
        path = path.addingPercentEscapes(using: String.Encoding.utf8)!
        
        var param = NSMutableDictionary()
        
        //and php here ...
        let engine = MKNetworkEngine(hostName: server_IP, customHeaderFields: nil)
        //var op = engine.operationWithPath(path)
        let op = engine?.operation(withPath: path)
        
        op?.addCompletionHandler({ (operation) -> Void in
            if let saveError = operation?.responseString() as? NSString
            {NSLog("MKNetwork请求错误 : %@", saveError)
            }
//            NSLog("responseData : %@", operation?.responseString())
            
            
            //if failture ...
            }, errorHandler: { (operation, err) -> Void in
                if let saveError = err?.localizedDescription as? NSString
                {NSLog("MKNetwork请求错误 : %@", saveError)
                }
//                NSLog("MKNetwork请求错误 : %@", err?.localizedDescription)
                
                let alert = UIAlertView()
                alert.title = "注意!"
                alert.message = err?.localizedDescription
                alert.addButton(withTitle: "Yes")
                alert.show()
                
            }
            
        )
        engine?.enqueue(op)
        
        
    }
    
    
/*
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println(dataArr.count)
        return products.count
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productcell", forIndexPath: indexPath) 
        
        // Configure the cell...

        let imagePath = String(format: products[indexPath.row].0)
        cell.imageView?.image = UIImage(named: imagePath)
        
        let name:AnyObject? = products[indexPath.row].1
        let price:AnyObject? = products[indexPath.row].2
        var contact:AnyObject? = products[indexPath.row].3
        
        
        cell.textLabel?.text =   "\(price!)"
        cell.textLabel?.textColor = UIColor.redColor()
        cell.detailTextLabel?.text = "\(name!)"
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "联系人：徐莉，13851005856"
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
  */  

}


