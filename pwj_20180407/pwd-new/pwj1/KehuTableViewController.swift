//
//  KehuTableViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/11/21.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit

import Foundation

class KehuTableViewController: UITableViewController {

    var listTeams : NSArray!
    
    //added by delphi0127
    var cellSelected : NSMutableArray!
    
    var recent_selected:Bool = true
    
    var choosen_pwjs:[String] = []
    
    //for timer
    var count_timer:Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.


        
        let plistPath = Bundle.main.path(forResource: "./pwj_client_pics/factory", ofType: "plist")
        //获取属性列表文件中的全部数据
        self.listTeams = NSArray(contentsOfFile: plistPath!)
        
        //added by delphi0127
        self.cellSelected = NSMutableArray()
        
        //login failed, do noting
        self.cellSelected.add(0)
        self.title = "关注客户类型"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "前进>", style: .plain , target: self, action: #selector(KehuTableViewController.Click))
//        self.navigationItem.rightBarButtonItems?.removeAll()
        var regsuccess : Bool = false
        let filePath:String = NSHomeDirectory() + "/Documents/my.plist"
        let fileManger = FileManager.default
        let exist = fileManger.fileExists(atPath: filePath)
        if (!exist)
        {

            
            return
            
        }
        
        var array:NSArray?
        array = NSArray(contentsOfFile: filePath)
        
        
        var username = array![0] as! String
        var password = array![1] as! String
        
        global_telephone = username
        global_password  = password

        
        if (username  == "" || password == "" || username.characters.count > 50 || password.characters.count > 50)
        {

            
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
//            NSLog("responseData : %@", operation?.responseString())
            
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
                
                
                regsuccess = true
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注销", style: .plain , target: self, action: "leftClick")
                
               
                
                sleep(1)
            }
            else
            {
                //return
                regsuccess = false
            }
            
            
            }, errorHandler: { (operation, err) -> Void in
                if let saveError = err?.localizedDescription as? NSString
                {NSLog("MKNetwork请求错误 : %@", saveError)
                }
//                NSLog("MKNetwork请求错误 : %@", err?.localizedDescription)
                
                regsuccess = false
                
                var alert = UIAlertView()
                alert.title = "注意!"
                alert.message = err?.localizedDescription
                alert.addButton(withTitle: "Yes")
                alert.show()
                
                
            }
            
            
        )
        engine?.enqueue(op)
        
        
        
        
        //下面这段代码还需要进一步的测试
