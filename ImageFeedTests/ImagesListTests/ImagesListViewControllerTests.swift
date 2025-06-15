//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    
    var viewController: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        viewController = ImagesListViewControllerSpy()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

 func testViewControllerCallsViewDidLoad() {
     // given
     let storyboard = UIStoryboard(name: "Main", bundle: .main)
     let viewController = storyboard.instantiateViewController(
         withIdentifier: "ImagesListViewController"
     ) as! ImagesListViewController

     let presenter = ImagesListPresenterSpy()
     viewController.presenter = presenter
     presenter.view = viewController

     // when
     _ = viewController.view

     // then
     XCTAssertTrue(presenter.viewDidLoadCalled)
 }
 
    func testUpdateTableViewAnimated() {
        //When:
        viewController.updateTableViewAnimated()
        
        //Then:
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPerformBatchUpdates() {
        //Given:
        let oldCount = 5
        let newCount = 10
        
        //When:
        viewController.performBatchUpdates(oldCount: oldCount, newCount: newCount)
        
        //Then:
        XCTAssertTrue(viewController.performBatchUpdatesCalled)
        XCTAssertEqual(viewController.oldCount, oldCount)
        XCTAssertEqual(viewController.newCount, newCount)
    }
    
    func testShowLikeAlert() {
        //Given:
        let testError = NSError(domain: "test", code: 123)
        
        //When:
        viewController.showLikeAlert(testError)
        
        //Then:
        XCTAssertTrue(viewController.showLikeAlertCalled)
        XCTAssertNotNil(viewController.likeError)
        XCTAssertEqual((viewController.likeError! as NSError).code, testError.code)
        XCTAssertEqual((viewController.likeError! as NSError).domain, testError.domain)
    }
    
    func testShowImageAlert() {
        //When:
        viewController.showImageAlert()
        
        //Then:
        XCTAssertTrue(viewController.showImageAlertCalled)
    }
    
}
