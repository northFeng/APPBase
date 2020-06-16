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
                
        AlertLoading()
        APPNetTool.getNetDicData_oc(url: "v2/front/tag/getTagList", params: ["tagType":1]) { (result:Bool, idObject:Any, code:Int) in
            AlertHideLoading()
            if result {
                let arrayJson:[AnyObject] = idObject as! [AnyObject]
                
                let model = arrayJson.kj.modelArray(AudioModel.self)
                
                let model2 = APPNetTool.jsonToModel(json: arrayJson, Model: AudioModel.self)
                
                if let array:[AnyObject] = model2 as? [AnyObject] {
                    Print("----->结果\(array)")
                }else{
                    Print("数据转化失败")
                }
                /**
                 chName = "\U8eab\U4f53\U90e8\U4f4d";
                 createTime = "2019-12-12 10:42:58";
                 enName = "Body Parts";
                 picUrl = "http://wdkid-audio.oss-cn-beijing.aliyuncs.com/img/Body%20Parts.png";
                 tagId = 3443534;
                 tagStatus = 1;
                 tagType = 4;
                 updateTime = "2019-12-12 10:42:58";
                 */
                Print("请求结果--->\(model)")
            } else {
                Print("请求出错--->\(idObject)")
            }
        }
    }
    
    func blockAAAAAA(block:APPBackClosure) {

    }
}

class AudioModel: BaseModel {
    
    let chName = ""
    let createTime = ""
    let enName = ""
    let picUrl = ""
    let tagId = ""
    let tagStatus = 0
    let tagType = 0
    let updateTime = ""
}




