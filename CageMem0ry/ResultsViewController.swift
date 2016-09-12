//
//  ResultsViewController.swift
//  CageMem0ry
//
//  Created by sky on 9/12/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import UIKit
import YNLib

class ResultsViewController: UIViewController {
    
    var type = ResultType.Success
    var time = 0

    var inAnimationDuration = 0.3
    var outAnimationDuration = 0.2
    private var first = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .CrossDissolve
        self.modalPresentationStyle = .OverFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        if first {
            self.first = false
            self.view.userInteractionEnabled = false
            self.view.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(self.inAnimationDuration, animations: { () -> Void in
                self.view.backgroundColor = UIColor(hexString: "#64000000")
                }, completion: { _ in
                    self.view.userInteractionEnabled = true
            })
            self.prepareResultsView()
        }
    }
    
    func prepareResultsView() {
        let alertView = UIView()
        let banner = UIImageView()
        let timeLabel = UILabel()
        let successDetailLabel = UILabel()
        let failedDetailLabel = UILabel()
        let backButton = UIButton()
        
        alertView.backgroundColor = UIColor.whiteColor()
        timeLabel.textAlignment = .Center
        timeLabel.font = UIFont.boldSystemFontOfSize(24)
        successDetailLabel.textAlignment = .Center
        successDetailLabel.numberOfLines = 0
        successDetailLabel.font = UIFont.boldSystemFontOfSize(32)
        failedDetailLabel.textAlignment = .Center
        failedDetailLabel.font = UIFont.boldSystemFontOfSize(32)
        failedDetailLabel.text = "渗透失败，请再接再厉"
        backButton.setBackgroundImage(UIImage(named: "Back"), forState: .Normal)
        
        if self.type == .Success {
            failedDetailLabel.hidden = true
            banner.image = UIImage(named: "SuccessBanner")
            timeLabel.text = "花费时间\(self.time)秒"
            successDetailLabel.text = "恭喜你获得称号\n［\(self.getGift())］\n及精美礼品一份"
        } else {
            banner.image = UIImage(named: "FailedBanner")
            timeLabel.hidden = true
            successDetailLabel.hidden = true
        }

        alertView.addSubview(banner)
        alertView.addSubview(timeLabel)
        alertView.addSubview(successDetailLabel)
        alertView.addSubview(failedDetailLabel)
        alertView.addSubview(backButton)
        self.view.addSubview(alertView)
        
        alertView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).inset(218)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(480)
        }
        banner.snp_makeConstraints { (make) in
            make.top.equalTo(alertView).inset(29)
            make.left.right.equalTo(alertView).inset(-46)
            make.height.equalTo(123)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(alertView)
            make.height.equalTo(24)
            make.top.equalTo(banner.snp_bottom).inset(-7)
        }
        successDetailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(banner.snp_bottom).inset(-45)
            make.height.equalTo(135)
            make.left.right.equalTo(alertView)
        }
        failedDetailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(banner.snp_bottom).inset(-80)
            make.height.equalTo(32)
            make.left.right.equalTo(alertView)
        }
        backButton.snp_makeConstraints { (make) in
            make.width.equalTo(340)
            make.height.equalTo(87)
            make.centerX.equalTo(alertView)
            make.bottom.equalTo(alertView).inset(36)
        }
        
    }
    
    func cleanUpResultsView() {
        
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(self.outAnimationDuration, animations: { () -> Void in
            self.view.backgroundColor = UIColor.clearColor()
            }, completion: { (complete) -> Void in
                super.dismissViewControllerAnimated(false) { () -> Void in
                    if let c = completion {
                        c()
                    }
                }
        })
        self.cleanUpResultsView()
        
    }
    
    private func getGift() -> String {
        switch self.time {
        case 0...10:
            return "传奇黑客"
        case 11...20:
            return "黑客大师"
        case 21...30:
            return "进阶黑客"
        case 31...40:
            return "普通黑客"
        case 41...50:
            return "黑客新手"
        default:
            return "黑客新手"
        }
    }
    
}