//        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        
 
    }

    //this is for licence
    func createFile(_ name:String,fileBaseUrl:URL){
        let manager = FileManager.default
        
        let file = fileBaseUrl.appendingPathComponent(name)
//        print("文件: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=",options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
//            print("文件创建结果: \(createSuccess)")
        }
    }
    
    //this is for licence
    func update()
    {
        print("time internal...\n")
        let fileManger = FileManager.default
//        let filepath:String = NSHomeDirectory() + "/timer.txt"
        let filepath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/timer.txt"   //document can write
        

        
        
        let exist = fileManger.fileExists(atPath: filepath)
        if (exist)
        {
            
            
            //read file
            let fileUrl = URL(string: filepath)
            //let writeHandler = NSFileHandle(forWritingToURL:fileUrl)
            let file: FileHandle? = FileHandle(forReadingAtPath: filepath)
            if file == nil {
                print("File open failed")
            } else {
                file?.seek(toFileOffset: 0)
                let databuffer = file?.readData(ofLength: 20)
                let readString = NSString(data: databuffer!, encoding: String.Encoding.utf8.rawValue)
                print("文件中的内容: \(readString)")
                
                count_timer = (readString)!.intValue
                
                count_timer = count_timer + 1
                
                file?.closeFile()
            }
            
            //write file
            let file1: FileHandle? = FileHandle(forUpdatingAtPath: filepath)
            if file1 == nil {
                print("File open failed")
            } else {
                let data = (String(count_timer) as
                    NSString).data(using: String.Encoding.utf8.rawValue)
                //delete the contents of the file
                file1?.truncateFile(atOffset: 0)
                //write data into the file
                file1?.seek(toFileOffset: 0)
                file1?.write(data!)
                file1?.closeFile()
            }
            
            if(count_timer > 1000000)//24hours = 86400
            {
                let alert = UIAlertView()
                alert.title = "Attenation!"
                alert.message = "该版本是试用版本，如果想获取正版，请联系13805113646"
                alert.addButton(withTitle: "Yes")
                alert.show()
                
                //这里要不要删除相关数据库，当前，我是这么考虑的，可以先不删除，等后面再说。
                //FileDelete.deleteFile(<#path: String#>, directory: <#NSSearchPathDirectory#>, subdirectory: <#String?#>)
                
                
                
                
            }
            
        }
        else
        {

            let fileUrl = URL(string: filepath)
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=",options:.ignoreUnknownCharacters)
            let createSuccess = fileManger.createFile( atPath: (fileUrl?.path)!, contents:data, attributes:nil)
//            print("文件创建结果: \(createSuccess)")
        }
    }

    func leftClick()
    {

        
        //1. create local file
        let array = NSArray(objects: "","")
        let filePath:String = NSHomeDirectory() + "/Documents/my.plist"
        
        //2. write to local file
        //write file
        array.write(toFile: filePath, atomically: true)
        
        global_telephone = ""
        global_password  = ""
        //下面这个代码直接回到登陆页面
        
        /*
        let login = self.storyboard?.instantiateViewControllerWithIdentifier("loginviewcontroller") as! loginViewController
        self.presentViewController(login, animated: true, completion: nil)
*/
        self.navigationItem.leftBarButtonItems?.removeAll()   //注销 键消失
        let alert = UIAlertView()
        alert.title = "通知"
        alert.message = "用户注销成功"
        alert.addButton(withTitle: "Yes")
        alert.show()
    
    }

    func Click()
    {
//        print("hi!\n", terminator: "")
        //let second = self.storyboard?.instantiateInitialViewController("secondViewController") as? secondViewController
        
        
        //把选取到的抛丸机类型传给下一个controller
        choosen_pwjs.removeAll()
        
        if (self.cellSelected.contains(0))
        {
            choosen_pwjs.append("钢")
        }
        if (self.cellSelected.contains(1))
        {
            choosen_pwjs.append("铁")
        }
        if (self.cellSelected.contains(2))
        {
            choosen_pwjs.append("钢铁")
        }
        if (self.cellSelected.contains(3))
        {
            choosen_pwjs.append("铝")
        }
        if (self.cellSelected.contains(4))
        {
            choosen_pwjs.append("轮船")
        }
        if (self.cellSelected.contains(5))
        {
            choosen_pwjs.append("锚链")
        }
        if (self.cellSelected.contains(6))
        {
            choosen_pwjs.append("矿山机械")
        }
        
        if (choosen_pwjs.count == 0)
        {
            let alertController = UIAlertController(title: "注意", message: "请至少选择一种客户类型", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default,
                handler: {
                    action in
//                    print("点击了确定", terminator: "")
            })

            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            if (recent_selected == true)
            {
                let distance = self.storyboard?.instantiateViewController(withIdentifier: "distanceviewcontroller") as? DistanceViewController
                distance!.choosen_pwjs = self.choosen_pwjs
                self.navigationController?.pushViewController(distance!, animated: true)
                
            }
            else
            {
            
                let rav = self.storyboard?.instantiateViewController(withIdentifier: "raviewcontroller") as? RAViewController
                rav!.choosen_pwjs = self.choosen_pwjs
                self.navigationController?.pushViewController(rav!, animated: true)
                
                
            }

        }
        

        self.report_click()
        
        
    }
    
    func report_click() {
        
        var path = String(format: "/pwjstore/click.php?phone=%@",global_telephone)
        path = path.addingPercentEscapes(using: String.Encoding.utf8)!
        
        _ = NSMutableDictionary()
        
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
                if let saveError = err?.localizedDescription as NSString?
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        let alertController = UIAlertController(title: "系统提示",
            message: "您确定要离开hangge.com吗？", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default,
            handler: {
                action in
                print("点击了确定")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
        /*
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellIdentifier)
        }
        */
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {

                
                cell.textLabel?.text = "选择您附近的客户"
                let imagePath = String(format: "./pwj_client_pics/附近.jpg")
                //Swift1.1 -> Swift1.2修改点 end
                
                cell.imageView?.image = UIImage(named: imagePath)
                
                if (recent_selected == true)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                else
                {
                    cell.accessoryType =  UITableViewCellAccessoryType.none
                }
                
                
                
                return cell
            }
                
            else
            {

                cell.textLabel?.text = "选择某个城市的客户"
                let imagePath = String(format: "./pwj_client_pics/城市.jpg")
                //Swift1.1 -> Swift1.2修改点 end
                
                cell.imageView?.image = UIImage(named: imagePath)
                
                
                if (recent_selected == false)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                else
                {
                    cell.accessoryType =  UITableViewCellAccessoryType.none
                }
                
                return cell
            }
            
        }
        else
        {

            let row = indexPath.row
            //Swift1.1 -> Swift1.2修改点 start
            let rowDict = self.listTeams[row] as! NSDictionary//as改为as!
            
            cell.textLabel?.text = rowDict["name"] as? String
            
            let imagePath = String(format: "./pwj_client_pics/%@.jpg", rowDict["image"] as! String)
            //Swift1.1 -> Swift1.2修改点 end
            
            cell.imageView?.image = UIImage(named: imagePath)
            
            //updated by delphi0127
            if (self.cellSelected.contains(indexPath.row))//updated on 20160213
            {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else
            {
                cell.accessoryType =  UITableViewCellAccessoryType.none
                
            }
            
            
            
            return cell
            
            
            
        }
    }
    
    //override func layoutSubView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                recent_selected = true
            }
            else
            {
                recent_selected = false
            }
        }
        else
        {
            if (self.cellSelected.contains(indexPath.row))
            {
                self.cellSelected.remove(indexPath.row)
            }
            else
            {
                self.cellSelected.add(indexPath.row)
            }
            
        }
        self.tableView.reloadData()
    }
    
    //for sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return 2
        }
        else
        {
            return listTeams.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section  == 0)
        {
            return "客户位置"
        }
        else
        {
            return "客户类型"
        }
        
        
    }
    

    
    



}
