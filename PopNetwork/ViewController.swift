//
//  ViewController.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomeThing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doSomeThing() {
        
//        User.decode(from: Request(url: "https://api.onevcat.com/users/onevcat")) { (result) in
//            switch result {
//            case .Success(let user):
//                print("\(user)")
//            case .Faliure(let error):
//                if case .error(let reason) = error {
//                    print("\(reason)")
//                }
//            }
//        }
        User.decode { (result) in
            switch result {
            case .Success(let user):
                print("\(user)")
            case .Faliure(let error):
                if case .error(let reason) = error {
                    print("\(reason)")
                }
            }
        }
    }
}

