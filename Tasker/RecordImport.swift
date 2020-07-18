//
//  RecordImport.swift
//  SwiftUICloudKitDemo
//
//  Created by Paul Norris on 15/07/2020.
//

import SwiftUI
import CloudKit
import UIKit

func importCSV(_ fileName: String) -> [ListElement] {

    var array = [ListElement]()

    do {
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        let data = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let rows = data.components(separatedBy: "\n")

       //rows.removeAtIndex(0) // if first row contains field names

        outerloop: for row in rows {
            if row == "\n" { break outerloop }
            let values = row.components(separatedBy: "\t")

            var artist = ListElement(date: Date(), task: "", duration: 0, comment: "")
            let formatter=DateFormatter()
            formatter.dateFormat = ("yyyy-MM-dd HH:mm:ss")
            let thedate = formatter.date(from: String(values[0]))
            artist.date = thedate! as Date
            artist.task     = String(values[1]) as String
            artist.duration = Int(values[2])! as Int
            artist.comment = String(values[3]) as String

            array.append(artist)
        }

    } catch {
        print(error)
    }

    return array
}

func makeCloudRecords(_ array: [ListElement], recordType: String) {

    var records = [CKRecord]()

    for artist in array {

  //      let recordID  = CKRecordID(recordName: "\(artist.name!) - Artist")
        let record    = CKRecord(recordType: recordType)

        record["dot"]   = artist.date as CKRecordValue
        record["task"]  = artist.task as CKRecordValue
        record["duration"]   = artist.duration as CKRecordValue
        record["comment"] = artist.comment as CKRecordValue
        records.append(record)
    }
    
    // operation
    let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
    operation.savePolicy = .allKeys

    operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in

        if let error = operationError {
            // error
            print(error)
        }

        if let saved = savedRecords {
            // print artist.name, or count the array, or whatever..
            print(saved)
        }
    }
    CKContainer.init(identifier: "iCloud.com.pjnorris.Tasker").publicCloudDatabase.add(operation)

}


