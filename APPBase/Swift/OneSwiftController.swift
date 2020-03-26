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
    
    let imgview = UIImageView(frame: CGRect(origin: CGPoint(x: 10, y: 350), size: CGSize(width: 200, height: 300)))
    
    
    let tableView:UITableView = UITableView(frame: CGRect(origin: CGPoint(x: 10, y: 200), size: CGSize(width: 200, height: 300)), style: UITableViewStyle.grouped)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                    

        APPAlertTool.showLoading(on: self.view)
        
        APPHttpTool.getRequestNetDicDataUrl("", params: Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
            
        }
        
        APPHttpTool.getRequestNetDicDataUrl("version/latest?platform=1", params:Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
            
            let jsonData:[String:Any] = idObject as! [String:Any]
            
            let model2 = model(from: jsonData, VersionModel.self)
            
            let model = jsonData.kj.model(VersionModel.self)
            
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
        button.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.right.equalTo(oneView).offset(20)
            make.top.equalTo(oneView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        imgview.backgroundColor = UIColor.red
        self.view.addSubview(imgview)
    
    }
    
    @objc func onClickButton(button:UIButton) {
        
//        printNetBlock(text: "网络请求") { (result:Bool, idObject:Any, code:Int) in
//            Print("回调了网络数据：\(result)+\(idObject)+\(code)")
//        }
        
        AF.request("https://httpbin.org/get",method: .get).response { responds in
            print("请求数据---->\(responds)")
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
        
        ImageViewLoadImage(imgView: imgview, url: "http://t8.baidu.com/it/u=3571592872,3353494284&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1584778607&t=2b31cc8eab4398730712f963bf2cf10a", placeholderImgName: "tigger")

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

    class VersionModel: BaseModel {
        var describe = ""
        var downloadUrl = ""
        var mustLoginAgain:Int = 0
        var mustUpdate:Int = 0
        var platform:Int = 0
        var versionCode:Int = 0
        var versionName = ""
    }
}




