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
    
    var bbb:String = "sssss"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
//        APPHttpTool.getRequestNetDicDataUrl("version/latest?platform=1", params:Dictionary()) { (result:Bool, idObject:Any, code:NSInteger) in
//
//            let jsonData:[String:Any] = idObject as! [String:Any]
//
//            APPAlertTool.hideLoading()
//            AlertMessage(msg: "回调完数据\(jsonData)")
//        }
                
        self.title = "SwiftOne"
        
        
                
        self.view.addSubview(oneView)
        
        oneView.backgroundColor = DynamicColor(lightStylecolor: UIColor.red, darkStylecolor: UIColor.green)
        
        
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
        
        DispatchQueue.global().async(group: DispatchGroup.init(), execute: DispatchWorkItem.init {
            Print("线程：\(Thread.current)")
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Print("延迟执行的函数")
        }
        



    }
    
    func blockAAAAAA(from text:String, num:Int = 0) {

    
    }
}


class Demo {
    
    var name:String = ""
    
    var age:Int = 0
    
//    init(na:String, ag:Int) {
//
//        name = na
//
//        age = ag
//    }
//
//    init(nam:String) {
//        name = nam
//        age = 11
//    }
    
    
}

extension Demo {
    
    var score: Int {
        10
    }
    
}




enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}

enum Person:Int {
     case ace = 1
     case two, three, four, five, six, seven, eight, nine, ten
     case jack, queen, king
     func simpleDescription() -> String {
         switch self {
         case .ace:
             return "ace"
         case .jack:
             return "jack"
         case .queen:
             return "queen"
         case .king:
             return "king"
         default:
             return String(self.rawValue)
         }
     }
}

