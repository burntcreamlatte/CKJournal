//
//  Entry.swift
//  CKJournal
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CloudKit

enum EntryConstants {
    static let RecordTypeKey = "Entry"
    static let TitleKey = "title"
    static let BodyKey = "bodyText"
    static let TimestampKey = "timestamp"
}

class Entry {
    let title: String
    let bodyText: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String, let bodyText = ckRecord[EntryConstants.BodyKey] as? String, let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordTypeKey)
        setValue(entry.title, forKey: EntryConstants.TitleKey)
        setValue(entry.bodyText, forKey: EntryConstants.BodyKey)
        setValue(entry.timestamp, forKey: EntryConstants.TimestampKey)
    }
}
