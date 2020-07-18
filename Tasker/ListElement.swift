//
//  ListElement.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 22/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI
import CloudKit
import Foundation

class ListElements: ObservableObject {
    @Published var items: [ListElement] = []
    
}

struct ListElement: Identifiable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var date: Date
    var task: String
    var duration: Int
    var comment: String
}
     



