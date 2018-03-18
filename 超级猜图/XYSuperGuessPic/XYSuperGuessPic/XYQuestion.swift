//  代码地址：https://github.com/xiaoyouPrince/SomeUIDemos
//  Blog地址：http://xiaoyouPrince.com/
//
//  XYQuestion.swift
//  XYSuperGuessPic
//
//  Created by 渠晓友 on 2018/3/17.
//
//  Copyright © 2018年 xiayouPrince. All rights reserved.
//

import UIKit

class XYQuestion: NSObject {
    
    
    var answer : String?    ///< 答案
    var icon   : String?    ///< 对应图片
    var title  : String?    ///< 对应标题
    var options: Array<String>?     ///< 带选项
    
    
    /// 重写父类初始化方法
    override init() {
        super.init()
    }
    
    /// 自定义初始化方法
    init( dict : [String : AnyObject]) {
        super.init()
        
        /// KVC 赋值
        setValuesForKeys(dict)
        
    }
    
    /// KVC for undefined key
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    

}
