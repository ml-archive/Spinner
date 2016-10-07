//
//  SpinnerTests.swift
//  SpinnerTests
//
//  Created by Chris Combs on 26/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import Spinner

class SpinnerTests: XCTestCase {
    
    let baseView = UIView()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Standard Spinner
    
    func testShowSpinnerInViewAndAnimating() {
        
        _ = SpinnerView.showSpinnerInView(baseView)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            let spinnerView = baseView.subviews[0] as! UIActivityIndicatorView
            XCTAssert(spinnerView.isKindOfClass(UIActivityIndicatorView))
            XCTAssert(spinnerView.isAnimating())
        }
        else {
            XCTFail()
        }
    }
    
    func testShowSpinnerInViewWithDisabledUserInteraction() {
        
        _ = SpinnerView.showSpinnerInView(baseView, disablesUserInteraction: true)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            _ = baseView.subviews[0] as! UIActivityIndicatorView
            XCTAssertFalse(baseView.userInteractionEnabled)
        }
        else {
            XCTFail()
        }
    }
    
    func testShowSpinnerInViewWithColor() {
        
        _ = SpinnerView.showSpinnerInView(baseView, color: UIColor.redColor(), disablesUserInteraction: true)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            let spinnerView = baseView.subviews[0] as! UIActivityIndicatorView
            XCTAssertTrue(spinnerView.color == UIColor.redColor())
        }
        else {
            XCTFail()
        }
    }
    
    func testShowSpinnerInViewWithGrayStyle() {
        
        _ = SpinnerView.showSpinnerInView(baseView, style: .Gray, disablesUserInteraction: true)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            let spinnerView = baseView.subviews[0] as! UIActivityIndicatorView
            XCTAssertTrue(spinnerView.activityIndicatorViewStyle == .Gray)
        }
        else {
            XCTFail()
        }
    }
    
    func testDismissSpinnerInViewWithUserInteraction() {
        
        let spinner = SpinnerView.showSpinnerInView(baseView, style: .Gray, disablesUserInteraction: true)
        
        spinner.dismiss(enablesUserInteraction: true)
    }
    
    //MARK: Button Spinner

    func testShowSpinnerInButton() {
        let button = UIButton()
        button.setTitle("ButtonTitle", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        baseView.addSubview(button)
        
        XCTAssertTrue(button.titleLabel?.textColor == UIColor.blueColor())
        
        let spinner: SpinnerView = SpinnerView.showSpinnerInButton(button) as! SpinnerView
        
        XCTAssertTrue(button.currentTitleColor == UIColor.clearColor())
        
        spinner.dismiss()
        
        XCTAssertTrue(button.currentTitleColor == UIColor.blueColor())
    }
    
    func testShowSpinnerInButtonWithUserInteraction() {
        let button = UIButton()
        button.setTitle("ButtonTitle", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        baseView.addSubview(button)
        
        XCTAssertTrue(button.titleLabel?.textColor == UIColor.blueColor())
        
        let spinner: SpinnerView = SpinnerView.showSpinnerInButton(button) as! SpinnerView
        
        XCTAssertTrue(button.currentTitleColor == UIColor.clearColor())
        
        spinner.dismiss(true)
        
        XCTAssertTrue(button.currentTitleColor == UIColor.blueColor())
    }
    
    //MARK: Custom Spinner
    
    func testShowCustomSpinnerWithoutImagesSet() {
        
        SpinnerView.setCustomImages([], duration: 0.2)
        _ = SpinnerView.showCustomSpinnerInView(baseView)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            let spinnerView = baseView.subviews[0] as! UIActivityIndicatorView
            XCTAssert(spinnerView.isKindOfClass(UIActivityIndicatorView))
            XCTAssert(spinnerView.isAnimating())
        }
        else {
            XCTFail()
        }
    }
    
    func testShowCustomSpinnerWithImagesSet() {
        let redImage = getImageWithColor(UIColor.redColor())
        let blueImage = getImageWithColor(UIColor.blueColor())
        
        SpinnerView.setCustomImages([redImage, blueImage], duration: 0.2)
        SpinnerView.showCustomSpinnerInView(baseView)
        
        XCTAssert(baseView.subviews.count == 1) //baseview should now have a subview
        
        if baseView.subviews.count == 1 {
            let spinnerView = baseView.subviews[0]
            XCTAssert(spinnerView.isKindOfClass(UIImageView))
        }
        else {
            XCTFail()
        }
    }
    
    func testCustomSpinnerInButton() {
        
        let button = UIButton()
        button.setTitle("ButtonTitle", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        baseView.addSubview(button)
        
        let redImage = getImageWithColor(UIColor.redColor())
        let blueImage = getImageWithColor(UIColor.blueColor())
        
        SpinnerView.setCustomImages([redImage, blueImage], duration: 0.2)
        let spinner: SpinnerView =  SpinnerView.showCustomSpinnerInButton(button)  as! SpinnerView
        
        XCTAssert(button.subviews.count == 1) //button should now have a subview (spinner)
        
        if button.subviews.count == 1 {
            let spinnerView = button.subviews[0]
            XCTAssert(spinnerView.isKindOfClass(UIImageView))

        }
        else {
            XCTFail()
        }
        
        spinner.dismiss()
        
    }
    
    //MARK: helper methods
    
    func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 10, 10)
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
