//
//  registerViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 16/1/28.
//  Copyright (c) 2016年 Apollo. All rights reserved.
//

import UIKit

class registerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatpassword: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var ID_front: UIImageView!
    @IBOutlet weak var ID_back: UIImageView!
    
    var ID_front_path:String = ""
    var ID_back_path:String  = ""
    
    var front_back:Int8 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        self.navigationItem.backBarButtonItem?.title="返回"
        
////        let imageView: UIImageView = UIImageView()
//        ID_front.userInteractionEnabled = true
//        let tapGR = UITapGestureRecognizer(target: ID_front, action: "tapHandler:")
//        ID_front.addGestureRecognizer(tapGR)
//        func tapHandler(sender:UITapGestureRecognizer) {
//            let photoPicker         = UIImagePickerController()
//            photoPicker.delegate    = self
//            photoPicker.sourceType  = .PhotoLibrary
//            self.presentViewController(photoPicker, animated: true, completion: nil)
//            
//            self.front_back = 0
//            ///////todo....
//        }
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //touch the black to close keyboard
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
    
    @IBAction func reg(_ sender: AnyObject) {
        var tmp_username = self.username.text
        var tmp_password = self.password.text
        var tmp_repeatpassword = self.repeatpassword.text
        var tmp_telephone = self.telephone.text
        var tmp_ID = self.ID.text

        
        if (tmp_username == "" || tmp_password == "" || tmp_username!.characters.count > 50 || tmp_password!.characters.count > 50 || tmp_repeatpassword=="" || tmp_telephone == "" || tmp_repeatpassword!.characters.count > 50 || tmp_telephone!.characters.count > 50 )//|| tmp_ID == "" || tmp_ID!.characters.count > 50，这边是可以为空的。
        {
            var alert = UIAlertView()
            alert.title = "Attenation!"
            alert.message = "输入是不合法的！"
            alert.addButton(withTitle: "Yes")
            alert.show()
        }
        
        
        var path = String(format: "/thinkphp-login-register/index.php/Home/Login/register.html")
        path = path.addingPercentEscapes(using: String.Encoding.utf8)!
        
        var param = NSMutableDictionary()
        param.setValue(tmp_username, forKey:"username")
        param.setValue(tmp_password, forKey:"password")
        param.setValue(tmp_repeatpassword, forKey:"repassword")
        param.setValue(tmp_telephone, forKey:"mobile")
        param.setValue(tmp_ID, forKey:"credit")
        
        //and php here ...
        
        var engine = MKNetworkEngine(hostName: server_IP, customHeaderFields: nil)
        //var op = engine.operationWithPath(path)
        var op = engine?.operation(withPath: path, params: param as! [AnyHashable: Any], httpMethod: "POST")
        
        op?.addFile( ID_front_path, forKey: "cardup")
        op?.addFile( ID_back_path, forKey: "cardback")
        
        
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
            
            if (aString!.contains("success"))
            {
                NSLog("ok")
                let alert = UIAlertView()
                alert.title = "恭喜您!"
                alert.message = "注册成功"//这里最好给出错误的原因
                alert.addButton(withTitle: "Yes")
                alert.show()
                let login = self.storyboard?.instantiateViewController(withIdentifier: "loginviewcontroller")
                self.present(login!, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "注意!"
                alert.message = String(aString!)
                alert.addButton(withTitle: "Yes")
                alert.show()
            }
            
            //if failture ...
            
            
            
            
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
    
    
    @IBAction func openPhotoLibrary(_ sender: AnyObject) {
        let photoPicker         = UIImagePickerController()
        photoPicker.delegate    = self
        photoPicker.sourceType  = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if (self.front_back == 0)
        {
            ID_front.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as? URL
            self.ID_front_path = imageURL!.path
            
            
            self.dismiss(animated: false, completion: nil)
        }
        else
        {
            ID_back.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as? URL
            self.ID_back_path = imageURL!.path
            
            self.dismiss(animated: false, completion: nil)
        }
        
    }

    @IBAction func regcancel(_ sender: AnyObject) {
        let tarbar = self.storyboard?.instantiateViewController(withIdentifier: "TarBarController")
        self.present(tarbar!, animated: true, completion: nil)
    }
    @IBAction func openfront(_ sender: AnyObject) {
        let photoPicker         = UIImagePickerController()
        photoPicker.delegate    = self
        photoPicker.sourceType  = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
        
        self.front_back = 0
    }
    
    
    @IBAction func openback(_ sender: AnyObject) {
        let photoPicker         = UIImagePickerController()
        photoPicker.delegate    = self
        photoPicker.sourceType  = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
        
        self.front_back = 1
        
    }
    
    
    
    

    
    
}
