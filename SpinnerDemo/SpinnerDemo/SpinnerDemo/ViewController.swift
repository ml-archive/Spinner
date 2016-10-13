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
    @IBOutlet weak var customTestLabel: UILabel!
    
    @IBOutlet weak var customTestButton: UIButton!
    @IBOutlet weak var customLoadingInViewButton: UIButton!
    @IBOutlet weak var customLoadinInVCButton: UIButton!
    
    var customImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customImages = [UIImage(named: "loading_0")!, UIImage(named: "loading_1")!, UIImage(named: "loading_2")!, UIImage(named: "loading_3")!, UIImage(named: "loading_4")!, UIImage(named: "loading_5")!, UIImage(named: "loading_6")!, UIImage(named: "loading_7")!, UIImage(named: "loading_8")!]
        
        addBorderToButton(button: testButton)
        addBorderToButton(button: loadingInViewButton)
        addBorderToButton(button: loadinInVCButton)
        
        addBorderToButton(button: customTestButton)
        addBorderToButton(button: customLoadingInViewButton)
        addBorderToButton(button: customLoadinInVCButton)
    }
    
    func addBorderToButton(button: UIButton) {
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.gray.cgColor
    }
    
    //MARK: Actions
    //MARK: Standard Spinner

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
    
    //MARK: Standard Spinner
    
    @IBAction func customTestButtonPressed(_ sender: AnyObject) {
        
        SpinnerView.set(customImages: customImages, duration: 0.2)
        let customSpinner = SpinnerView.showCustomSpinner(inButton: customTestButton)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            customSpinner.dismiss()
        })
    }
    
    @IBAction func showCustomLoadingInLabel(_ sender: AnyObject) {
        
        SpinnerView.set(customImages: customImages, duration: 0.2)
        let customSpinner = SpinnerView.showCustomSpinner(inView: customTestLabel)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            customSpinner.dismiss()
        })
    }

    @IBAction func showCustomLoadingInVC(_ sender: AnyObject) {
        
        SpinnerView.set(customImages: customImages, duration: 0.2)
        let customSpinner = SpinnerView.showCustomSpinner(inView: self.view)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (finished) in
            
            customSpinner.dismiss()
        })
    }
}

