//
//  EntryController.swift
//  CKJournal
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    var entries = [Entry]()
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD Methods
    func save(entry: Entry, completion: @escaping (Bool) -> Void) {
        let record = CKRecord(entry: entry)
        
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                return completion(false)
            }
            guard let record = record,
                let entry = Entry(ckRecord: record) else { return completion(false) }
            
            self.entries.append(entry)
            print("Entry saved successfully.")
            completion(true)
        }
    }
    
    func addEntryWith(title: String, bodyText: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, bodyText: bodyText)
        
        EntryController.shared.save(entry: entry, completion: completion)
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.RecordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                return completion(false)
            }
            guard let records = records else { return completion(false) }
            let entries = records.compactMap( {Entry(ckRecord: $0)} )
            self.entries = entries
            
            print("Successfully fetched Entries.")
            completion(true)
        }
    }
    
}
