//
//  AcceptanceTests.swift
//
//  Created by Howard Wilson on 24/03/2015.
//  Copyright (c) 2015 Howard Wilson. All rights reserved.
//

import example

class AcceptanceTests: KIFTestCase {
  override func beforeEach() {
    example.TestHelpers.reset() // Invoke a method in app target to reset app state
    catchAllRequests()
  }

  func stubRequest(url: String, json: AnyObject!, statusCode: Int32 = 200) {
    ExampleAPIStub.request(url, json: json, statusCode: statusCode)
  }

  func stubRequest(url: String, text: String, statusCode: Int32 = 200) {
    ExampleAPIStub.request(url, text: text, statusCode: statusCode)
  }

  func stubRequestWithCookie(url: String, json: AnyObject!, cookie: String, statusCode: Int32 = 200) {
    ExampleAPIStub.requestWithCookie(url, json: json, cookie: cookie, statusCode: statusCode)
  }

  func stubRequestWithToken(url: String, json: AnyObject!, token: String, statusCode: Int32 = 200) {
    ExampleAPIStub.requestWithToken(url, json: json, token: token, statusCode: statusCode)
  }

  func stubRequest(url: String, response: OHHTTPStubsResponse) {
    ExampleAPIStub.request(url, response: response)
  }

  // A catch-all stub ensures that no real API requests are made during test run
  // See also: https://github.com/AliSoftware/OHHTTPStubs/wiki/Usage-Examples#stack-multiple-stubs-and-remove-installed-stubs
  func catchAllRequests() {
    OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest!) -> Bool in
      // Allow image requests
      return request.URL.absoluteString?.rangeOfString("medias") == nil
      }, withStubResponse: { (request: NSURLRequest!) -> OHHTTPStubsResponse in
        let exception = NSException(name: "Unexpected Web Request", reason: "Real web requests are not allowed: " + request.URLString, userInfo: nil)
        self.failWithException(exception, stopTest: true)

        return OHHTTPStubsResponse()
    })
  }
}
