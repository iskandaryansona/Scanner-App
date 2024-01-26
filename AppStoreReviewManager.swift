//
//  AppStoreReviewManager.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 16.01.24.
//

import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    static func requestReviewInAppStore() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6476304078?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:])
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
