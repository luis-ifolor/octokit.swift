//
//  TagsTests.swift
//  OctoKitTests
//
//  Created by Luís Silva on 07/10/2022.
//  Copyright © 2022 nerdish by nature. All rights reserved.
//

import OctoKit
import XCTest

final class TagsTests: XCTestCase {
    // MARK: Actual Request tests

    func testListTags() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/tags?per_page=30",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "Fixtures/tags",
                                            statusCode: 200)
        let task = Octokit().listTags(session, owner: "octocat", repository: "Hello-World") {
            switch $0 {
            case let .success(tags):
                XCTAssertEqual(tags.count, 2)
                if let tag = tags.first {
                    XCTAssertEqual(tag.name, "1.0.0")
                    XCTAssertEqual(tag.tarballURL.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
                    XCTAssertEqual(tag.zipballURL.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
                    XCTAssertEqual(tag.commit, "01234")
                } else {
                    XCTFail("Failed to unwrap `releases.first`")
                }
                if let tag = tags.last {
                    XCTAssertEqual(tag.name, "0.9.0")
                    XCTAssertEqual(tag.tarballURL.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v0.9.0")
                    XCTAssertEqual(tag.zipballURL.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v0.9.0")
                    XCTAssertEqual(tag.commit, "123456")
                } else {
                    XCTFail("Failed to unwrap `releases.last`")
                }
            case let .failure(error):
                XCTFail("Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
