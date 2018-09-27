//
//  loginViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 16/1/28.
//  Copyright (c) 2016年 Apollo. All rights reserved.
//

import UIKit

//statistics
var global_telephone = ""
var global_password  = ""
var server_IP = "103.72.164.2"   //42.200.33.22,43.227.101.2//103.45.9.165
//var server_IP = "192.168.6.206"

class loginViewController: UIViewController {

    
    @IBOutlet weak var teleTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title="返回"
        
        //self.autoLogin()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//touch the black to close keyboard
        self.view.endEditing(true)
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
    
    
    @IBAction func starLogin(_ sender: AnyObject) {
        var username = teleTextField.text
        var password = passwordTextField.text
        self.teleTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        if (username == "" || password == "" || username!.characters.count > 50 || password!.characters.count > 50)
        {
            var alert = UIAlertView()
            alert.title = "Attenation!"
            alert.message = "输入的用户名和密码是不合法的！"
            alert.addButton(withTitle: "Yes")
            alert.show()
        }
        
        //statistics
        global_telephone = username!
        global_password  = password!
        
        var path = String(format: "/thinkphp-login-register/index.php/Home/Login/login.html")
        path = path.addingPercentEscapes(using: String.Encoding.utf8)!
        
        var param = NSMutableDictionary()
        
        param.setValue(username, forKey: "mobile")
        param.setValue(password, forKey: "password")
        
        var engine = MKNetworkEngine(hostName: server_IP, customHeaderFields: nil)
        var op = engine?.operation(withPath: path, params: param as! [AnyHashable: Any], httpMethod: "POST")
        
        

        op?.addCompletionHandler({ (operation) -> Void in
            if let saveError = operation?.responseString() as? NSString     //swift2 ->swift3,20170727
                {NSLog("responseData : %@", saveError)
            }
/*
        op?.addCompletionHandler({ (operation) -> Void in
             NSLog("responseData : %@", operation?.responseString())
 */
            
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
    
               //1. create local file
               let array = NSArray(objects: username!,password!)
               let filePath:String = NSHomeDirectory() + "/Documents/my.plist"
                
               //2. write to local file
               //write file
               array.write(toFile: filePath, atomically: true)
                
               //3. nvaigate
               let tarbar = self.storyboard?.instantiateViewController(withIdentifier: "TarBarController")
               self.present(tarbar!, animated: true, completion: nil)
                
                
            }
            else
            {
                var alert = UIAlertView()
                alert.title = "Attenation!"
                alert.message = "用户名或者密码错误，请重新登录"
                alert.addButton(withTitle: "Yes")
                alert.show()
            }
            
            
            }, errorHandler: { (operation, err) -> Void in
                if let saveError = err?.localizedDescription as? NSString {
                NSLog("MKNetwork请求错误 : %@", saveError)
                }
/*
            }, errorHandler: { (operation, err) -> Void in
                 
                NSLog("MKNetwork请求错误 : %@", err?.localizedDescription)
                 
*/
                var alert = UIAlertView()
                alert.title = "注意!"
                alert.message = err?.localizedDescription
                alert.addButton(withTitle: "Yes")
                alert.show()
                
            }
        
        
        )
        engine?.enqueue(op)
    }
    
    

    
    func autoLogin() {
        let filePath:String = NSHomeDirectory() + "/Documents/my.plist"
        let fileManger = FileManager.default
        var exist = fileManger.fileExists(atPath: filePath)
        if (!exist)
        {
            return
            //let tarbar = self.storyboard?.instantiateViewControllerWithIdentifier("TarBarController")
            //self.presentViewController(tarbar!, animated: true, completion: nil)
            
        }
        
        var array:NSArray?
        array = NSArray(contentsOfFile: filePath)
        
        
        var username = array![0] as! String
        var password = array![1] as! String

        if (username == "" || password == "" || username.characters.count > 50 || password.characters.count > 50)
        {
            return
        }
        
        //statistics
        global_telephone = username
        global_password  = password
        
        
        var path = String(format: "/thinkphp-login-register/index.php/Home/Login/login.html")
        path = path.addingPercentEscapes(using: String.Encoding.utf8)!
        
        var param = NSMutableDictionary()
        
        param.setValue(username, forKey: "mobile")
        param.setValue(password, forKey: "password")
        
        var engine = MKNetworkEngine(hostName: server_IP, customHeaderFields: nil)
        var op = engine?.operation(withPath: path, params: param as! [AnyHashable: Any], httpMethod: "POST")
        
        
        
        op?.addCompletionHandler({ (operation) -> Void in
            if let saveError = operation?.responseString() as? NSString
                {NSLog("responseData : %@", saveError)
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
                
                
                //3. nvaigate
                let tarbar = self.storyboard?.instantiateViewController(withIdentifier: "TarBarController")
                self.present(tarbar!, animated: true, completion: nil)
                
                //4.
                
            }
            else
            {
                return
            }
            
            
            }, errorHandler: { (operation, err) -> Void in
                if let saveError = err?.localizedDescription as? NSString
                    {NSLog("MKNetwork请求错误 : %@", saveError)
                    }
//                NSLog("MKNetwork请求错误 : %@", err?.localizedDescription)
                
                var alert = UIAlertView()
                alert.title = "注意!"
                alert.message = err?.localizedDescription
                alert.addButton(withTitle: "Yes")
                alert.show()
            }
            
            
        )
        engine?.enqueue(op)
    }

    
    
    
    /*
    func startRequest()
    {
        
        //http://192.168.5.150:8000/
        //192.168.5.150:8000/login/?id_username=test&id_password=test
        var path = String(format: "/login/?id_username=test&id_password=test")
        path = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        //var path = String(format: "/service/mynotes/WebService.php?email=%@&type=%@&action=%@", "<你的51work6.com用户邮箱>", "JSON", "query")
        
        var engine = MKNetworkEngine(hostName: "192.168.5.150:8000", customHeaderFields: nil)
        var op = engine.operationWithPath(path)
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@", operation.responseString())
            /*
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            //self.reloadView(resDict)
            */
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                
        })
        engine.enqueueOperation(op)
        
    }
    */
    
    
    //192.168.6.206/thinkphp-login-register/index.php/Home/Login/register.html
    
    
    /*
    @IBAction func startRegister(sender: AnyObject) {
        let register = self.storyboard?.instantiateViewControllerWithIdentifier("registerViewController") as? registerViewController
        
        self.navigationController?.pushViewController(register!, animated: true)
        
    }
    */
    
    
    /*
    //it is userful here......
    @IBAction func onClick(sender: AnyObject) {
        
        self.imageView1.image = nil
        
        let filePath = NSBundle.mainBundle().pathForResource("test1", ofType:"jpg")
        let path = "upload_file.php"
        
        var param = ["email" : "<你的51work6.com用户邮箱>"]
        
        var engine = MKNetworkEngine(hostName: "192.168.6.207", customHeaderFields: nil)
        var op = engine.operationWithPath(path, params: param, httpMethod: "POST")
        
        //op.addFile(filePath, forKey: "afile")
        op.freezable = true
        
        op.addCompletionHandler({ (operation) -> Void in
            NSLog("upload file finished!")
            let data = operation.responseData()
            
            if data != nil {
                //返回数据失败
                var resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary!
                
                if resDict != nil {
                    let resultCode: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
                    
                    if (resultCode.integerValue < 0) {
                        let errorStr = resultCode.errorMessage
                        let alertView = UIAlertView(title: "错误信息", message: errorStr,
                            delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                        
                        return
                    }
                }
                
                //self.seeImage()
                
            }
            
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
        })
        
        engine.enqueueOperation(op)
        
    }
 */

    @IBAction func startReg(_ sender: AnyObject) {
        let register = self.storyboard?.instantiateViewController(withIdentifier: "rregisterViewController") as? registerViewController
        
//        self.navigationController?.pushViewController(register!, animated: true)
        self.present(register!, animated: true, completion: nil)
    }
    

}
