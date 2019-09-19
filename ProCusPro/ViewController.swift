//
//  ViewController.swift
//  ProCusPro
//
//  Created by Benjamin Purbowasito on 18/09/19.
//  Copyright © 2019 iosda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var focusContView: UIView!
    @IBOutlet weak var moveContView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentContAction(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex==0 {
            focusContView.alpha=1.0
            moveContView.alpha = 0.0
        }else{
            focusContView.alpha = 0.0
            moveContView.alpha = 1.0
        }
    }
}

