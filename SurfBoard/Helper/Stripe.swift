//
//  Stripe.swift
//  Stripe_Swift
//
//  Created by eSparkBiz-1 on 29/01/20.
//  Copyright © 2020 eSparkBiz. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

struct StripeTools {
    
    //store stripe secret key
    private var stripeSecret = "sk_live_ET7LZFYyTlcAne2Ks2oMK7Wd00he1HRrkK"
    // Old Test : sk_test_aAHlREXgZXxKwYVhHdKAsFjd
    // New Test : sk_test_VDwPJeeE1mxLhkClrJS2qMSv00tNiPStLN
    // Live : "sk_live_ET7LZFYyTlcAne2Ks2oMK7Wd00he1HRrkK"
    
    static let shared = StripeTools()
    //generate token each time you need to get an api call
    func generateToken(card: STPCardParams, completion: @escaping (_ token: STPToken?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                completion(token)
            }
            else {
                print(error as Any)
                displayAlert(APPNAME, andMessage: (error?.localizedDescription)!)
                completion(nil)
            }
        }
    }
    
    func getBasicAuth() -> String{
        return "Bearer \(self.stripeSecret)"
    }
    
}

class StripeUtil {
    
    var stripeTool =  StripeTools()
    var customerId: String?
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    static let shared = StripeUtil()

    //createUser
    func createUser(card: STPCardParams, email:String ,completion:@escaping  (_ success: Bool) -> Void) {
        
        //Stripe iOS SDK will gave us a token to make APIs call possible
        stripeTool.generateToken(card: card) { (token) in
            if(token != nil) {
                
                //request to create the user
                let request = NSMutableURLRequest(url: NSURL(string: "https://api.stripe.com/v1/customers")! as URL)
                
                //params array where you can put your user informations
                var params = [String:String]()
                params["email"] = email //"test@test.test"
                
                //transform this array into a string
                var str = ""
                params.forEach({ (key, value) in
                    str = "\(str)\(key)=\(value)&"
                })
                
                //basic auth
                request.setValue(self.stripeTool.getBasicAuth(), forHTTPHeaderField: "Authorization")
                
                //POST method, refer to Stripe documentation
                request.httpMethod = "POST"
                request.httpBody = str.data(using: String.Encoding.utf8)
                
                //create request block
                self.dataTask = self.defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
                    
                    //get returned error
                    if let error = error {
                        print(error)
                        displayAlert(APPNAME, andMessage: error.localizedDescription)
                        completion(false)
                    }
                    else if let httpResponse = response as? HTTPURLResponse {
                        //you can also check returned response
                        if(httpResponse.statusCode == 200) {
                            if let data = data {
                                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableDictionary
                                //serialize the returned datas an get the customerId
                                print("json:-",json)
                                //let dict = json //as? NSMutableDictionary
                                
                                if let id = json["id"] as? String {
                                    self.customerId = id
                                    UserDefaults.standard.set(self.customerId as Any, forKey: "customerId")
                                    UserDefaults.standard.synchronize()
                                    self.createCard(stripeId: id, card: card) { (success) in
                                        completion(true)
                                    }
                                }
                            }
                        }
                        else {
                            completion(false)
                        }
                    }
                }
                
                //launch request
                self.dataTask?.resume()
            }
        }
    }
    
    //create card for given user
    func createCard(stripeId: String, card: STPCardParams, completion:@escaping  (_ success: Bool) -> Void) {
        
        stripeTool.generateToken(card: card) { (token) in
            if(token != nil) {
                let request = NSMutableURLRequest(url: NSURL(string: "https://api.stripe.com/v1/customers/\(stripeId)/sources")! as URL)
                
                //token needed
                var params = [String:String]()
                params["source"] = token!.tokenId
                
                var str = ""
                params.forEach({ (key, value) in
                    str = "\(str)\(key)=\(value)&"
                })
                
                //basic auth
                request.setValue(self.stripeTool.getBasicAuth(), forHTTPHeaderField: "Authorization")
                
                request.httpMethod = "POST"
                request.httpBody = str.data(using: String.Encoding.utf8)
                
                self.dataTask = self.defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
                    
                    if let error = error {
                        print(error)
                        displayAlert(APPNAME, andMessage: error.localizedDescription)
                        completion(false)
                    }
                    else if let data = data {
                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(json)
                        completion(true)
                        
//                        let sizeDict = json as? NSDictionary
//                        let errorMsg = sizeDict?.value(forKey: "error") as? NSDictionary ?? [:]
//                        print(errorMsg.value(forKey: "message") as? String!)
                    }
                }
                
                self.dataTask?.resume()
            }
        }
        
    }
    
    //get user card list
    func getCardsList(completion:@escaping  (_ result: [AnyObject]?) -> Void) {
        
        //request to create the user
        //let request = NSMutableURLRequest(url: NSURL(string: "https://api.stripe.com/v1/customers/\(self.customerId!)/sources?object=card")! as URL)
        //        let custID = UserDefaults.standard.value(forKey: "customerId") as? String
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.stripe.com/v1/customers/\(custID!)/sources?object=card")! as URL)
        
        //basic auth
        request.setValue(self.stripeTool.getBasicAuth(), forHTTPHeaderField: "Authorization")
        
        //POST method, refer to Stripe documentation
        request.httpMethod = "GET"
        
        //create request block
        self.dataTask = self.defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //get returned error
            if let error = error {
                print(error)
                displayAlert(APPNAME, andMessage: error.localizedDescription)
                completion(nil)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                //you can also check returned response
                if(httpResponse.statusCode == 200) {
                    if let data = data {
                        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableDictionary
                        print("json:-",json)
                        let cardsArray = json["data"] as? [AnyObject]
                        print("cardsArray:-",cardsArray as Any)
                        completion(cardsArray)
                    }
                }
                else {
                    completion(nil)
                }
            }
        }
        
        //launch request
        self.dataTask?.resume()
        
    }
    //get user card list
    func createPaymentIntent(amount: Int, bookingID: String, completion: @escaping ((Result<String>) -> Void)) {
        
        let url = "https://api.stripe.com/v1/payment_intents" //self.baseURL.appendingPathComponent("createPaymentIntentForStripeAccount")
        let transfer_group = bookingID.components(separatedBy: "/").last!
        let params: [String: Any] = [
            "uid": "",
            "customer_id":UserDefaults.standard.value(forKey: "customerId")as Any,
            "amount": amount,
            "transfer_group": transfer_group,
            "currency": "USD"
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { responseString in
                switch responseString.result {
                case .success(let clientSecret):
                    print(clientSecret)
                    completion(.success(clientSecret.replacingOccurrences(of: "\"", with: "")))
                //completion(.success(clientSecret))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func createPaymentMethod(with paymentMethodParams: STPPaymentMethodParams, completion: @escaping STPPaymentMethodCompletionBlock) {
        guard let card = paymentMethodParams.card
            //,let billingDetails = paymentMethodParams.billingDetails
            else { return }
        
        // Generate a mock card model using the given card params
        var cardJSON: [String: Any] = [:]
        var billingDetailsJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth ?? 0)"
        cardJSON["exp_year"] = "\(card.expYear ?? 0)"
        cardJSON["last4"] = card.number?.suffix(4)
        billingDetailsJSON["name"] = "Test" //billingDetails.name
        billingDetailsJSON["line1"] = "Test" //billingDetails.address?.line1
        billingDetailsJSON["line2"] = "Test" //billingDetails.address?.line2
        billingDetailsJSON["state"] = "Test" //billingDetails.address?.state
        billingDetailsJSON["postal_code"] = "12345" //billingDetails.address?.postalCode
        billingDetailsJSON["country"] = "Test"//billingDetails.address?.country
        cardJSON["country"] = "United States"//billingDetails.address?.country
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let paymentMethodJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "payment_method",
            "type": "card",
            "livemode": false,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
            "billing_details": billingDetailsJSON,
            ]
        let paymentMethod = STPPaymentMethod.decodedObject(fromAPIResponse: paymentMethodJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(paymentMethod, nil)
        }
    }
    
}

