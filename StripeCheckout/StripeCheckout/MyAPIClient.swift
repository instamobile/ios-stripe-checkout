//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import PassKit

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    func createAndConfirmPaymentIntent(_ result: STPPaymentResult,
                                       amount: Int,
                                       returnURL: String,
                                       shippingAddress: STPAddress?,
                                       shippingMethod: PKShippingMethod?,
                                       completion: @escaping ((Result<String, Error>) -> Void)) {
        let url = self.baseURL.appendingPathComponent("create_payment_intent")
        var params: [String: Any] = [
//            "source": result.paymentMethod?.stripeId ?? "",
            "price": amount,
            "return_url": returnURL,
            "metadata": [
                // example-ios-backend allows passing metadata through to Stripe
                "payment_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
            ],
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    if let json = json as? [AnyHashable: Any], let secret = json["secret"] as? String {
                        completion(.success(secret))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }

    func confirmPaymentIntent(_ paymentIntent: STPPaymentIntent, completion: @escaping STPPaymentIntentCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("confirm_payment")
        let params: [String: Any] = ["payment_intent_id": paymentIntent.stripeId]
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    completion(STPPaymentIntent.decodedObject(fromAPIResponse: json as? [AnyHashable: Any]), nil)
                case .failure(let error):
                    completion(nil, error)
                }
            })
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        AF.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

}
