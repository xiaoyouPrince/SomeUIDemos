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
    
    /// Mark 全局变量
    fileprivate let ScreenW = UIScreen.main.bounds.size.width
    fileprivate let ScreenH = UIScreen.main.bounds.size.height
    
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
        
        // 1.1 如果已经是最后一题
        if self.index >= self.questions.count {
            
            self.showTips("真棒！你已经通关\n5秒后重新开始\n新的题目敬请期待...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
                self.index = -1
                self.nextQuestion()
            }
            
            return
        }
        
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
        
        // 1.答案按钮的列数,根据answer长度，创建对应数量的btn
        let column = (question.answer?.count)!
        
        let margin = CGFloat(20)  // 两个答案按钮间距
        let WH : CGFloat = CGFloat(35)  // 按钮WH
        let Y : CGFloat = 0
        
        // 答案左边距
        let answerW = (ScreenW - ( CGFloat(column) * WH + CGFloat(column - 1) * margin))
        let leftMargin = answerW * 0.5
        
        for i in 0..<column {
            
            let X = leftMargin + CGFloat(i) * (WH + margin)
            
            let btn : UIButton = UIButton(frame: CGRect(x: X, y: Y, width: WH, height: WH))
            btn.addTarget(self, action: #selector(answerBtnClick), for: .touchUpInside)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setBackgroundImage(UIImage(named: "btn_answer"), for: .normal)
            btn.setBackgroundImage(UIImage(named: "btn_answer_highlighted"), for: .highlighted)
//            btn.setImage(#imageLiteral(resourceName: "btn_answer_highlighted"), for: .highlighted)
//            btn.setImage(#imageLiteral(resourceName: "btn_answer"), for: .normal)
            self.answerView.addSubview(btn)
            
        }
        
    }
    
    /** 答案按钮点击事件 */
    @objc func answerBtnClick(_ sender : UIButton){
        
        // 如果对应的Btn有文字，设置文字为“”，
        // 复位原来被隐藏的optionBtn,
        // 设置optionBtns可用
        // 同时所有文字颜色变black(answers已经不满)
       
        let title = sender.title(for: .normal)

        if title != nil {
            
            // 1. 设置对应按钮答案文字为nil
            sender.setTitle(nil, for: .normal)
            
            // 2. 遍历optionBtns,恢复隐藏的Btn
            for subview in self.optionView.subviews {
                // 2.1 恢复btn可用
                subview.isUserInteractionEnabled = true
            }
            
            for subview in self.optionView.subviews {
                // 2.2 显示原来被隐藏选中的答案
                let optionBtn : UIButton = subview as! UIButton
                
                let ansTitle = title! as NSString
                let optTitle = optionBtn.title(for: .normal)
                if ansTitle.isEqual(to: optTitle!) && optionBtn.isHidden {
                    optionBtn.isHidden = false
                    break
                }
            }
            
            
            // 3. 遍历answerBtns,设置对应的titleColor
            for subview in self.answerView.subviews {
                
                // 3.1 titleColor
                let answerBtn : UIButton = subview as! UIButton
                answerBtn.setTitleColor(UIColor.black, for: .normal)
            }
            
        }
        
        print("answerBtnClick")
    }
    
    
    /** 添加待选项 */
    func settingOptionBtn(_ question : XYQuestion) -> Void {
        
        // 1.先移除上一题的可选按钮
        for view in self.optionView.subviews {
            view.removeFromSuperview()
        }
        
        
        let count = question.options?.count
        let colum = 7
        
        let margin = CGFloat(20)  // 两个答案按钮间距
        let WH : CGFloat = CGFloat(35)  // 按钮WH
        
        let doubleLeftMargin = ScreenW - CGFloat(colum) * WH  - CGFloat(colum - 1) * margin
        let leftMargin = doubleLeftMargin * 0.5
        
        for i in 0..<count! {
            
            let X = leftMargin + CGFloat(i % colum) * (WH + margin)
            let Y = 10 + CGFloat(i / colum) * (WH + margin)
            
            let optionBtn = UIButton(type: .system)
            optionBtn.setBackgroundImage(UIImage(named: "btn_image_normal"), for: .normal)
            optionBtn.setBackgroundImage(UIImage(named: "btn_answer_highlighted"), for: .highlighted)
//            optionBtn.setImage(UIImage(named: "btn_image_normal"), for: .normal)
//            optionBtn.setImage(UIImage(named: "btn_answer_highlighted"), for: .highlighted)
            let currentTitle = question.options![i]
            optionBtn.setTitle(currentTitle, for: .normal)
            
            optionBtn.setTitleColor(UIColor.black, for: .normal)
            optionBtn.setTitleColor(UIColor.black, for: .highlighted)
            optionBtn.frame = CGRect(x: X, y: Y, width: WH, height: WH)
            optionBtn.addTarget(self, action: #selector(optionBtnClick), for: .touchUpInside)
            self.optionView.addSubview(optionBtn)
            
        }
    }
    
    
    /// optionBtn 点击事件
    @objc func optionBtnClick(_ optionBtn : UIButton){
        
        // 1. 隐藏被点击的按钮，把对应文字放到answerBtn上
        // 2. 保存已经选择的答案，匹配正确答案，如果答案正确，文字变红，进入下一题。否则文字变蓝，所有optionBtn不可用
        
        // 1. 被选optionBtn消失
        optionBtn.isHidden = true
        
        // 2. 被选按钮文字放到答案按钮上
        for subView in self.answerView.subviews {
            
            let answerBtn = subView as! UIButton
            
            let answerTitle = answerBtn.title(for: .normal)

            if answerTitle == nil  {

                answerBtn.setTitle(optionBtn.title(for: .normal), for: .normal)
                
                break
            }
        }
        
        // 3. 检测答案是否已经填满
        var full = true
        let tempAnswerTitle = NSMutableString()
        for subview in self.answerView.subviews {
            let answerBtn = subview as! UIButton
            
            let answerTitle = answerBtn.title(for: .normal)
            if answerTitle == nil
            {
                full = false
            }
            
            // 拼接选中的答案
            if answerTitle != nil
            {
                tempAnswerTitle.append(answerTitle! as String)
            }
            
        }
        
        // 4.答案满了
        if full {
            
            // 判断答案是否正确，进行下一题
            let question = self.questions[self.index]
            
            if tempAnswerTitle.isEqual(to: question.answer!)  { // 4.1 答案正确，显示蓝色
                
                // 4.1.0 答案颜色变blue
                for subview in self.answerView.subviews {
                    let answerBtn = subview as! UIButton
                    answerBtn.setTitleColor(UIColor.blue, for: .normal)
                }
                
                // 4.1.1 加分
                addScore(800)
                
                // 4.1.2 跳转到下一题
                self.perform(#selector(self.nextQuestion), with: nil, afterDelay: 0.5)
                
            }else
            {   // 4.2 所选答案不正确，显示红色
                for subview in self.answerView.subviews {
                    let answerBtn = subview as! UIButton
                    answerBtn.setTitleColor(UIColor.red, for: .normal)
                }
            }
        }

        // 5.所有的optionBtns 设置是否可以点击
        if full {
            for subview in self.optionView.subviews {
                subview.isUserInteractionEnabled = false
            }
        }else{
            for subview in self.optionView.subviews {
                subview.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
    /// 加分
    ///
    /// - Parameter score: 分数
    func addScore(_ score : Int32) {
        
        // 获得分数按钮的分数值，修改对应的分数
        
        let curScoreStr = self.scoreBtn.title(for: .normal)! as NSString
        let curScore = curScoreStr.intValue + score
        self.scoreBtn.setTitle("\(curScore)", for: .normal)
        
        print("加分 : \(score)")
    }
    
}




/** 所有的点击操作 */
extension ViewController {
    
    @IBAction func tip(_ sender: UIButton) {
        
        // 0. 查看当前分数够不够
        // 1. 用户是否选择了答案
        // 1.1 没有选答案 --> 提示第一个答案
        // 1.2.选择了答案 --> 检查答案正确性，从第一个检查到不对的字提示
        
        let curScore = self.scoreBtn.title(for: .normal)! as NSString
        if curScore.intValue < 800 {
            self.showTips("分数小于 800 \n 无法进行提示")
            return
        }
        
        // 禁用所有btn, 1秒后可用，防止提示时间内用户点击出现bug
        self.view.isUserInteractionEnabled = false
        DispatchAfter(after: 1) {
            self.view.isUserInteractionEnabled = true
        }
        
        
        let question = self.questions[index]
        let answer = question.answer! as NSString
        
        let userAnswer = NSMutableString()
        for subview in self.answerView.subviews {
            let answerBtn = subview as! UIButton
            
            guard let btnTitle = answerBtn.title(for: .normal) else {break}
            userAnswer.append(btnTitle)
        }
        
        // 若果用户没选择答案
        if userAnswer.length == 0 {
            let answer1 = answer.substring(with: NSMakeRange(0, 1))
            
            // 点击第一个答案对应的按钮
            for subview in self.optionView.subviews {
                let optionBtn = subview as! UIButton
                
                if optionBtn.title(for: .normal)!.elementsEqual(answer1) && optionBtn.isHidden == false {
                    
                    // 给个提示动画，按钮晃一晃
                    optionBtn.layer.removeAllAnimations()
                    let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                    animation.values = [ -0.16 * .pi , 0 , 0.16 * .pi , 0]
                    animation.duration = 0.2
                    animation.repeatCount = 3
                    optionBtn.layer.add(animation, forKey: "rotation")
                    
                    DispatchAfter(after: 0.6) {
                        self.optionBtnClick(optionBtn)
                        
                        // 减分
                        self.addScore(-800)
                    }
                    
                    break
                }
            }
            
            
        }else{ // 用户已经选择了答案,直接遍历并替换当前错误位的答案
            
            for index in 0..<answer.length {
                
                
                if index >= userAnswer.length {
                    // 超出用户选择的答案长度,直接提示下一个答案文字
                
                    let nextAnswer = answer.substring(with: NSMakeRange(index, 1))
                    
                    // 2. 遍历候选按钮，选中该按钮（按钮可见）
                    for subview in self.optionView.subviews {
                        let optionBtn = subview as! UIButton
                        let optionTitle = optionBtn.title(for: .normal)! as NSString
                        
                        if optionTitle.isEqual(to: nextAnswer) && optionBtn.isHidden == false                            {
                            
                            
                            // 给个提示动画，按钮晃一晃
                            optionBtn.layer.removeAllAnimations()
                            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                            animation.values = [ -0.16 * .pi , 0 , 0.16 * .pi , 0]
                            animation.duration = 0.2
                            animation.repeatCount = 3
                            optionBtn.layer.add(animation, forKey: "rotation")
                            
                            DispatchAfter(after: 0.6) {
                                self.optionBtnClick(optionBtn)
                                
                                // 减分
                                self.addScore(-800)
                            }
                        
                            return
                        }
                        
                    }
                    
                    
                }else{
                    // 用户答案范围长度内
                    
                    let userAnswerWord = userAnswer.substring(with: NSMakeRange(index, 1))
                    let answerWord = answer.substring(with: NSMakeRange(index, 1))

                    if userAnswerWord.compare(answerWord) == ComparisonResult.orderedSame {
                        print("-----same")
                    }else{
                        print("-----不一样，需要替换")
                        
                        // 1. 答案中按钮点击返回待选区
                        let answerBtn = self.answerView.subviews[index] as! UIButton
                        self.answerBtnClick(answerBtn)
                        // 2. 遍历候选按钮，选中该按钮（按钮可见）
                        for subview in self.optionView.subviews {
                            let optionBtn = subview as! UIButton
                            let optionTitle = optionBtn.title(for: .normal)! as NSString
                            
                            if optionTitle.isEqual(to: answerWord) && optionBtn.isHidden == false                            {
                                
                                // 给个提示动画，按钮晃一晃
                                optionBtn.layer.removeAllAnimations()
                                let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                                animation.values = [ -0.16 * .pi , 0 , 0.16 * .pi , 0]
                                animation.duration = 0.2
                                animation.repeatCount = 3
                                optionBtn.layer.add(animation, forKey: "rotation")
                                
                                DispatchAfter(after: 0.6) {
                                    self.optionBtnClick(optionBtn)
                                    
                                    // 减分
                                    self.addScore(-800)
                                }
                                
                                return
                            }
    
                        }
                        
                    }
                    
                }

            }
        }
        
        // 用户选择了答案，未选满中间不会了，求助提示 -->
        // 1.验证所选部分是否真确，
        //   正确直接提示后边一个答案
        //   不正确遍历所有部分,将第一个不正确的字符进行替换
        
        // 2.用户选满了答案，但是不对，需要求助
        //   遍历所有部分,将第一个不正确的字符进行替换
        
        
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
        
        // 这个是提示功能，涉及到场外求助和一些其他方式，暂时不做
        
        let alert = UIAlertController(title: "提示", message: "暂时没有求助功能", preferredStyle:.alert)
        let actionKnow = UIAlertAction(title: "知道了", style: .cancel) { (alert) in
            print("已经提示")
        }
        alert.addAction(actionKnow)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func nextQuestionBtnClick(_ sender: UIButton) {
        
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
    
    func showTips(_ tip : String) -> () {
        
        let title = tip as NSString
        let size = title.boundingRect(with: CGSize(width: ScreenW - 100 , height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: nil, context: nil)
        
        let label = UILabel()
        label.text = tip
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: 0, width: size.width + 100, height: size.height + 80)
        label.center = self.view.center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        UIApplication.shared.keyWindow?.addSubview(label)
        self.DispatchAfter(after: 4.5, handler: {
            UIView.animate(withDuration: 0.5, animations: {
                label.alpha = 0.0
            }, completion: { (completed) in
                label.removeFromSuperview()
            })
            
        })
        
        
//        let alert = UIAlertController(title: "提示", message: tip, preferredStyle:.alert)
////        let actionKnow = UIAlertAction(title: "知道了", style: .cancel) { (alert) in
////            print("已经提示")
////        }
////        alert.addAction(actionKnow)
//        self.present(alert, animated: true) {
//            self.DispatchAfter(after: 3, handler: {
//                UIView.animate(withDuration: 2.0, animations: {
//                    alert.view.alpha = 0.0
//                }, completion: { (completed) in
//                    alert.dismiss(animated: true, completion: nil)
//                })
//
//            })
//        }

    }
    
    
    /// GCD延时操作
    ///   - after: 延迟的时间
    ///   - handler: 事件
    public func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }

}




















