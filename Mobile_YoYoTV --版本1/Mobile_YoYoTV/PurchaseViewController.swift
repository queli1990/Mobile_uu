//
//  ViewController.swift
//  tuxiaobei
//
//  Created by Raecoo Cao on 03/31/16.
//  Copyright © 2016 OTT Team. All rights reserved.
//



import UIKit
import StoreKit

func isPurchased() -> Bool {
    return UserDefaults.standard.bool(forKey: "com.uu.VIP")
}

func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize(width: width, height: 900)
    let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
    return strSize.height
}

func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize(width: 900, height: height)
    let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
    return strSize.width
}

func validateSubscriptionIfNeeded() {
    let validatedAt = UserDefaults.standard.double(forKey: "receipt_validated_at")
    let now = NSDate().timeIntervalSince1970
    if (now - validatedAt < 86400) {
        return
    }
    IAP.validateReceipt("f3a2caf8481e4db9a00f1ded035a034c") { (statusCode, products, receipt) in
        if (products == nil || products!.isEmpty) {
            UserDefaults.standard.set(false, forKey: "com.uu.VIP")
            UserDefaults.standard.synchronize()
            return
        }
        if let expireDate = products!["com.uu.VIP"] {
            if (expireDate.timeIntervalSince1970 < now) {
                print("Subscription expired ...")
                UserDefaults.standard.set(false, forKey: "com.uu.VIP")
                UserDefaults.standard.synchronize()
            }
        }
    }
}

class PurchaseViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    // Mark: Properties
    var btnSubscribe = UIButton(type: UIButtonType.system) as UIButton;
    var btnBack = UIButton(type: UIButtonType.system) as UIButton;
    var btnRestore = UIButton(type: UIButtonType.system) as UIButton;
    var btnPolicy = UIButton(type: UIButtonType.system) as UIButton;
    var btnTerm = UIButton(type: UIButtonType.system) as UIButton;
    
    
    var spinnerOverlay = UIView()
    var actInd = UIActivityIndicatorView()
    
    var viewHasLoaded = false
    var restorePreferred = false
    
    override var preferredFocusedView: UIView? {
        get {
            if (isPurchased()) {
                return self.btnBack
            } else if (restorePreferred) {
                return self.btnRestore
            } else {
                return self.btnSubscribe
            }
        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 227/255.0, green: 131/255.0, blue: 31/255.0, alpha: 1)
        super.viewDidLoad()
        
        IAP.requestProducts(Set<ProductIdentifier>(arrayLiteral: "com.uu.VIP"))
        
        validateSubscriptionIfNeeded()
        
        if(!IAP.canMakePayment()) {
            let alert = UIAlertController(title: "Alert",
                                          message: "Please enable In App Purchase in Settings.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: { () in
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            })
        }
        
        buildButtons()
        viewHasLoaded = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Warning ...")
    }
    
    // MARK: initialize view
    func buildButtons(){
        if (viewHasLoaded) {
            view.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        let screenSize:CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let btnTextSize:CGFloat = 16
        let btnTextFont:String  = "HelveticaNeue" // UltraLight
        let gap:CGFloat = 30;
        let btnWidth:CGFloat    = (screenWidth - 2*gap - 15*2)/3.0;
        let btnHeight:CGFloat   = 40
        
        let img = UIImage(imageLiteralResourceName: "purchase_header")
//        let headerUrl = NSURL(string: "http://api.ottcloud.tv/smarttv/zhongguolan/data/header-light.jpg")
//        let headerData = NSData(contentsOf: headerUrl! as URL)
//        let headerImage = UIImage(data: headerData! as Data)
        let headerImageView = UIImageView(image: img)
        let imgWidth = screenWidth * 1080.0 / 1920.0
        headerImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imgWidth)
        self.view.addSubview(headerImageView)
        
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth-30, height: 0));
        label.text = "        您想以每月9.99美元的价格订阅UUTV VIP吗？此订阅自动续费，购买之后，每月都会自动收费，除非您在当期结束前24小时取消订阅。订阅期长1月，每月收费9.99美元。iTunes 账户续费是在当期结束前24小时内扣费9.99美元。管理您的订阅和自动续费请通过您的账户设置。";
        label.textColor = UIColor.black;
        label.textAlignment = .left
        let font = UIFont(name: btnTextFont, size: 16)
        label.font = font
        let labelHeight = getLabHeigh(labelStr: label.text!, font: font!, width: screenWidth-30)
        label.frame = CGRect(x: 15, y: headerImageView.frame.size.height + 10, width: screenWidth-30, height: labelHeight)
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let policyBtn = UIButton(type: .system)
        policyBtn.frame = CGRect(x: 50, y: label.frame.maxY+10, width: (screenWidth-50*2-30)/2, height: 25)
        policyBtn.setTitle("隐私政策", for: .normal)
        policyBtn.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
        policyBtn.layer.cornerRadius = 8;
        policyBtn.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
        policyBtn.addTarget(self, action: #selector(policyBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(policyBtn)
        
        
        let termBtn = UIButton(type: .system)
        termBtn.frame = CGRect(x: 50+(screenWidth-50*2-30)/2+30, y: policyBtn.frame.origin.y, width: (screenWidth-50*2-30)/2, height: 25)
        termBtn.setTitle("服务协议", for: .normal)
        termBtn.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
        termBtn.layer.cornerRadius = 8;
        termBtn.titleLabel!.font = UIFont(name: btnTextFont, size: btnTextSize)!
        termBtn.addTarget(self, action: #selector(termBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(termBtn)
        
        if (isPurchased()){
            let currentBtnWidth = (screenWidth - 30*2 - 50)/2
            //btn之间间隔50px，距左右边距30px
            let havePurchased = UILabel(frame: CGRect(x: 30, y: policyBtn.frame.maxY + 30, width: currentBtnWidth, height: 30))
            havePurchased.font = UIFont(name: btnTextFont, size: 28)
            havePurchased.text = "恭喜您已订购成功!"
            havePurchased.textColor = UIColor(red: 250/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1)
            havePurchased.textAlignment = .center
            self.view.addSubview(havePurchased)
            
            btnBack.setTitle("返回", for: .normal)
            btnBack.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnBack.layer.cornerRadius = 8
            btnBack.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
            btnBack.frame = CGRect(x:havePurchased.frame.maxX+50, y:policyBtn.frame.maxY+30, width:currentBtnWidth, height:30)
            btnBack.addTarget(self, action: #selector(backClicked(sender:)), for: .primaryActionTriggered)
            self.view.addSubview(btnBack)
        } else {
            let priceLabel:UILabel = UILabel(frame: CGRect(x: 15, y: policyBtn.frame.maxY + 30, width: screenWidth-30, height: 30))
            priceLabel.font = UIFont(name: btnTextFont, size: 28)
            priceLabel.textColor = UIColor(red: 250/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1)
            priceLabel.text = "USD 9.99 / 月"
            priceLabel.textAlignment = .center
            self.view.addSubview(priceLabel)
            
            // restore button
            btnRestore.setTitle("恢复购买", for: .normal)
            btnRestore.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnRestore.layer.cornerRadius = 8
            btnRestore.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
            btnRestore.frame = CGRect(x:15, y:screenHeight-btnHeight-2*gap, width:btnWidth, height:btnHeight)
            btnRestore.addTarget(self, action: #selector(restoreClicked(button:)), for: .primaryActionTriggered)
            self.view.addSubview(btnRestore)
            
            // subscribe button
            btnSubscribe.setTitle("立即订购", for: .normal)
            btnSubscribe.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
            btnSubscribe.layer.cornerRadius = 8
            btnSubscribe.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnSubscribe.frame = CGRect(x:btnRestore.frame.maxX+gap, y:btnRestore.frame.origin.y, width:btnWidth, height:btnHeight)
            btnSubscribe.addTarget(self, action: #selector(subscribeClicked(button:)), for: .primaryActionTriggered)
            self.view.addSubview(btnSubscribe)
            
            // back button
            btnBack.setTitle("返回", for: .normal)
            btnBack.titleLabel!.font =  UIFont(name:  btnTextFont, size: btnTextSize)!
            btnBack.layer.cornerRadius = 8
            btnBack.backgroundColor = UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
            btnBack.frame = CGRect(x:btnSubscribe.frame.maxX+gap, y:btnRestore.frame.origin.y, width:btnWidth, height:btnHeight)
            btnBack.addTarget(self, action: #selector(backClicked(sender:)), for: .primaryActionTriggered)
            self.view.addSubview(btnBack)
        }
    }
    
    func showSpinner() {
        if (self.spinnerOverlay.subviews.isEmpty) {
            // Spinner overlay
            spinnerOverlay = UIView(frame: view.frame)
            spinnerOverlay.backgroundColor = UIColor.black
            spinnerOverlay.alpha = 0.85
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x:0, y:0, width:40, height:40)
            actInd.center = spinnerOverlay.center
            actInd.hidesWhenStopped = true
            actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            spinnerOverlay.addSubview(actInd)
            actInd.startAnimating()
        }
        
        view.addSubview(spinnerOverlay)
    }
    
    func hideSpinner() {
        spinnerOverlay.removeFromSuperview()
    }
    
    func subscribeClicked(button: UIButton!) {
        showSpinner()
        IAP.purchaseProduct("com.uu.VIP", handler: handlePurchase)
    }
    
    func restoreClicked(button: UIButton!) {
        showSpinner()
        IAP.restorePurchases(handleRestore)
    }
    
    func backClicked(sender: UIButton!) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func policyBtnClicked(sender: UIButton!) {
        let vc = PolicyViewController()
        vc.webViewUrl = "http://100uu.tv:8099/AppleTV-Versions/policy.html";
        vc.titleLabelText = "隐私政策";
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func termBtnClicked(sender: UIButton!) {
        let vc = PolicyViewController()
        vc.titleLabelText = "服务协议";
        vc.webViewUrl = "http://100uu.tv:8099/AppleTV-Versions/term.html";
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Mark: In-App Purchase functions
    
    func handlePurchase(productIdentifier: ProductIdentifier?, error: NSError?) {
        if productIdentifier != nil {
            print("Purchase Success")
            provideContentForProductIdentifier(productIdentifier: productIdentifier!)
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } else if error?.code == SKError.paymentCancelled.rawValue {
            print("Purchase Cancelled: \(error?.localizedDescription)")
            buildButtons()
        } else if error?.code == 3532 {
            restorePreferred = true
            buildButtons()
            updateFocusIfNeeded()
        } else {
            //print(error?.code)
            print("Purchase Error: \(error?.localizedDescription)")
        }
        
        hideSpinner()
        
    }
    
    func handleRestore(productIdentifiers: Set<ProductIdentifier>, error: NSError?) {
        if !productIdentifiers.isEmpty {
            print("Restore Success")
            for productIdentifier in productIdentifiers {
                provideContentForProductIdentifier(productIdentifier: productIdentifier)
            }
            let alertController = UIAlertController(title: "恢复购买", message: "购买状态已恢复", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if error?.code == SKError.unknown.rawValue {
            // NOTE: if no product ever purchased, will return this error.
            let alertController = UIAlertController(title: "恢复购买", message: "未找到购买记录, 请确认已登录的 Apple ID 是否正确", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if error?.code == SKError.paymentCancelled.rawValue {
            print("Restore Cancelled: \(error?.localizedDescription)")
        } else {
            print("Restore Error: \(error?.localizedDescription)")
            
        }
        hideSpinner()
    }
    
    private func provideContentForProductIdentifier(productIdentifier: String) {
        userDefaults.set(true, forKey: productIdentifier)
        userDefaults.synchronize()
        buildButtons()
    }
    
    
}

