//
//  TaskEntries.swift
//  SwiftUICloudKitDemo
//
//  Created by Paul Norris on 12/07/2020.
//

import SwiftUI
import CloudKit

struct TaskEntries: View {
   @EnvironmentObject var listElements: ListElements
    @State private var newItem = ListElement(date: Date(),task: "", duration: 0, comment: "")
        
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM YYYY, hh:mm.ss"
        
        return formatter
    }()
  

    var body: some View {
        NavigationView {
                VStack {
                                    
                    List {
                        ForEach(listElements.items, id: \.self) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text("\(item.date, formatter: Self.taskDateFormat)")
                                        .foregroundColor(Color.blue)
                                        .font(.callout)
                                    HStack(alignment: .bottom) {
                                        Text("Task:").bold()
                                        .font(.caption)
                                        
                                    Text("\(item.task)  ")
                                        .font(.caption)
                                        
                                        Text("Duration: ").bold()
                                        .font(.caption)

                                        Text("\((item.duration%3600)/60)m \((item.duration)-((item.duration % 3600)/60)*60)s").font(.caption)
                                    }
                                    Text("\(item.comment) ")
                                        .font(.caption)
                                    .italic()
                                    
                                } //VSTACK
                                }
                                                        
                        }  .onDelete(perform: delete)
                    }
            
            
                    
             }.navigationBarTitle("List of Tasks")
            .navigationBarItems(
                leading:
                
               /* Button("Load Sample") {
                    makeCloudRecords(importCSV("convertcsv-3.csv"),recordType: "Items")
                }*/ EditButton(),
                trailing:
                Button("Refresh") //{ self.fetchdata() }
                {
                    self.fetchdata()
                }
                
                
            )
                    .onAppear(perform: fetchdata)
            
        }
        
        }
    
    private func delete(with indexSet: IndexSet) {
        indexSet.forEach {listElements.items.remove(at: $0) }
  //      var recordID = items.recordID
        /*CloudKitHelper.delete(recordID: recordID) { (result) in
                switch result {
                case .success(let recordID):
                    self.listElements.items.removeAll { (listElement) -> Bool in
                        return listElement.recordID == recordID
                    }
                    print("Successfully deleted item")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }*/
        
    }
        
    
    

    private func fetchdata ()  {
        
        CloudKitHelper.fetch() { (result) in
            switch result {
            case .success(let newItem):
                self.listElements.items = newItem
                print("Successfully fetched item")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
struct TaskEntries_Previews: PreviewProvider {
    static var previews: some View {
        TaskEntries()
    }
}
