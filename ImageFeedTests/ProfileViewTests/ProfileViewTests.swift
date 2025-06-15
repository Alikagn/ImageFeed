//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 12.06.2025.
//

@testable import ImageFeed
import XCTest
import Kingfisher

final class ProfileViewTests: XCTestCase {
    
    var sut: ProfileViewController!
    var presenter: ProfilePresenterSpy!
    
    override func setUp() {
        super.setUp()
        sut = ProfileViewController()
        presenter = ProfilePresenterSpy()
        sut.presenter = presenter
        sut.loadViewIfNeeded() 
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewControllerHasAllUIElements() {
        // Given
        let views = sut.testableViews()
        
        // Then
        XCTAssertNotNil(views.imageView)
        XCTAssertNotNil(views.nameLabel)
        XCTAssertNotNil(views.loginNameLabel)
        XCTAssertNotNil(views.descriptionLabel)
        XCTAssertNotNil(views.logoutButton)
    }
    
    func testViewDidLoadCallsPresenter() {
        //When:
        sut.viewDidLoad()
        
        //Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
        XCTAssertTrue(presenter.updateProfileDetailsCalled)
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testUpdateProfileDetails() {
        //Given:
        let testName = "Test Name"
        let testLogin = "@test"
        let testBio = "Test bio"
        
        //When:
        sut.updateProfileDetails(name: testName, loginName: testLogin, bio: testBio)
        
        //Then:
        let views = sut.testableViews()
        XCTAssertEqual(views.nameLabel.text, testName)
        XCTAssertEqual(views.loginNameLabel.text, testLogin)
        XCTAssertEqual(views.descriptionLabel.text, testBio)
    }
    
    func testUpdateAvatar() async {
        // Given
        let testURL = URL(string: "https://example.com/avatar.jpg")!
        let imageView = await sut.testableViews().imageView
        
        // When
        await sut.updateAvatar(with: testURL)
        
        // Then
        await MainActor.run {
            XCTAssertNotNil(imageView.kf.taskIdentifier)
        }
    }
    
}


