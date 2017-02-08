//
//  MyAlertController.swift
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

enum MyAlertControllerType {
    case singleButton(String)
    case doubleButton(String, String)
}

enum MyAlertControllerAction {
    case cancel
    case ok
}

class MyAlertController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var haikeiView: UIView!
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet var singleButtonView: UIView!
    @IBOutlet var doubleButtonView: UIView!
    
    @IBOutlet weak var singleViewAcceptButton: UIButton!
    @IBOutlet weak var doubleViewCancelButton: UIButton!
    @IBOutlet weak var doubleViewAcceptButton: UIButton!
    
    //var titleText: String = ""
    var messageText: String = ""
    var buttonType = MyAlertControllerType.singleButton("")
    
    typealias AlertAction = (_ action: MyAlertControllerAction)->()
    var handler: AlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleViewAcceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        doubleViewAcceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        doubleViewCancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        //titleLabel.text = titleText
        messageLabel.text = messageText
        
        animationContentView(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentView.layer.cornerRadius = 8
        
        messageLabel.sizeToFit()
        
        /*
        switch buttonType {
        case .singleButton :
            print("SSSS")
            
            
            //contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: messageLabel.frame.height+singleButtonView.frame.height+50)
            //singleButtonView.frame.origin = CGPoint(x: 0, y: contentView.frame.height-singleButtonView.frame.height-(singleButtonView.frame.height/3))
        case .doubleButton :
            print("FFFF")
            
            //contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: messageLabel.frame.height+doubleButtonView.frame.height+80)
           // doubleButtonView.frame.origin = CGPoint(x: 0, y: contentView.frame.height-doubleButtonView.frame.height-(doubleButtonView.frame.height/3))

        }*/
        print("contentView.frame.height = \(contentView.frame.height) singleButtonView.frame.origin = \(singleButtonView.frame.origin.y) messageLabel.frame.height = \(messageLabel.frame.height) contentView.frame.origin.x = \(contentView.frame.origin.x) contentView.frame.origin.y = \(contentView.frame.origin.y)")
        
        
        switch buttonType {
        case let .singleButton(title) :
            addSingleButton(title)
            
        case let .doubleButton(cancel, accept) :
            addDoubleButton(cancel, acceptTitle: accept)
        }

        
        animationContentView(false)
    }
    
    fileprivate func animationContentView(_ hidden: Bool, completed: (()->())? = nil) {
        let alpha: CGFloat
        let alpha2: CGFloat
        if hidden { alpha = 0
                    alpha2 = 0
        }else { alpha = 1
               alpha2 = 0.5
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = alpha
            self.haikeiView.alpha = alpha2
        }, completion: { _ in
            completed?()
        }) 
    }
    
    
    fileprivate func addSingleButton(_ title: String) {
        singleButtonView.frame.origin = CGPoint(x: 0, y: (messageLabel.frame.height+70)-(singleButtonView.frame.height+10))
        contentView.addSubview(singleButtonView)
        
        singleViewAcceptButton.layer.cornerRadius = 3
        
        singleViewAcceptButton.setTitle(title, for: UIControlState())
    }
    
    fileprivate func addDoubleButton(_ cancelTitle: String, acceptTitle: String) {
        //doubleButtonView.frame.origin = CGPoint(x: 0, y: (messageLabel.frame.height*1.4))
        doubleButtonView.frame.origin = CGPoint(x: 0, y: (messageLabel.frame.height+70)-(doubleButtonView.frame.height+10))
        contentView.addSubview(doubleButtonView)
        
        doubleViewAcceptButton.layer.cornerRadius = 3
        doubleViewCancelButton.layer.cornerRadius = 3

        doubleViewCancelButton.setTitle(cancelTitle, for: UIControlState())
        doubleViewAcceptButton.setTitle(acceptTitle, for: UIControlState())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/**
 *  Button actions ---------------------
 */
extension MyAlertController {
    func acceptButtonTapped() {
        animationContentView(true) {
            self.handler?(.ok)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func cancelButtonTapped() {
        animationContentView(true) {
            self.handler?(.cancel)
            self.dismiss(animated: false, completion: nil)
        }
    }
}


/**
 *  Show ---------------------
 */
extension MyAlertController {
    class func show(presentintViewController vc: UIViewController, title: String, message: String, buttonTitle: String, handler: AlertAction?) {
        //let alert: MyAlertController = UIStoryboard(name: "MyAlertController", bundle: nil).instantiateInitialViewController() as! MyAlertController
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MyAlertController", bundle: Bundle.main)
        // Modal1ViewController取得 ※ ModalViewControllerは自作のViewController
        let alert: MyAlertController = storyboard.instantiateInitialViewController() as! MyAlertController

        //alert.titleText = title
        alert.messageText = message
        alert.buttonType = .singleButton(buttonTitle)
        alert.handler = handler
        
        //すでにポップアップが表示されている場合は閉じる
        var tc = UIApplication.shared.keyWindow?.rootViewController;
        while ((tc!.presentedViewController) != nil) {
            tc = tc!.presentedViewController;
            if tc is MyAlertController {
                tc!.dismiss(animated: false, completion: nil)
            }
        }

        vc.present(alert, animated: false, completion: nil)

    }
    
    class func show(presentintViewController vc: UIViewController, title: String, message: String, cancelTitle: String, acceptTitle: String, handler: AlertAction?) {
        guard let alert = UIStoryboard(name: "MyAlertController", bundle: nil).instantiateInitialViewController()                          
            as? MyAlertController else { return }
        //alert.titleText = title
        alert.messageText = message
        alert.buttonType = .doubleButton(cancelTitle, acceptTitle)
        alert.handler = handler

        //すでにポップアップが表示されている場合は閉じる
        var tc = UIApplication.shared.keyWindow?.rootViewController;
        while ((tc!.presentedViewController) != nil) {
            tc = tc!.presentedViewController;
            if tc is MyAlertController {
                tc!.dismiss(animated: false, completion: nil)
            }
        }
        
        vc.present(alert, animated: false, completion: nil)
    }
}
