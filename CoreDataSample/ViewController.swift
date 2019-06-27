//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Juan José Jr Granados Moreno on 6/12/19.
//  Copyright © 2019 FIS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var delegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  let userJSON: [String : Any] = [
    "firstName" : "Juan José",
    "lastName": "Granados Moreno",
    "birthDate": "668704911000",
    "phoneNumber" : "943876756"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let user = User.fetchUser(),
      let userData = encode(user: user),
      let jsonString = String(data: userData, encoding: .utf8) {
      
      print("User birthdate", user.birthDate ?? "No date")
      print("User cached JSON: ",jsonString)
      
    }
    
    
    if let userDecoded = decode(userJSON: userJSON),
      let data = encode(user: userDecoded),
      let userString = String(data: data, encoding: .utf8) {
      print("User birthdate", userDecoded.birthDate ?? "No date")
      print("User decoded JSON: ", userString)
    }
    
  }
  
  func encode(user: User) -> Data? {
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970
    encoder.outputFormatting = .prettyPrinted
    
    do {
      
      let userData = try encoder.encode(user)
      return userData
      
    } catch {
      print("Error encoding: ", error.localizedDescription)
      return nil
    }
  }
  
  func decode(userJSON: [String: Any]) -> User? {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    decoder.userInfo[CodingUserInfoKey.context!] = delegate.persistentContainer.newBackgroundContext()
    
    do {
      let data = try JSONSerialization.data(withJSONObject: userJSON, options: .prettyPrinted)
      let user = try decoder.decode(User.self, from: data)
      return user
    } catch {
      print("Error: ", error.localizedDescription)
      return nil
    }
  }
}

