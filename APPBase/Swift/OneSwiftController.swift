//
//  OneSwiftController.swift
//  APPBase
//
//  Created by 峰 on 2020/1/20.
//  Copyright © 2020 ishansong. All rights reserved.
//

import UIKit


class OneSwiftController: APPBaseController {
    
    @objc var infoStr:NSString = ""
    
    var oneView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = APPColorFunction.whiteColor()
        
        if APPManager.sharedInstance().isLogined {
            print("已经登录")
        }
        
        APPAlertTool.showLoading(on: self.view)
        APPHttpTool.postRequestNetDicDataUrl("https://www.baidu.com", params: Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
            
            APPAlertTool.hideLoading()
            print("回调完数据")
        }
        
        self.title = "SwiftOne"
        
        print("传过来的数据\(infoStr)")
        
        self.view.addSubview(oneView)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
