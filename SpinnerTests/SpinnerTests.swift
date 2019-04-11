//
//  SpinnerTests.swift
//  SpinnerTests
//
//  Created by Jakob Mygind on 29/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import Spinner

class SpinnerTests: XCTestCase {
    
    var view = UIView()
    var button = UIButton()
    var globalSpinner: SpinnerView?
    
    override func setUp() {
        super.setUp()
        view = UIView()
        button = UIButton()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShowSpinnerInButton() {
        button.isUserInteractionEnabled = true
        let spinnerView = SpinnerView.showSpinner(inButton: button)
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !button.isUserInteractionEnabled)
        XCTAssert(spinnerView.isKind(of: SpinnerView.classForCoder()))
    }
    
    func testDismissSpinnerInButton() {
        button.setTitleColor(UIColor.red, for: UIControl.State.normal)
        let spinner = SpinnerView.showSpinner(inButton: button)
        spinner.dismiss()
        let potentialSpinnerViews = button.subviews.filter {$0 is Spinner}
        let imageViews = potentialSpinnerViews.filter({$0 is UIImageView})
        let hasSpinner = potentialSpinnerViews.count - imageViews.count > 0
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(button.isUserInteractionEnabled)
        let titleColorRed = button.titleColor(for: UIControl.State.normal) == UIColor.red
        XCTAssertTrue(titleColorRed)
    }
    
    func testDismissSpinnerInButtonWithChangedColor() {
        button.setTitleColor(UIColor.red, for: UIControl.State.normal)
        let spinner = SpinnerView.showSpinner(inButton: button)
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        spinner.dismiss()
        let potentialSpinnerViews = button.subviews.filter {$0 is Spinner}
        let imageViews = potentialSpinnerViews.filter({$0 is UIImageView})
        let hasSpinner = potentialSpinnerViews.count - imageViews.count > 0
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(button.isUserInteractionEnabled)
        let titleColorBlue = button.titleColor(for: UIControl.State.normal) == UIColor.blue
        XCTAssertTrue(titleColorBlue)
    }
    
    func testShowSpinnerInDisabledButton() {
        button.isUserInteractionEnabled = false
        _ = SpinnerView.showSpinner(inButton: button)
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !button.isUserInteractionEnabled)
    }
    
    func testDismissSpinnerInDisabledButton() {
        button.isUserInteractionEnabled = false
        let spinner = SpinnerView.showSpinner(inButton: button)
        spinner.dismiss()
        let potentialSpinnerViews = button.subviews.filter {$0 is Spinner}
        let imageViews = potentialSpinnerViews.filter({$0 is UIImageView})
        let hasSpinner = potentialSpinnerViews.count - imageViews.count > 0
        XCTAssertFalse(hasSpinner)
//        XCTAssertTrue(!button.isUserInteractionEnabled)
    }
    
    func testShowSpinnerInView() {
        view.isUserInteractionEnabled = true
        _ = SpinnerView.showSpinner(inView: view)
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !view.isUserInteractionEnabled)
    }
    
    func testDismissSpinnerInView() {
        let spinner = SpinnerView.showSpinner(inView: view)
        spinner.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(view.isUserInteractionEnabled)
    }
    
    func testDismissMultipleAddedGlobalSpinnersInView() {
        globalSpinner = SpinnerView.showSpinner(inView: view)
        globalSpinner = SpinnerView.showSpinner(inView: view)
        globalSpinner = SpinnerView.showSpinner(inView: view)
        let spinners = view.subviews.filter({ $0 is Spinner })
        XCTAssertTrue(spinners.count == 1)
        globalSpinner?.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(view.isUserInteractionEnabled)
    }
    
    func testShowSpinnerInViewDimBackground() {
        view.isUserInteractionEnabled = true
        _ = SpinnerView.showSpinner(inView: view, dimBackground: true)
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        let dimmedBackground = view.subviews.count == 2
        XCTAssert(hasSpinner && dimmedBackground && !view.isUserInteractionEnabled)
    }
    
    func testDismissSpinnerInViewDimBackground() {
        let spinner = SpinnerView.showSpinner(inView: view, dimBackground: true)
        spinner.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(view.isUserInteractionEnabled)
        XCTAssert(view.subviews.count == 0)
    }
    
    func testShowCustomSpinnerInView() {
        view.isUserInteractionEnabled = true
        _ = SpinnerView.showCustomSpinner(inView: view)
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !view.isUserInteractionEnabled)
    }
    
    func testDismissCustomSpinnerInView() {
        let spinner = SpinnerView.showCustomSpinner(inView: view)
        spinner.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(view.isUserInteractionEnabled)
    }
    
    func testShowCustomSpinnerInButton() {
        _ = SpinnerView.showCustomSpinner(inButton: button, disablesUserInteraction: true)
        var hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !button.isUserInteractionEnabled)
        
        _ = SpinnerView.showCustomSpinner(inButton: button, disablesUserInteraction: false)
        hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && button.isUserInteractionEnabled)
    }
    
    func testDismissCustomSpinnerInButton() {
        let spinner = SpinnerView.showCustomSpinner(inButton: button, disablesUserInteraction: true)
        spinner.dismiss()
        let potentialSpinnerViews = button.subviews.filter {$0 is Spinner}
        let falseSpinnerViews = potentialSpinnerViews.filter({$0 is UIImageView})
        let hasSpinner = potentialSpinnerViews.count - falseSpinnerViews.count > 0

        XCTAssertFalse(hasSpinner)
        XCTAssertTrue(view.isUserInteractionEnabled)
    }
    
    func testShowSpinnerInButtonWithAttributedSting() {
        button.isUserInteractionEnabled = true
        
        let attributedString = NSAttributedString(string: "title", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 19)])
        button.setAttributedTitle(attributedString, for: .normal)
        
        let spinnerView = SpinnerView.showSpinner(inButton: button)
        XCTAssertNil(button.attributedTitle(for: .normal))
        spinnerView.dismiss()
        XCTAssertNotNil(button.attributedTitle(for: .normal))
    }
}
