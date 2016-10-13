//
//  ViewController.swift
//  SpinnerDemo
//
//  Created by Andrew Lloyd on 13/10/2016.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    var testButtonSpinnerView : SpinnerView? = nil

    @IBOutlet weak var loadingInViewButton: UIButton!
    @IBOutlet weak var loadinInVCButton: UIButton!
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBorderToButton(button: testButton)
        addBorderToButton(button: loadingInViewButton)
        addBorderToButton(button: loadinInVCButton)
    }
    
    func addBorderToButton(button: UIButton) {
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.gray.cgColor
    }

    @IBAction func testButtonPressed(_ sender: AnyObject) {

        testButtonSpinnerView = SpinnerView.showSpinner(inButton: testButton)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            self.testButtonSpinnerView?.dismiss()
        })
    }
    
    @IBAction func showLoadingInLabel(_ sender: AnyObject) {
        
        let testLabelSpinnerView = SpinnerView.showSpinner(inView: testLabel)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            testLabelSpinnerView.dismiss()
        })
    }
    
    @IBAction func showLoadingInVC(_ sender: AnyObject) {
        
        let vcSpinnerView = SpinnerView.showSpinner(inView: self.view)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            vcSpinnerView.dismiss()
        })
    }
}

