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


/** life circle and init */
class ViewController: UIViewController {
    
    /** 存放正确答案按钮的view */
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var optionView: UIView!
    
    /** 序号 */
    @IBOutlet weak var noLabel: UILabel!
    /** 标题 */
    @IBOutlet weak var titleLabel: UILabel!
    /** 头像(图标) */
    @IBOutlet weak var iconBtn: UIButton!
    var defaultIconRect : CGRect?
    
    /** 下一题按钮 */
    @IBOutlet weak var nextQuestionBtn: UIButton!
    /** 分数按钮 */
    @IBOutlet weak var scoreBtn: UIButton!
    /** 遮盖 */
    fileprivate lazy var cover : UIButton = { [unowned self] in
        
        let cover = UIButton()
        cover.frame = self.view.bounds
        cover.alpha = 0.0
        cover.backgroundColor = UIColor.black
        cover.addTarget(self, action: #selector(smallImage), for: .touchUpInside)
        return cover
    }()
    
    /** 当前是第几题(当前题目的序号) */
    var index : Int = 0

    /// 属性懒加载
    /** 所有的题目 */
    fileprivate lazy var questions : [XYQuestion] = { [unowned self] in
        
        /// Swift 4.0 就是有一个问题，读不到数据，命名代码是正确的 3.2 可以正常运行，4.0直接读不到数据！太™坑了！
        
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
        
        /// 这里的frame不准确
        /// defaultIconRect = self.iconBtn.frame
        
        /// 1. 开始第一题
        index = -1
        nextQuestion()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 这里的frame才准确
        defaultIconRect = self.iconBtn.frame
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/** 答题的一些业务逻辑 */
extension ViewController{
    
    /// 下一题
    @objc func nextQuestion() -> Void{
        
        // 1.增加索引
        self.index += 1
        
        // 2.取出模型
        let question = self.questions[self.index];
        
        // 3.设置控件的数据
        settingData(question)
        
        // 4.添加正确答案
        settingAnswerBtn(question)
        
        // 5.添加待选项
        settingOptionBtn(question)
        
    }
    
    
    /** 设置控件的数据 */
    func settingData(_ question : XYQuestion) -> Void {
        
        // 1. 标题序号
        self.noLabel.text = String.localizedStringWithFormat("%d / %d", self.index , self.questions.count)
        
        // 2. 问题title
        self.titleLabel.text = question.title
        
        // 3. 问题图片
        self.iconBtn.setImage(UIImage(named : question.icon!), for: .normal)
        
        // 4. 下一题按钮状态
        self.nextQuestionBtn.isEnabled = self.index != self.questions.count - 1
    }
    
    /** 添加正确答案 */
    func settingAnswerBtn(_ question : XYQuestion) -> Void {
        
        // 0.先移除上一题的答案
        for btn in self.answerView.subviews {
            btn.removeFromSuperview()
        }
        
        // 1.加载本题数据，根据answer长度，创建对应数量的btn
        let count : Int = (question.answer?.count)!
        
        
        
        for i in 0..<count {
            
            
            let margin : CGFloat = 20.0
            let WH : CGFloat = CGFloat(35)
            var X : CGFloat = CGFloat(CGFloat(i) * (WH + margin))
            let Y : CGFloat = 0

            
            var centerIndex = 0
            if count % 2 == 1 { // 奇数，正中间
                centerIndex = count / 2
                
                let offset = i - centerIndex
    
                X = (self.answerView.center.x - WH / 2) + (CGFloat)(offset) * (WH + margin)
            }
            
            if count % 2 == 0 { // 偶数，中间偏右
                centerIndex = count / 2
                
                let offset = i - centerIndex
                
                X = (self.answerView.center.x + margin / 2) + (CGFloat)(offset) * (WH + margin)
            }
        
            let btn : UIButton = UIButton(frame: CGRect(x: X, y: Y, width: WH, height: WH))
            btn.addTarget(self, action: #selector(answerBtnClick), for: .touchUpInside)
            btn.setImage(#imageLiteral(resourceName: "btn_answer_highlighted"), for: .highlighted)
            btn.setImage(#imageLiteral(resourceName: "btn_answer"), for: .normal)
            self.answerView.addSubview(btn)
            
            
        }
        
        
        
        //
    }
    
    
    @objc func answerBtnClick(){
        
    }
    
    
    /** 添加待选项 */
    func settingOptionBtn(_ question : XYQuestion) -> Void {
        
    }
    
}


/** 所有的点击操作 */
extension ViewController {
    
    @IBAction func tip(_ sender: UIButton) {
    }
    @IBAction func bigImage(_ sender: UIButton) {
        
        /// 这里是懒加载，直接会加载成功
        self.view.addSubview(self.cover)
        
        /// 更换头像和阴影位置
        self.view.bringSubview(toFront: self.iconBtn)
        
        /// 动画放大图片
//        self.iconBtn.frame = self.defaultIconRect!
//        UIView.animate(withDuration: 0.25) {
//
////            self.cover.alpha = 0.7
//
//            self.iconBtn.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.width)
//            self.iconBtn.center = self.view.center
//        }
        
        
        /// 这个Swift动画很诡异---，改变cover的透明度，必须在这里并且要先赋值原来frame才能正确展示。。这是为什么
        UIView.animate(withDuration: 0.1, animations: {
//            self.iconBtn.frame = self.defaultIconRect!
            self.cover.alpha = 0.7
        }) { (isComplete) in

            UIView.animate(withDuration: 0.25, animations: {

                self.iconBtn.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.width)
                self.iconBtn.center = self.view.center
            })
        }
    }
    @IBAction func help(_ sender: UIButton) {
    }
    @IBAction func nextQuestion(_ sender: UIButton) {
        
        nextQuestion()
    }
    @IBAction func iconClick(_ sender: UIButton) {
        
        if self.iconBtn.frame == self.defaultIconRect {
            bigImage(sender)
        }else{
            smallImage()
        }
    }
    
    @objc func smallImage() -> Void {
        print("smallImage -- ")
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.iconBtn.frame = self.defaultIconRect!
            
            self.cover.alpha = 0.0
            
        }) { (isComplete) in
            self.cover.removeFromSuperview()
        }
        
    }
    
}




















