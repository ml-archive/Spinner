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
        
        _ = SpinnerView.showSpinner(inView: view)
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner)
    }
    
    func testDismissSpinnerInButton() {
        let spinner = SpinnerView.showSpinner(inView: view)
        spinner.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(!hasSpinner)
    }

    
    func testShowSpinnerInView() {
        
        _ = SpinnerView.showSpinner(inView: view)
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner)
    }
    
    func testDismissSpinnerInView() {
        let spinner = SpinnerView.showSpinner(inView: view)
        spinner.dismiss()
        let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(!hasSpinner)
    }
    
    func testShowCustomSpinnerInView() {
        
        _ = SpinnerView.showCustomSpinner(inView: view)
         let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(hasSpinner)
    }
    
    func testDismissCustomSpinnerInView() {
        let spinner = SpinnerView.showCustomSpinner(inView: view)
        spinner.dismiss()
         let hasSpinner = view.subviews.contains {$0 is Spinner}
        XCTAssert(!hasSpinner)
    }
    
}
