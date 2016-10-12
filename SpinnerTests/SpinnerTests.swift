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
        _ = SpinnerView.showSpinner(inButton: button)
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner && !button.isUserInteractionEnabled)
    }
    
    func testDismissSpinnerInButton() {
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        let spinner = SpinnerView.showSpinner(inButton: button)
        spinner.dismiss()
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner && button.isUserInteractionEnabled)
        let titleColorRed = button.titleColor(for: UIControlState.normal) == UIColor.red
        XCTAssertTrue(titleColorRed)
    }
    func testDismissSpinnerInButtonWithChangedColor() {
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        let spinner = SpinnerView.showSpinner(inButton: button)
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        spinner.dismiss()
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner && button.isUserInteractionEnabled)
        let titleColorBlue = button.titleColor(for: UIControlState.normal) == UIColor.blue
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
        let hasSpinner = button.subviews.contains {$0 is Spinner}
        XCTAssertFalse(hasSpinner && !button.isUserInteractionEnabled)
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
        XCTAssertFalse(hasSpinner && view.isUserInteractionEnabled)
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
        XCTAssertFalse(hasSpinner && view.isUserInteractionEnabled)
    }
    
}
