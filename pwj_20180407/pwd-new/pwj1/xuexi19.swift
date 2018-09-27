//
//  xuexi19.swift
//  抛丸机销售助手v
//
//  Created by nait on 2017/12/7.
//  Copyright © 2017年 Apollo. All rights reserved.
//

import Foundation
import UIKit
let url_19 = URL(string: "http://103.72.164.2/19/")
//let url = URL(string: "http://cpc.people.com.cn/19th/")

class xuexi19: UIViewController {
    
    //@IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var jiudaweb: UIWebView!
    @IBOutlet weak var refresh: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        helpTextView.text = "    抛丸机销售助手，为您提供大量的潜在客户！\n    1>抛丸机销售助手能根据您的位置，提供距您100公里内潜在的抛丸机客户分布！\n    2>您能根据省市浏览不同地方潜在的抛丸机客户分布！\n    3>登录和注册销售助手，我们还将为您提供——国内任何省市的详细抛丸机潜在客户信息！\n\n    如果您需要专业的APP销售服务，比如搜索其它某个国家的用户；如果您需要在APP上发送您的产品和广告；如果您希望在某些方面需要改进；如果您想开发类似的专业APP，请您联系吴总：\n    手机：13805113646\n    "
//        
//        self.title = "帮助"
//        
//        helpTextView.sizeToFit()
//        
        //打开十九大学习web
//        let request = URLRequest(url: url!)
//        jiudaweb.loadRequest(request)
        let request = NSMutableURLRequest(url:url_19!)
        request.setValue("83155b06b7a407f0d406bf257d44ad460dd2fdfc", forHTTPHeaderField: "Authorization")
//        jiudaweb.loadRequest(request as URLRequest)
        print(jiudaweb.loadRequest(request as URLRequest))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.viewDidLoad()
        //打开十九大学习web
        let request = URLRequest(url: url_19!)
        jiudaweb.loadRequest(request)
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
    
}
