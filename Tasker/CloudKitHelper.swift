//
//  CloudKitHelper.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 23/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

// MARK: - notes
// good to read: https://www.hackingwithswift.com/read/33/overview
//
// important setup in CloudKit Dashboard:
//
// https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset
// https://www.hackingwithswift.com/read/33/5/a-hands-on-guide-to-the-cloudkit-dashboard
//
// On your device (or in the simulator) you should make sure you are logged into iCloud and have iCloud Drive enabled.

class CloudKitHelper {
    
    // MARK: - record types
    struct RecordType {
        static let Items = "Items"
    }
    
    // MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: - saving to CloudKit
    static func save(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.Items)
    //    itemRecord["task"] = item.task as CKRecordValue
        itemRecord["dot"] = item.date as CKRecordValue
        itemRecord["task"] = item.task as CKRecordValue
        itemRecord["duration"] = item.duration as CKRecordValue
        itemRecord["comment"] = item.comment as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                let recordID = record.recordID
                guard let task = record["task"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let duration = record["duration"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let comment = record["comment"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let date = record["dot"] as? Date else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                let listElement = ListElement(recordID: recordID, date: date,task: task, duration: duration, comment: comment)
                completion(.success(listElement))
            }
        }
    }
    
    // MARK: - fetching from CloudKit
    class func fetch(completion: @escaping (Result<[ListElement], Error>) -> ()) {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "dot", ascending: false)
        let query = CKQuery(recordType: "Items", predicate: pred)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
   //     operation.desiredKeys = ["date","task","comment","duration"]
     //   operation.resultsLimit = 500
        var taskRecord = [ListElement]()
        
        operation.recordFetchedBlock = { record in
                var taskRec = ListElement(date: Date(), task: "", duration: 0, comment: "")
            
                taskRec.recordID = record.recordID
                 taskRec.task = record["task"] as! String
                 taskRec.duration = record["duration"] as! Int
                 taskRec.comment = record["comment"] as! String
                 taskRec.date = record["dot"] as! Date
                taskRecord.append(taskRec)
            }
             
        operation.queryCompletionBlock = { (cursor, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    
                } else {
                    completion(.success(taskRecord))
                }
            }
            
        }
        
        CKContainer.init(identifier: "iCloud.com.pjnorris.Tasker").publicCloudDatabase.add(operation)
        
    }
    
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    // MARK: - modify in CloudKit
  /* static func modify(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            record["task"] = item.task as CKRecordValue

            CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        completion(.failure(err))
                        return
                    }
                    guard let record = record else {
                        completion(.failure(CloudKitHelperError.recordFailure))
                        return
                    }
                    let recordID = record.recordID
                    guard let task = record["task"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let comment = record["comment"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let duration = record["duration"] as? Int else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let date = record["dot"] as? Date else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                        let listElement = ListElement(recordID: recordID, date: date,task: task, duration: duration, comment: comment)
                        
                    completion(.success(listElement))
                }
            }
        }
    }*/
}
