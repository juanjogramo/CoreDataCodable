//
//  User.swift
//  CoreDataSample
//
//  Created by Juan José Jr Granados Moreno on 6/12/19.
//  Copyright © 2019 FIS. All rights reserved.
//

import CoreData
import UIKit

@objc(User)
class User: NSManagedObject, Decodable {
  
  // MARK: - NSManged Properties
  @NSManaged var name: String?
  @NSManaged var lastName: String?
  @NSManaged var birthDate: String?
  @NSManaged var phoneNumber: String?
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {

    guard let contextUserInfoKey = CodingUserInfoKey.context else {
      fatalError("cannot find context key")
    }

    guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
      fatalError("cannot Retrieve context")
    }

    guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
      fatalError("Fail to decode User")
    }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
    phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)

    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Could not find a AppDelegate")
    }

    delegate.saveContext()
  }
}

// MARK: - CodingKeys
extension User {
  enum CodingKeys: String, CodingKey {
    case name = "firstName"
    case lastName
    case birthDate
    case phoneNumber
  }
  
  enum EncodingKeys: String, CodingKey {
    case name
    case lastName
    case birthDate
    case phoneNumber
  }
}

// MARK: - Encodable
extension User: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: EncodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(lastName, forKey: .lastName)
    try container.encode(birthDate, forKey: .birthDate)
    try container.encode(phoneNumber, forKey: .phoneNumber)
  }
}

extension User {
  
  static func fetchUser() -> User? {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context = delegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<User>(entityName: "User")
    
    do {
      let users = try context.fetch(fetchRequest)
      return users.first
    } catch let error {
      print(error)
      return nil
    }
  }
}
