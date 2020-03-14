//
//  APPNetTool.swift
//  APPBase
//
//  Created by 峰 on 2020/3/14.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

//MARK: ************************* Alamofire用法 *************************
//官方文档：https://github.com/Alamofire/Alamofire
//https://www.cnblogs.com/jukaiit/p/9283498.html


protocol BlogPost {
    var title: String { get }
    var author: String { get }
}

struct Tutorial: BlogPost {
    let title: String
    let author: String
}

func createBlogPost(title: String, author: String) -> BlogPost {
    guard !title.isEmpty && !author.isEmpty else {
        fatalError("No title and/or author assigned!")
    }
    return Tutorial(title: title, author: author)
}

let swift4Tutorial = createBlogPost(title: "What's new in Swift 4.2?",
                                    author: "Cosmin Pupăză")
let swift5Tutorial = createBlogPost(title: "What's new in Swift 5?",
                                    author: "Cosmin Pupăză")
