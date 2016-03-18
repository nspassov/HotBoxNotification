//
//  ViewController.swift
//  HotBoxNotificationExample
//
//  Created by Nikolay Spassov on 20.12.15.
//  Copyright © 2015 г. Nikolay Spassov. All rights reserved.
//

import UIKit
import HotBoxNotification

class ViewController: UIViewController, HotBoxDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        HotBox.sharedInstance().settings = [
            "failure": [ "backgroundColor": UIColor.redColor(), "image": UIImage(named: "677-emoticon-sad")! ],
            "warning": [ "backgroundColor": UIColor.yellowColor(), "image": UIImage(named: "676-emoticon-suprise")! ],
            "success": [ "backgroundColor": UIColor.greenColor(), "image": UIImage(named: "680-emoticon-shades")! ],
        ]
    }
    
    @IBAction func successTapped(sender: AnyObject) {
        HotBox.sharedInstance().showMessage(NSAttributedString(string: "This is success"), ofType: "success", withDelegate: self)
    }
    @IBAction func warningTapped(sender: AnyObject) {
        HotBox.sharedInstance().showMessage(NSAttributedString(string: "This is a warning but it is really long and takes up more than a single line"), ofType: "warning", withDelegate: self)
    }
    @IBAction func errorTapped(sender: AnyObject) {
        HotBox.sharedInstance().showMessage(NSAttributedString(string: "This is an error"), ofType: "failure", withDelegate: self)
    }
    @IBAction func errorWithButtonTapped(sender: AnyObject) {
        HotBox.sharedInstance().showStickyMessage(NSAttributedString(string: "This is an error"), ofType: "failure", withDelegate: self, buttonTitle: "Confirm")
    }
    @IBAction func dismissTapped(sender: AnyObject) {
        HotBox.sharedInstance().dismissAll()
    }
    
    func hotBoxHasExpired(type: String!) {
        print("Expired \(type)")
    }
    
    func hotBoxWasTapped(type: String!) {
        print("Tapped \(type)")
    }
    
    func hotBoxButtonWasTapped(type: String!) {
        print("Tapped button \(type)")
    }
}

