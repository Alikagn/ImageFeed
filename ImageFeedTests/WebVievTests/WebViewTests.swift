//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 08.06.2025.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //When:
        _ = viewController.view
        
        //Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //Given:
        let viewController = WebViewViewControllerSpy()
        let authHelpper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelpper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When:
        presenter.viewDidLoad()
        
        //Then:
        XCTAssertTrue(viewController.loadCalled)
    }
   
    func testProgressVisitbleWhenLessTheOne() {
        //Given:
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //When:
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then:
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //Given:
        let configration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configration)
        
        //When:
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        //Then:
        XCTAssertTrue(urlString.contains(configration.authURLString))
        XCTAssertTrue(urlString.contains(configration.accessKey))
        XCTAssertTrue(urlString.contains(configration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configration.accessScope))
    }
    
    func testCodeFromURL() {
        //Given:
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //When:
        let code = authHelper.code(from: url)
        
        //Then:
        XCTAssertEqual(code, "test code")
    }
    
    func testProgressVisitbleWhenOne() {
        //Given:
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //When:
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then:
        XCTAssertTrue(shouldHideProgress)
    }
}
