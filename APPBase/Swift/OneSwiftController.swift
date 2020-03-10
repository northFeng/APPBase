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
    
    var oneView:UIView = UIView()
    
    let tableView:UITableView = UITableView(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height: 200)), style: UITableViewStyle.grouped)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                    

        APPAlertTool.showLoading(on: self.view)
        
        APPHttpTool.getRequestNetDicDataUrl("", params: Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
            
        }
        
        APPHttpTool.getRequestNetDicDataUrl("version/latest?platform=1", params:Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
            
            APPAlertTool.hideLoading()
            AlertMessage(msg: "回调完数据")
        }
        
        self.title = "SwiftOne"
                
        self.view.addSubview(oneView)
        
        oneView.backgroundColor = UIColor.red
        oneView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.top.equalToSuperview().offset(200)
            make.width.height.equalTo(50)
        }
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.blue
        button.setTitle("点击", for: .normal)
        button.addTarget(self, action: #selector(jsonToModel), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.right.equalTo(oneView).offset(20)
            make.top.equalTo(oneView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    
    }
    
    @objc func onClickButton(button:UIButton) {
        
        printNetBlock(text: "网络请求") { (result:Bool, idObject:Any, code:Int) in
            Print("回调了网络数据：\(result)+\(idObject)+\(code)")
        }
    }
    
    
    
    func blockAction(result:Bool) {
        
        Print("哈哈哈哈");
    }
    
    func printLogString(text:String, block:APPBackClosure) -> Void {
        
        Print(text)
        block(true,2)
    }
    
    func printNetBlock(text:String, block:APPNetClosure) -> Void {
        Print(text)
        block(true,"回调数据",100)
    }
    
    @objc func jsonToModel() {
        let jsonStr:[String:Any] = ["name":"张三","weight":6.66]
        
        let one1 = jsonStr.kj.model(Student.self) //调用json的model方法，传入模型类型，返回模型实例

        let one2 = model(from: jsonStr, type: Student.self)//调用一个全局函数来完成JSON转模型
        
        print("数据1\(one1.name)数据2\(one2)")
        
        
        var one3 = Demo()
        one3.aaa()
        
    }

    
    class Student:BaseModel {
        
        var name:String = ""
        
        var weight:Double = 0.0
        
        func aaa() {
            name = "哈哈哈"
            weight = 8.2
        }
    }
    
    struct Demo {
        
        var name:String = ""
        
        var weight:Double = 0.0
        
        mutating func aaa() {
            self.name = "哈哈哈"
            self.weight = 8.2
        }
    }
    

}
