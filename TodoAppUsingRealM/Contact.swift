//
//  Contact.swift
//  TodoAppUsingRealM
//
//  Created by MacBook on 08/06/2022.
//

import Foundation
import RealmSwift

class Contact : Object {
     
   @Persisted var firstName: String
   @Persisted var lastName: String
    
   convenience init(firstName: String, lastName: String) {
       self.init()
        self.firstName = firstName
        self.lastName = lastName
    }
}
