//
//  DatabaseHelper.swift
//  TodoAppUsingRealM
//
//  Created by MacBook on 08/06/2022.
//

import UIKit
import RealmSwift

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabaseURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func getAllContacts() -> [Contact] {
        return Array(realm.objects(Contact.self))
    }
    
    func saveContact(contact: Contact) {
        try! realm.write {
            realm.add(contact)
        }
    }
    
    func updateContact(oldContact: Contact, newContact: Contact){
        try! realm.write{
            oldContact.firstName = newContact.firstName
            oldContact.lastName = newContact.lastName
        }
    }
    
    func deleteContact(contact: Contact) {
        try! realm.write{
            realm.delete(contact)
        }
    }
}
