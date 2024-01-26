//
//  IAPService.swift
//  Scanner
//
//  Created by Sona on 18.01.24.
//

import Foundation
import UIKit
import StoreKit
import YandexMobileMetrica

class IAPService: NSObject{
    
    static let shared = IAPService()
    
    weak var delegate: PaywallDelegate?
    
    var myProduct: SKProduct?
    let paymentQueue = SKPaymentQueue.default()
    var request: SKProductsRequest?
    
    func getSKProducts(){
        if SKPaymentQueue.canMakePayments() {
        let productId:Set = ["app.buy.luxe.scanner"]
        let request = SKProductsRequest(productIdentifiers: productId)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
        }
    }
    
    func getProduts() async {
        let prod = try? await Product.products(for: ["app.buy.luxe.scanner"])
        let status = try? await prod?.first?.subscription?.status
        
        if status?.last?.state == .subscribed {
            UserDefaults.standard.setValue(true, forKey: "isSubscribed")
        } else if status?.last?.state == .expired {
            UserDefaults.standard.setValue(false, forKey: "isSubscribed")
        } else {
            print("nothing")
        }
        
    }
    
    func purChase(){
        guard let productToPurchase = myProduct else { return }
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: productToPurchase)
            paymentQueue.add(payment)
        }
    }
    
    func restorPurchases(){
        if (SKPaymentQueue.canMakePayments()) {
            paymentQueue.restoreCompletedTransactions()
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction) {
        
        let price = NSDecimalNumber(string: "$9.99")
        // Initializing the Revenue instance.
        let revenueInfo = YMMMutableRevenueInfo.init(priceDecimal: price, currency: "BYN")
        revenueInfo.productID = "Luxe Scanner"
        revenueInfo.quantity = 2
        revenueInfo.payload = ["source": "AppStore"]
        // Set purchase information for validation.
        if let url = Bundle.main.appStoreReceiptURL, let data = try? Data(contentsOf: url), let transactionID = transaction.transactionIdentifier {
            revenueInfo.transactionID = transactionID
            revenueInfo.receiptData = data
        }
        // Sending the Revenue instance using reporter.
        let reporter = YMMYandexMetrica.reporter(forApiKey: yandexMetricaID)
        reporter?.reportRevenue(revenueInfo, onFailure: { (error) in
            print("REPORT ERROR: \(error.localizedDescription)")
        })
        // Remove the transaction from the payment queue.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func trackTrialSubscriptionEvent() {
        let eventName = "Trial_Subscription_Event"
        let parameters: [String: Any] = [
            "Subscription_Type": "Trial"]
        YMMYandexMetrica.reportEvent(eventName, parameters: parameters, onFailure: { (error) in
            print("Failed to report event: \(error.localizedDescription)")
        })
    }
    
    private func handlePurchase(_ transaction: SKPaymentTransaction) {
        if let product = myProduct, product.introductoryPrice?.paymentMode == .freeTrial {
             trackTrialSubscriptionEvent()
         } else {
             completeTransaction(transaction)
         }
     }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
//            if product.introductoryPrice?.type == .subscription {
//                UserDefaults.standard.setValue(true, forKey: "isSubscribed")
//            }
            
        }
    }
    
}
extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchasing:
                break
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                UserDefaults.standard.setValue(true, forKey: "isSubscribed")
                delegate?.close()
                handlePurchase(transaction)
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                UserDefaults.standard.setValue(true, forKey: "isSubscribed")
                delegate?.close()
            @unknown default:
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
}
extension SKPaymentTransactionState{
    func status() -> String {
        switch self {
        case .purchasing:
            return "purchasing"
        case .purchased:
            return "purchased"
        case .restored:
            return "restored"
        case .failed:
            return "failed"
        case .deferred:
            return "deferred"
        default:
            return ""
        }
    }
}
