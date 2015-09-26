//
//  OrderTests.swift
//
//  Created by Howard Wilson on 25/03/2015.
//  Copyright (c) 2015 Howard Wilson. All rights reserved.
//

import UIKit
import example

class OrderTests: AcceptanceTests {
  func testSuccessfulOrder() {
    stubLogin()
    stubSchedule()
    stubGooglePlaces()
    stubZoneAvailability()
    stubCreateCart()
    stubPayment()

    login()
    tapIncreaseQuantityButton()
    tapViewCartButton()
    tapEditAddressButton()
    enterAddressText()
    tapPredictionCell()
    enterPhoneText()
    tapContinueButton()
    tapPayButton()
  }
}

// MARK: - Step details
extension OrderTests {
  private func login() {
    stubRequest("https://example.com/api/users/me/cards", json: ExampleAPIFactory.cards)
    popchef.TestHelpers.userLogin("howard@watsonbox.net", password: "password")
    tester.waitForViewWithAccessibilityLabel("Livré en 15 minutes", traits: UIAccessibilityTraitStaticText)
  }

  private func tapIncreaseQuantityButton() {
    tester.tapViewWithAccessibilityLabel("Increase Quantity Button", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("View Cart Button", traits: UIAccessibilityTraitButton)
  }

  private func tapViewCartButton() {
    tester.tapViewWithAccessibilityLabel("View Cart Button", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Cart View")
  }

  private func tapEditAddressButton() {
    tester.tapViewWithAccessibilityLabel("Edit Address Button", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Adresse", traits: UIAccessibilityTraitStaticText)
  }

  private func enterAddressText() {
    tester.waitForFirstResponderWithAccessibilityLabel(nil, traits: UIAccessibilityTraitSearchField)
    tester.enterTextIntoCurrentFirstResponder("P")
  }

  private func tapPredictionCell() {
    tester.tapViewWithAccessibilityLabel("Prediction Cell")
    tester.waitForViewWithAccessibilityLabel("Cart View")
  }

  private func enterPhoneText() {
    tester.enterText("0612121212", intoViewWithAccessibilityLabel: "Phone Text Field")
  }

  private func tapContinueButton() {
    tester.tapViewWithAccessibilityLabel("Continuer", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Paiement")
  }

  private func tapPayButton() {
    tester.tapViewWithAccessibilityLabel("Payer", traits: UIAccessibilityTraitButton)
    tester.waitForViewWithAccessibilityLabel("Commande validée", traits: UIAccessibilityTraitStaticText)
  }
}

// MARK: - Stubs
extension OrderTests {
  private func stubLogin() {
    stubRequest("https://example.com/api/clients/login", json: ["token": ExampleAPIFactory.sessionToken])
    stubRequestWithToken("https://example.com/api/users/me", json: ExampleAPIFactory.user, token: ExampleAPIFactory.sessionToken)
  }

  private func stubSchedule() {
    stubRequest("https://example.com/api/schedules/now", json: ExampleAPIFactory.schedule)
    stubRequest("https://example.com/api/orders/me?page=1", json: [])
  }

  private func stubGooglePlaces() {
    stubRequest("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=P&key=AIzaSyDlRJFhVqrGkMRx_6xqT3UcUS_1irE6Roo&type=%28address%29", json: ExampleAPIFactory.googlePlaces)

    stubRequest("https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJD7fiBh9u5kcRYJSMaMOCCwQ&key=AIzaSyDlRJFhVqrGkMRx_6xqT3UcUS_1irE6Roo", json: ExampleAPIFactory.googlePlaceDetails)
  }

  private func stubZoneAvailability() {
    stubRequest("https://example.com/api/zones/availability", text: "true")
  }

  private func stubCreateCart() {
    stubRequest("https://example.com/api/carts", text: "\"60cb5dcfdc57402e\"")
  }

  private func stubPayment() {
    stubRequest("https://example.com/api/carts/60cb5dcfdc57402e", json: ExampleAPIFactory.order)
  }
}
