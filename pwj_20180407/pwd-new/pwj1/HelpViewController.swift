//
//  HelpViewController.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/12/7.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpTextView: UITextView!
//    @IBOutlet weak var jiudaweb: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        helpTextView.text = "    抛丸机销售助手，为您提供大量的潜在客户！\n    1>抛丸机销售助手能根据您的位置，提供距您100公里内潜在的抛丸机客户分布！\n    2>您能根据省市浏览不同地方潜在的抛丸机客户分布！\n    3>登录和注册销售助手，我们还将为您提供——国内任何省市的详细抛丸机潜在客户信息！\n    4>登录和注册销售助手，我们还将带您学习19大内容！\n\n    如果您有使用建议和需求，请联系吴总：\n    手机：13805113646\n    "
        
        self.title = "帮助"
        
        helpTextView.sizeToFit()
        
        //打开十九大学习web
//        let url = URL(string: "http://43.227.101.2/《十九大报告全文》.pdf")
//        let request = URLRequest(url: url!)
//        jiudaweb.loadRequest(request)
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
