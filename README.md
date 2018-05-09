# SomeUIDemos
一些iOS小Demo，这里主要是UI层面的Demo，几个完整示例。基本基于 OC / Swift 双版本实现

当前 Swift 版本为 4.0 ,在我使用 Swift 4.0 写代码的时候依旧出现了很多不解之谜，浪费了很多时间也让我对 Swift 的体验印象很差！(当然有我自己的原因：对Swift 并不足够熟悉，对一些代码习惯不熟悉等) 不论如何我还是坚持写了几个小程序，并记录了下来我在使用 Swift 开发中遇到的“问题”，与有缘人共勉！

- **Swift 4.0 读取和解析 Plist 文件，读不到数据！同样的代码、逻辑正确，在 Swift 3.2 版本正常，4.0 版本读不到数据。太™坑了！**

``` Swift

     fileprivate lazy var questions : [XYQuestion] = { [unowned self] in
        
        /// Swift 4.0 打印读取到的数据为 nil
        /// Swift 3.2 打印读取到的数据为 正常
        
        var questions = [XYQuestion]()
        let path : String = Bundle.main.path(forResource: "questions", ofType: "plist")!
        let data = NSArray(contentsOfFile: path)!
        for dict in data {
            let question = XYQuestion(dict: dict as! [String : AnyObject])
            questions.append(question)
        }
        return questions
    }()
    
```

- **IB文件中使用AutoLayout创建的控件，在代码中修改frame无效.要么IB文件中取消使用AutoLayout，要么代码中使用AutoLayout修改Contraint**
``` objc        
     
     /// OC 中正确写法
     [UIView animateWithDuration:0.25 animations:^{
        
        //cover 透明度
        self.cover.alpha = 0.7;
        
        //icon大小修改
        self.iconWidthCons.constant = ScreenW;
        self.iconCenterYCons.constant = 0;
        
    }];
```

``` Swift        
        
        /// 这个Swift动画很诡异---，如下方式能修改IB文件中通过AutoLayout创建的控件frame，也仅限于两个动画嵌套，OC中不行<Xcode 版本 9>
        UIView.animate(withDuration: 0.1, animations: {
            self.iconBtn.frame = self.defaultIconRect!   
            self.cover.alpha = 0.7
        }) { (isComplete) in

            UIView.animate(withDuration: 0.25, animations: {

                self.iconBtn.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.width)
                self.iconBtn.center = self.view.center
            })
        }
```

## 1. 超级猜图

## 2. 通信录使用

     ![通讯录传送门](通信录使用/README.md)



