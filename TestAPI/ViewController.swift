//
//  ViewController.swift
//  TestAPI
//
//  Created by Ryan Kanno on 4/12/21.
//

import UIKit

struct RealtyMole: Codable {
   let rent: Double
   let rentRangeLow: Double
   let rentRangeHigh: Double
   let longitude: Double
   let latitude: Double
   //   let listings: Listings
}
struct Listings: Codable {
   let id: String
   let formattedAddress: String
   let longitude: Double
   let latitude: Double
   let city: String
   let state: String
   let zipcode: String
   let price: Double
   let publishedData: String
   let distance: Double
   let daysOld: Double
   let correlation: Double
   let address: String
   let county: String
   let bedrooms: Int
   let bathrooms: Int
   let propertyType: String
   let squareFootage: Int
}

struct Rent: Encodable, Decodable {
   let rent:Double
   let rentRangeLow: Double
   let rentRangeHigh: Double
   let longitude: Double
   let latitude: Double
   //   var listings: [MoleListings]
}
struct MoleListings: Encodable, Decodable {
   let id: String
   let formattedAddress: String
   let longitude: Double
   let latitude: Double
   let city: String
   let state: String
   let zipcode: String
   let price: Double
   let publishedData: String
   let distance: Double
   let daysOld: Double
   let correlation: Double
   let address: String
   let county: String
   let bedrooms: Int
   let bathrooms: Int
   let propertyType: String
   let squareFootage: Int
}


struct USPSAddress: Codable {
   let delivery_line_1: String
   let last_line: String
   let components: Components
   let metadata: Metadata
}
struct Components: Codable {
   let primary_number: String
   let street_predirection: String
   let street_name: String
   let street_suffix: String
   let city_name: String
   let default_city_name: String
   let state_abbreviation: String
   let zipcode: String
   let plus4_code: String
}
struct Metadata: Codable {
   let county_name: String
   let latitude: Double
   let longitude: Double
   let time_zone: String
}

class ViewController: UIViewController {
   @IBOutlet weak var textField: UITextField!
   @IBOutlet weak var testButton: UIButton!
   let url = "https://realty-mole-property-api.p.rapidapi.com/rentalPrice?compCount=5&address=16101%20Midvale%20Ave%20N%2C%20Shoreline%2C%20WA%2098133"
   let realtyMoleHeaders: [String:String] = [
      "x-rapidapi-key": "1ee40e1078mshf47892cf43b08c9p1bb6b6jsn67c6fbffd29b",
      "x-rapidapi-host": "realty-mole-property-api.p.rapidapi.com"]
   let uspsURL = "https://us-street.api.smartystreets.com/street-address?auth-id=e4e34a71-81c7-6925-200c-0959054a8680&auth-token=mY3tKUufVM6Dm9eQIXKP&candidates=10&street=1017%20NE%20175th%20St&city=Shoreline&state=WA&zipcode=98133&match=invalid"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      textField.delegate = self
      testButton.layer.borderWidth = 1
      testButton.layer.borderColor = UIColor.white.cgColor
      testButton.layer.cornerRadius = 6
   } //: viewDidLoad
   
   
   func attemptCall() {
      noHeaderCall(url: uspsURL, returnType: [USPSAddress].self) { (result) in
         switch result {
         case .failure(let error):
            print(error)
         case .success(let success):
            print(success[0].delivery_line_1)
            print(success[0].last_line)
            print(success[0].components.primary_number)
            print(success[0].components.street_predirection)
            print(success[0].components.street_name)
            print(success[0].components.street_suffix)
            print(success[0].components.city_name)
            print(success[0].components.default_city_name)
            print(success[0].components.state_abbreviation)
            print(success[0].components.zipcode)
            print(success[0].components.plus4_code)
            print(success[0].metadata.county_name)
            print(success[0].metadata.latitude)
            print(success[0].metadata.longitude)
            print(success[0].metadata.time_zone)
         }
      } //: noHeaderCall()
   } //: attemptCall()
   
   
   func noHeaderCall<T: Codable>(url: String, returnType: T.Type, completion: @escaping (Result<T, Error>) -> Void ) {
      let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
      let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
         if let error = error {
            completion(.failure(error))
            return
         } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse as Any)
         }
         guard let data = data else { return }
         do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
         } catch let decodingErr {
            completion(.failure(decodingErr))
         }
      }
      task.resume()
   } //: noHeaderCall()
   
   
   func performHeaderCall<T: Codable>(url: String, headers: [String:String], expectingReturnType: T.Type, completion: @escaping (Result<T, Error>) -> Void ) {
      
      let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = headers
      
      let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
         if let error = error {
            completion(.failure(error))
            return
         } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse as Any)
         }
         guard let data = data else { return }
         do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
         } catch let decodingErr {
            completion(.failure(decodingErr))
         }
      }
      task.resume()
   } //: performAPICall()
   
} //: ViewController


extension ViewController: UITextFieldDelegate {
   
   @IBAction func testTapped(_ sender: UIButton) {
      self.attemptCall()
   } //: testTapped()
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.endEditing(true)
      textField.placeholder = "address"
      return true
   }
   
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      if textField.text != "" {
         textField.placeholder = "address"
         return true
      } else {
         return false
      }
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      // Call USPS API to validate address
      textField.placeholder = "address"
      self.attemptCall()
   }
   
} //: UITextFieldDelegate
