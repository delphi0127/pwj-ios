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

class DistanceDetailViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    //var dataArr:Array<NSString> = []
    //var context:NSManagedObjectContext!

    //added by wzy
    var multi_dataArr_tmp:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
    var multi_dataArr:Array<(Int64 , String, CLLocationDegrees, CLLocationDegrees)> = []
    
    var dataArr:Array<AnyObject> = []
    var dataOne:Array<AnyObject> = []
    var dataOne_lat_lon:Array<AnyObject> = []
    var database:OpaquePointer? = nil
    var dv_lon_from:CLLocationDegrees!
    var dv_lat_from:CLLocationDegrees!
    var province_detailView:NSString!
    var prefecture_detailView:NSString!
    var city:String!
    var picker2countyflag:String =  "Empty"  //检查是否为pickerview的4城市，"Empty"使定位的city可以在initSQL运行
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    //x1,x2,y1,y2
    var lon_x1:CLLocationDegrees!
    var lon_x2:CLLocationDegrees!
    var lat_y1:CLLocationDegrees!
    var lat_y2:CLLocationDegrees!
    
    //用来存放抛丸机类型的数组
    var choosen_pwjs: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    var listTerms : NSArray!
    var listFilterTerms : NSMutableArray!
    
    //added by wzy
    var multi_listTerms:NSArray!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.dataArr = []
        self.title = "厂商列表"
        
        multi_dataArr_tmp = multi_dataArr
        
        self.initSqlForDistanceViewController()
        
        //searchbar
        //设置搜索栏委托对象为当前视图控制器
        self.searchBar.delegate = self
        //        println(self.dataArr)
        let n = self.multi_dataArr_tmp.count
//        print(n)
        if n == 0 {
            self.dataArr.append(" " as AnyObject)
        }
        else {
            for i in 0...n-1 {
                self.dataArr.append(self.multi_dataArr_tmp[i].1 as AnyObject)
            }
        }
        
        self.listTerms = NSArray(array: self.dataArr)
//        self.listTerms = NSArray(array: multi_dataArr as Array<AnyObject>) as NSArray//dataArr as NSArray<String>
        //        println(self.listTerms)      //数据类型print
        self.filterContentForSearchText("", scope:-1)   //初始查询全部数据
        tableView.reloadData()
