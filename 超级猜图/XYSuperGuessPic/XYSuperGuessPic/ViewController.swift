//
//  代码地址：https://github.com/xiaoyouPrince/SomeUIDemos
//  Blog地址：http://xiaoyouPrince.com/
//
//  ViewController.swift
//  XYSuperGuessPic
//
//  Created by 渠晓友 on 2018/3/17.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    /// 属性懒加载
    fileprivate lazy var questions : [XYQuestion] = { [unowned self] in
        
        var questions = [XYQuestion]()
        
        let path : String = Bundle.main.path(forResource: "questions", ofType: "plist")!
        let data = NSArray(contentsOfFile: path)!
        for dict in data {
            let question = XYQuestion(dict: dict as! [String : AnyObject])
            questions.append(question)
        }
        return questions
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// 1. load data
        let aaa = self.questions
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




