class MockAPIClient: STPAPIClient {
    override func createPaymentMethod(with paymentMethodParams: STPPaymentMethodParams, completion: @escaping STPPaymentMethodCompletionBlock) {
        guard let card = paymentMethodParams.card, let billingDetails = paymentMethodParams.billingDetails else { return }
        
        // Generate a mock card model using the given card params
        var cardJSON: [String: Any] = [:]
        var billingDetailsJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth ?? 0)"
        cardJSON["exp_year"] = "\(card.expYear ?? 0)"
        cardJSON["last4"] = card.number?.suffix(4)
        billingDetailsJSON["name"] = billingDetails.name
        billingDetailsJSON["line1"] = billingDetails.address?.line1
        billingDetailsJSON["line2"] = billingDetails.address?.line2
        billingDetailsJSON["state"] = billingDetails.address?.state
        billingDetailsJSON["postal_code"] = billingDetails.address?.postalCode
        billingDetailsJSON["country"] = billingDetails.address?.country
        cardJSON["country"] = billingDetails.address?.country
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let paymentMethodJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "payment_method",
            "type": "card",
            "livemode": false,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
            "billing_details": billingDetailsJSON,
            ]
        let paymentMethod = STPPaymentMethod.decodedObject(fromAPIResponse: paymentMethodJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(paymentMethod, nil)
        }
    }
}
