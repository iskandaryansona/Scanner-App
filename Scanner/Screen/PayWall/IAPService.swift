//
//  IAPService.swift
//  Scanner
//
//  Created by Sona on 18.01.24.
//

import Foundation
import UIKit
import StoreKit

class IAPService: NSObject{
    
    static let shared = IAPService()
    
    var myProduct: SKProduct?
    let paymentQueue = SKPaymentQueue.default()
    var request: SKProductsRequest?
    
    func getProducts(){
        if SKPaymentQueue.canMakePayments() {
        let productId:Set = ["app.buy.luxe.scanner"]
        let request = SKProductsRequest(productIdentifiers: productId)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
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
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
        }
    }
    
}
extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch  transaction.transactionState{
            case .purchasing:
                break
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
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
