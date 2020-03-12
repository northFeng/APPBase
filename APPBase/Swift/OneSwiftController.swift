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
        let json: [String: Any] = [
            "name1": 666,
            "name2": NSMutableString(string: "777"),
            "name3": [1,[2,3],"4"],
            "name4": NSDecimalNumber(string: "0.123456789012345678901234567890123456789"),
            "name5": 6.66,
            "name6": false,
            "name7": NSURL(fileURLWithPath: "/users/mj/desktop"),
            "name8": URL(string: "http://www.520suanfa.com") as Any,
            "name9": Date(timeIntervalSince1970: 1565922866)
        ]
        
        let demo2 = json.kj.model(Deno2.self)
        
        self.title = demo2.name3 as String
        
        
    }
    
    
    struct Deno2: Convertible {
        var name1: String = ""
        var name2: String = ""
        var name3: NSString = ""
        var name4: NSString = ""
        var name5: NSMutableString = ""
        var name6: NSMutableString = ""
        var name7: String = ""
        var name8: String = ""
        var name9: String = ""
    }
    
    //MARK: ************************* demo1 *************************
    func demo1() {
        let jsonStr:[String:Any] = ["name":"张三","weight":6.66,"demos":[["name":"小猫","weight":6.66],["name":"小狗","weight":7.66]]]
        let jsonArray:[[String:Any]] = [["name":"小猫","weight":6.66],["name":"小狗","weight":7.66]]
        
        
        let one1 = jsonStr.kj.model(Student.self) //调用json的model方法，传入模型类型，返回模型实例

        let one2 = model(from: jsonStr, type: Student.self)//调用一个全局函数来完成JSON转模型
        
        print("数据1\(one1.name)数据2\(one2)")
        
        var array:[Demo] = modelArray(from: jsonArray, Demo.self)
    }
    
    class Student:BaseModel {
        
        var name:String = ""
        
        var weight:Double = 0.0
        
        var demos:[Demo]?
        
        
        func aaa() {
            name = "哈哈哈"
            weight = 8.2
        }
    }

    struct Demo:Convertible {
        
        var name:String = ""
        
        var weight:Double = 0.0
    }

}

