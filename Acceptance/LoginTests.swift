//
//  LoginTests.swift
//
//  Created by Howard Wilson on 24/03/2015.
//  Copyright (c) 2015 Howard Wilson. All rights reserved.
//

import example

class LoginTests: AcceptanceTests {
  func testSuccessfulLogin() {
    stubRequest("https://example.com/api/clients/login", json: ["token": ExampleAPIFactory.sessionToken])
    stubRequestWithToken("https://example.com/api/users/me", json: ExampleAPIFactory.user, token: ExampleAPIFactory.sessionToken)
    stubRequestWithToken("https://example.com/api/users/me/cards", json: ExampleAPIFactory.cards, token: ExampleAPIFactory.sessionToken)
    stubRequest("https://example.com/api/schedules/now", json: ExampleAPIFactory.schedule)
    stubRequest("https://example.com/api/orders/me?page=1", json: [])

    tester.enterText("howard@watsonbox.net", intoViewWithAccessibilityLabel: "Email Text Field")
    tester.enterText("password", intoViewWithAccessibilityLabel: "Password Text Field")

    tester.tapViewWithAccessibilityLabel("Connexion", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Livré en 15 minutes", traits: UIAccessibilityTraitStaticText)
  }

  // Test to simulate error noticed when debugging load-balancer login
  // When ERR_NOT_LOGGED_IN caught and causes logout, next successful login would crash app
  func testFailedCurrentUserAndReLogin() {
    stubRequest("https://example.com/api/clients/login", json: ["token": ExampleAPIFactory.sessionToken])
    stubRequestWithToken("https://example.com/api/users/me", json: ExampleAPIFactory.user, token: ExampleAPIFactory.sessionToken)
    stubRequestWithToken("https://example.com/api/users/me/cards", json: ExampleAPIFactory.cards, token: ExampleAPIFactory.sessionToken)
    stubRequest("https://example.com/api/schedules/now", json: ExampleAPIFactory.schedule)
    stubRequest("https://example.com/api/orders/me?page=1", json: [])

    tester.enterText("howard@watsonbox.net", intoViewWithAccessibilityLabel: "Email Text Field")
    tester.enterText("password", intoViewWithAccessibilityLabel: "Password Text Field")

    tester.tapViewWithAccessibilityLabel("Connexion", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Livré en 15 minutes", traits: UIAccessibilityTraitStaticText)

    stubRequestWithToken("https://example.com/api/users/me", json: ["error": "ERR_NOT_LOGGED_IN","message": "No user logged in"], token: ExampleAPIFactory.sessionToken, statusCode: 403)

    popchef.TestHelpers.removeCurrentUser()
    popchef.TestHelpers.applicationDidBecomeActive()

    tester.enterText("howard@watsonbox.net", intoViewWithAccessibilityLabel: "Email Text Field")
    tester.enterText("password", intoViewWithAccessibilityLabel: "Password Text Field")

    stubRequestWithToken("https://example.com/api/users/me", json: ExampleAPIFactory.user, token: ExampleAPIFactory.sessionToken)
    stubRequest("https://example.com/api/schedules/now", json: ExampleAPIFactory.schedule)

    tester.tapViewWithAccessibilityLabel("Connexion", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Livré en 15 minutes", traits: UIAccessibilityTraitStaticText)
  }
}
