//
//  CodableManagedObject.swift
//  CoreDataSample
//
//  Created by Juan José Jr Granados Moreno on 6/13/19.
//  Copyright © 2019 FIS. All rights reserved.
//

import CoreData

class DecodableManagedObject: NSManagedObject, Decodable {
  
  required convenience init(from decoder: Decoder) throws {
    guard let contextUserInfoKey = CodingUserInfoKey.context else {
      fatalError("cannot find context key")
    }
    
    guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
      fatalError("cannot Retrieve context")
    }
    
    let name = String(describing: type(of: self))
    print("Name: ", name)
    guard let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext) else {
      fatalError("Fail to create entity")
    }
    
    self.init(entity: entity, insertInto: managedObjectContext)
  }
  
}

// MARK: - CodingUserInfoKey
extension CodingUserInfoKey {
  static let context = CodingUserInfoKey(rawValue: "context")
}