//        prepareForSegue(UIStoryboardSegue, sender: AnyObject!)
    }
    
    
    
    /// 实现 UISearchBarDelegate 协议方法
    //  获得焦点，成为第一响应者
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
//        self.searchBar.becomeFirstResponder()
        return true
    }
    
    //点击键盘上的搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    //点击搜索栏取消按钮
    func searchBarCancelButtonClicked(_ searchBar : UISearchBar) {
        //查询所有
        self.initSqlForDistanceViewController()
        self.filterContentForSearchText("", scope:-1)
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    
    //当文本内容发生改变时候调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText as NSString, scope:self.searchBar.selectedScopeButtonIndex)
        self.tableView.reloadData()
    }
    
    //当搜索范围选择发生变化时候调用
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(self.searchBar.text! as NSString, scope:selectedScope)
        self.tableView.reloadData()
    }
    
    //过滤结果集方法
    func filterContentForSearchText(_ searchText: NSString, scope: Int) {
        
//        if(searchText.length == 0) {
//            //查询所有
//            self.listFilterTerms = NSMutableArray(array:self.listTerms)
//            dataArr = self.listFilterTerms as Array<AnyObject>    //利用dataArr，将检索初始数据在tableviewcell上输出
//            return
//        }
//        var tempArray : NSArray!
//        
//        if (scope != -1) {      //查询
//            let scopePredicate = NSPredicate(format:"SELF contains[c] %@", searchText)
//            //Swift1.1 -> Swift1.2修改点 start
//            tempArray = self.listTerms.filteredArrayUsingPredicate(scopePredicate)//删除!
//            //Swift1.1 -> Swift1.2修改点 end
//            self.listFilterTerms = NSMutableArray(array: tempArray)
//            //            println(self.listFilterTerms)
//            dataArr = self.listFilterTerms as Array<AnyObject>    //利用dataArr，将检索得到的数据在tableviewcell上输出
//        } else {                //查询所有
//            self.listFilterTerms = NSMutableArray(array: self.listTerms)
//            dataArr = self.listFilterTerms as Array<AnyObject>    //利用dataArr，将检索初始数据在tableviewcell上输出
//        }

        if(searchText.length == 0) {
            //查询所有
            self.listFilterTerms = NSMutableArray(array:self.listTerms)
            
//            let n = self.multi_dataArr.count
//            let m = self.listFilterTerms.count
            multi_dataArr_tmp = []
            for i in 0...self.listFilterTerms.count-1 {
//                let n = self.multi_dataArr.count
                for l in 0...self.multi_dataArr.count-1 {
                    if self.listFilterTerms[i] as! String == self.multi_dataArr[l].1 {
                        multi_dataArr_tmp.append(self.multi_dataArr[l])   //利用dataArr，将检索初始数据在tableviewcell上
                        break
                    }
//                self.multi_dataArr_tmp[i].1 ＝ self.listFilterTerms
                }
            }
            return
        }
        var tempArray : NSArray!
        
        if (scope != -1) {      //查询
            let scopePredicate = NSPredicate(format:"SELF contains[c] %@", searchText)
            //Swift1.1 -> Swift1.2修改点 start
            tempArray = self.listTerms.filtered(using: scopePredicate) as NSArray!//删除!
            //Swift1.1 -> Swift1.2修改点 end
            self.listFilterTerms = NSMutableArray(array: tempArray)
            //            println(self.listFilterTerms)
            multi_dataArr_tmp = []
            if (self.listFilterTerms.count > 0){         //query not 0
                for i in 0...self.listFilterTerms.count-1 {
                    //                let n = self.multi_dataArr.count
                    for l in 0...self.multi_dataArr.count-1 {
                        if self.listFilterTerms[i] as! String == self.multi_dataArr[l].1 {
                            multi_dataArr_tmp.append(self.multi_dataArr[l])   //利用dataArr，将检索初始数据在tableviewcell上
                            break
                        }
                        //                self.multi_dataArr_tmp[i].1 ＝ self.listFilterTerms
                    }
                }
            }
            else{
                multi_dataArr_tmp = []
            }
            
        } else {                //查询所有
            self.listFilterTerms = NSMutableArray(array: self.listTerms)
            multi_dataArr_tmp = []
            for i in 0...self.listFilterTerms.count-1 {
                //                let n = self.multi_dataArr.count
                for l in 0...self.multi_dataArr.count-1 {
                    if self.listFilterTerms[i] as! String == self.multi_dataArr[l].1 {
                        multi_dataArr_tmp.append(self.multi_dataArr[l])   //利用dataArr，将检索初始数据在tableviewcell上
                        break
                    }
                }
            }
        }

   }
    
    
    func initSqlForDistanceViewController() {             //区域数据的初始化
        let filePath:String = Bundle.main.path(forResource: "pwjcs", ofType: "jpg")!
        dataOne_lat_lon = []
        if sqlite3_open(filePath,&database) == SQLITE_OK {
//            print("open database ok!\n")
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
        var company_id:Int64 = sqlite3_column_int64(stmt, 0)
        
//        let chars = UnsafePointer<CChar>(sqlite3_column_text(stmt, 1))
//        let company_name = String(CString: chars, encoding: String.Encoding.utf8)
        let value = String(cString:sqlite3_column_text(stmt, 1)!)                     //swift2->swift3,20170728
        let str = String(cString: value, encoding: String.Encoding.utf8)              //swift2->swift3,20170728
        
        //multi_dataArr_tmp.append( Int64(company_id),company_name)
        
        //println("不支持的类型 \(multi_dataArr_tmp[0].0)")
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //coredata use
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func refreshData() {
        //var f = NSFetchRequest(entityName: "pwjcs")
        //dataArr = context.executeFetchRequest(f, error: nil)!
        //dataArr = sqlite3_open("/Users/Apollo/Desktop/pwj/pwjcs.db",&database)
        tableView.reloadData()
    }
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println(dataArr.count)
        return multi_dataArr_tmp.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        // Configure the cell...
        let name:AnyObject? = multi_dataArr_tmp[indexPath.row].1 as AnyObject?
        //var age:AnyObject? = dataArr[indexPath.row].valueForKey("age")
        //        var label = cell.viewWithTag(2) as! UILabel     //another method to show label.text
        //        label.text = "\(name!)"
        cell.textLabel?.text = "\(name!)"
        return cell
    }
    
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        //var data = dataArr[indexPath.row] as! NSManagedObject
    //        var data_title: String = dataArr[indexPath.row] as! String
    //        var vc = storyboard?.instantiateViewControllerWithIdentifier("UserContent") as! ViewController_content
    //        var filePath:String = NSBundle.mainBundle().pathForResource("pwjcs", ofType: "db")!
    //        var prov2city:String = "prefecture_level_city"
    //
    //        if loc_city == "北京" || loc_city == "上海" || loc_city == "天津" || loc_city == "重庆" {   //不同的查询方式，北京需要按prov查询
    //            prov2city = "province"
    //        }
    //        if sqlite3_open(filePath,&database) == SQLITE_OK {
    //            //if sqlite3_open(databasePath,&database) == SQLITE_OK {
    //
    //            let sql_cellView = "select companyname,liaisons,www,address,description,main_products_using_pwj,related_sailer,used_pwjs from pwj_user where \(prov2city) = '\(self.loc_city)' and com0panyname = '\(data_title)';"
    //            println(sql_cellView)
    //            let sql_cellPosition = "select latitude,longitude from pwj_user where \(prov2city) = '\(self.loc_city)' and companyname = '\(data_title)';"
    ////            println("sql_tableView=\(sql_cellView)")
    //            dataOne = []   //clean the previous data
    //            recordSet(sql_cellView)
    //            dataOne_lat_lon = []    //clean the previous data
    ////            println("****************************")
    //            recordSet(sql_cellPosition)
    ////            println("sql_tableView_21=\(sql_cellView)")
    ////            println("dataOne=\(dataOne)")
    ////            println("dataOne_lat_lon=\(dataOne_lat_lon)")
    //        }else {
    //            sqlite3_close(database)
    ////            println("open database failed")
    //        }
    //
    //        var dataText:NSString = "nil"
    //        dataText = "公司名称：\(dataOne[0])\n"
    //        dataText = "\(dataText)联系方式：\(dataOne[1])\n"
    //        dataText = "\(dataText)网址：\(dataOne[2])\n"
    //        dataText = "\(dataText)地址：\(dataOne[3])\n"
    //        dataText = "\(dataText)公司介绍：\(dataOne[4])\n"
    //        dataText = "\(dataText)主要使用抛丸机产品为：\(dataOne[5])\n"
    //        dataText = "\(dataText)有关销售人员：\(dataOne[6])\n"
    //        dataText = "\(dataText)已有抛丸机销售：\(dataOne[7])\n"
    ////        println(dataText)
    //
    //        vc.data = dataText
    //        vc.lat_from = dv_lat_from      //current location from locationManager
    //        vc.lon_from = dv_lon_from
    //        vc.lat_to = dataOne_lat_lon[0] as! CLLocationDegrees
    //        vc.lon_to = dataOne_lat_lon[1] as! CLLocationDegrees
    //        presentViewController(vc, animated: true, completion: nil)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        dataArr = []   //不能初始化了
        refreshData()
        //        BMKMapView.viewWillAppear = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        //        BMKMapView.delete()=nil           // 不用时，置nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {     //只在press时运行
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showDetail") {
            //Swift1.1 -> Swift1.2修改点 start
            let viewcontroller_content = segue.destination as! DistanceViewController_content//as改为as!
            let indexPath = self.tableView.indexPathForSelectedRow as IndexPath?
            let selectedIndex = indexPath!.row
            
            //added by wzy
            print(multi_dataArr_tmp[selectedIndex])
            
            var cell_title: String = multi_dataArr_tmp[selectedIndex].1 as String
            let cell_id: Int64 =  multi_dataArr_tmp[selectedIndex].0 as Int64
            //            var vc = storyboard?.instantiateViewControllerWithIdentifier("UserContent") as! ViewController_content
            var filePath:String = Bundle.main.path(forResource: "pwjcs", ofType: "jpg")!
            var stmt:OpaquePointer? = nil    // 准备语句
            
            //1 ....
            var sql_cellView:String = ""
            sql_cellView = "select companyname,liaisons,www,address,description,main_products_using_pwj,related_sailer,used_pwjs,latitude,longitude from pwj_user where ID = \(cell_id);"
            
            dataOne_lat_lon = []      //init to make new viewcontroller_content
            dataOne = []
            getInforFromEveryrecord(sql_cellView)
            
            var dataText:NSString = "nil"
            
            for i in 0...7 {
                //                println(dataOne[i])
                if dataOne[i] as! String == "null" {
                    dataOne[i]  = "无" as AnyObject
                }
                
            }
            
            dataText = "公司名称：\(dataOne[0])\n" as NSString        //add       as NSString       20170727
            dataText = "\(dataText)联系方式：\(dataOne[1])\n" as NSString
            dataText = "\(dataText)网址：\(dataOne[2])\n" as NSString
            dataText = "\(dataText)地址：\(dataOne[3])\n" as NSString
            dataText = "\(dataText)公司介绍：\(dataOne[4])\n" as NSString
            dataText = "\(dataText)主要使用抛丸机产品为：\(dataOne[5])\n" as NSString
            dataText = "\(dataText)有关销售人员：\(dataOne[6])\n" as NSString
            dataText = "\(dataText)已有抛丸机销售：\(dataOne[7])\n" as NSString
//            print(dataText)
            
            viewcontroller_content.data = dataText
//            print(viewcontroller_content.data)
            viewcontroller_content.lat_from = dv_lat_from      //跨页面传递数值
            viewcontroller_content.lon_from = dv_lon_from
            viewcontroller_content.lat_to = dataOne_lat_lon[0] as! CLLocationDegrees
            viewcontroller_content.lon_to = dataOne_lat_lon[1] as! CLLocationDegrees
            
            self.searchBar.resignFirstResponder()    //收起键盘
        }
    }
    
    
    func getInforFromEveryrecord(_ sql: String) {
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
            // 单步获取SQL执行的结果 -> sqlite3_step 对应一条记录
            while sqlite3_step(stmt) == SQLITE_ROW {
                // 获取每一条记录的数据
                delwithEveryRecord(stmt!)
            }
        }
    }

    
    
    ///  获取每一条数据的记录
    ///
    ///  - parameter stmt: prepared_statement 对象
    func delwithEveryRecord(_ stmt:OpaquePointer) {
        // 获取到记录
        let count = sqlite3_column_count(stmt)
        var sqlite_int:Int64 = 0
        var sqlite_double:Double = 0.000000
        var sqlite_text:NSString = " "
        //        println("获取到记录，共有\(count)列 ")
        // 遍历每一列的数据
        for i in 0..<count {
            let type = sqlite3_column_type(stmt, i)
            //            sqlite_int = 0
            //            sqlite_text = "none"
            // 根据字段的类型，提取对应列的值
            switch type {
            case SQLITE_INTEGER:
                sqlite_int = sqlite3_column_int64(stmt, i)
                //println(sqlite_int)
                //                println("整数 \(sqlite3_column_int64(stmt, i))")
            case SQLITE_FLOAT:
                sqlite_double = sqlite3_column_double(stmt, i)
                //println(sqlite_double)
                //                println("小数 \(sqlite3_column_double(stmt, i))")
                dataOne_lat_lon.append(sqlite_double as AnyObject)
            case SQLITE_NULL:
                var sqlite_nil = NSNull()
                //println(sqlite_nil)
                //                println("空 \(NSNull())")
            case SQLITE_TEXT:
                let value = String(cString:sqlite3_column_text(stmt, i)!)                     //swift2->swift3,20170728
                let str = String(cString: value, encoding: String.Encoding.utf8)              //swift2->swift3,20170728
//                let chars = UnsafePointer<CChar>(sqlite3_column_text(stmt, i))
//                let str = String(CString: chars, encoding: String.Encoding.utf8)
//                let chars = UnsafePointer(sqlite3_column_text(stmt, i)).withMemoryRebound(to: CChar.self, capacity: 100){      //20170727
//                    $0.pointee
//                }
//                let str = String(describing: chars)//, encoding: String.Encoding.utf8)     //20170727
                sqlite_text = str as! NSString
                //                println("字符串 \(str)")
                dataOne.append(sqlite_text)
            case let type:
                print("不支持的类型 \(type)")
            }
        }
    }

    
    
    
}
