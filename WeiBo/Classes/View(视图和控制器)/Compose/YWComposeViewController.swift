//
//  YWComposeViewController.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/6.
//  Copyright © 2016年 yao wei. All rights reserved.
//  撰写微博控制器

import UIKit
import SVProgressHUD
class YWComposeViewController: UIViewController {
    @IBOutlet weak var textView: YWComposeTextView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    ///发布按钮
    @IBOutlet var sendBtn: UIButton!
    
    /// 标题视图
    @IBOutlet var titleLab: UILabel!
    
    /// 工具栏底部约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    /// 表情输入视图
    lazy var emoticonView: YWEmoticonInputView = YWEmoticonInputView.inputView { [weak self] (emoticon) in
        self?.textView.insterEmoticon(em: emoticon)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        steupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //关闭键盘
        textView.resignFirstResponder()
    }
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func keyBoardChanged(noti: Notification){
        //目标rect
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duartion = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
                return
        }
        //可以设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y
        toolBarBottomCons.constant = offset
        UIView.animate(withDuration: duartion) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func backAction() {
        dismiss(animated: true, completion: nil)
    }
    /// 发布微博
    @IBAction func sendAction(_ sender: AnyObject) {
        
        
        //获得发送微博的纯文本字符串
        let text = textView.emoticonText
        ///测试发送图片
        let image = UIImage(named: "icon_small_kangaroo_loading_1")
        YWNetworkManager.shared.postStatus(text: text, image:nil) { (result,isSuccess) in
            let messaage = isSuccess ?"发布成功":"网络不给力"
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: messaage)
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    //恢复样式
                    SVProgressHUD.setDefaultStyle(.light)
                    self.backAction()
                })
            }
        }
        
    }
    
    //切换表情键盘
    @objc fileprivate func emoticonKeyboard() {
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        //刷新键盘
        textView.reloadInputViews()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

 extension YWComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}


fileprivate extension YWComposeViewController{
    func steupUI() {
        view.backgroundColor = UIColor.white;
        steupNavigationBar()
        steupToolbar()
    }
    
    /// 设置工具栏
    func steupToolbar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var itemArr = [UIBarButtonItem]()
        //遍历数组
        for item in itemSettings {
            guard let imageName = item["imageName"] else {
                return
            }
            
            let image = UIImage(named: imageName);
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton();
            btn.setImage(image, for:.normal);
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            //判断 actionName
            if let actionName = item["actionName"] {
                //添加监听方法
                btn.addTarget(self, action: #selector(emoticonKeyboard), for: .touchUpInside)
            }
            
            
            //追加按钮
            itemArr.append(UIBarButtonItem(customView: btn))
            
            //追加弹簧
            itemArr.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        //删除末尾弹簧
        itemArr.removeLast()
        
        toolBar.items = itemArr
        
    }
    func steupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(backAction))
        //设置发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        sendBtn.isEnabled = false
        
        navigationItem.titleView = titleLab
    }
}
