//
//  Tasks.swift
//  Matthew
//
//  Created by Paul Norris (PJ) on 01/07/2020.
//  Copyright © 2020 Paul Norris (PJ). All rights reserved.
//

import SwiftUI

struct StopWatchButton : View {
    var actions: [() -> Void]
    var labels: [String]
    var color: Color
    var isPaused: Bool
    
    var body: some View {
        
        return Button(action: {
            if self.isPaused {
                self.actions[0]()
            } else {
                self.actions[1]()
            }
        }) {
            if isPaused {
                ZStack{
                    Rectangle()
                        .fill(self.color)
                        .foregroundColor(Color.white)
                        .padding(.all)
                        .background(self.color)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                        .frame(width: 78,height: 45 )
                    Text(self.labels[0])
                        //     .background(self.color)
                        .foregroundColor(Color.white)
                }
                
            
            } else {
                ZStack {
                    Rectangle()
                        .fill(self.color)
                        .foregroundColor(Color.white)
                        .padding(.all)
                        .background(self.color)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                        .frame(width: 78,height: 45 )
                    Text(self.labels[1])
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}

struct Entry: View {
    @ObservedObject var stopWatch = StopWatch()
    @EnvironmentObject var listElements: ListElements
    
    @State private var newItem = ListElement(date: Date(),task: "", duration: 0, comment: "")
    @State private var showEditTextField = false
    @State private var editedItem = ListElement(date: Date(),task: "", duration: 0, comment: "")
    @State private var showalert = false
    @State private var tasks = ["Morning Routine","Evening Routine","Shower"]
    @State private var taskSelector = 0
    @State private var points = 0
    @State private var weeklyTarget = 20

    
    
    
    
    //Set the initial date
    @State var nextWeek = DateOperation.getTheDate(direction: "reset")
    
    //Colours for Selection Tasks
   init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                //DATE SELECTION BOX
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        .padding(.all)
                        .shadow(radius: 8)
                        .frame(height: 100.0)
                        .background(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/)
                    HStack {
                        Spacer()
                        Button(action: {  self.nextWeek = DateOperation.getTheDate(direction: "backward"); self.fetchdata()}) {
                            Image(systemName: "arrow.left").padding(.trailing, 6.0)
                                .padding(.leading,45)
                        }
                        Text(self.nextWeek)
                            .font(.custom("courier", size: 18))
                        Button(action: { self.nextWeek = DateOperation.getTheDate(direction: "forward"); self.fetchdata()}) {
                            Image(systemName: "arrow.right")
                                .padding(.leading,6)
                        }
                        Spacer()
                        Button(action: { self.nextWeek = DateOperation.getTheDate(direction: "reset")}) { Image(systemName: "arrow.clockwise")
                            .padding(.trailing, 40)
                        }
                    }
                }
                //Date Selector End
                
                //Points Boxes
                ZStack {
                    Rectangle()
                        
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        
                        .shadow(radius: 8)
                        .frame(height: 100)
                        .padding(.all)
                        .background(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        //Points Box
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .padding(.all)
                                .frame(width: 150.0, height: 80)
                                .shadow(radius: 2)
                            VStack {
                                Text("\(points)")
                                    .font(.body)
                                    .foregroundColor(Color.blue)
                                Text("points")
                                    .font(.caption)
                            }
                            
                        }
                        //Points Box End
                        
                        
                        //Hi Box
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .padding(.all)
                                .frame(width: 150.0, height: 80)
                                .shadow(radius: 2)
                            VStack {
                                HStack {
                                    Text("\(points)").font(.body).foregroundColor(Color.blue)
                                    Text("/").font(.body).foregroundColor(Color.black)
                                    Text("\(weeklyTarget)")
                                        .font(.body)
                                        .foregroundColor(Color.blue)
                                }
                                Text("weekly target")
                                    .font(.caption)
                            }
                        }
                        //Hi Box End
                    }
                    
                }
               
                Divider().padding(.horizontal)
                
                VStack(alignment: .leading) {
                Picker(selection: $taskSelector, label: Text("What task?")
                ) {
                    ForEach(0..<tasks.count) { index in
                        Text(self.tasks[index]).tag(index)
                    }
                }.padding(.bottom)
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                //End Picker
                
                // DURATION
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        //.padding(.all)
                        .shadow(radius: 8)
                        .frame(height: 100.0)
                        .background(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/)
                    //Stopwatch
                    HStack {
                        Text(self.stopWatch.stopWatchTime)
                            .font(.custom("courier", size: 30))
                            .padding(.all)
                        //Buttons for Stopwatch
                        StopWatchButton(actions: [self.stopWatch.reset, self.stopWatch.lap],
                                        labels: ["Reset", "Lap"],
                                        color: Color.red,
                                        isPaused: self.stopWatch.isPaused())
                        
                        StopWatchButton(actions: [self.stopWatch.start, self.stopWatch.pause],
                                        labels: ["Start", "Pause"],
                                        color: Color.green,
                                        isPaused: self.stopWatch.isPaused())
                    }
                }
                
                //Display LAPS
                List {
                    ForEach(self.stopWatch.laps, id: \.uuid) { (lapItem) in
                        Text("Lap: \(lapItem.stringTime)")
                    }
                }
                //Comment
                TextField("Add Comment", text: $newItem.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // ADD button
                Button("Add")
                {
                    self.showalert = true
                    self.newItem.date = Date()
                    self.newItem.task = self.tasks[self.taskSelector]
                    self.newItem.duration = self.stopWatch.realstopWatchTime
                }
                    .padding(.all) //end Button Add
                    .actionSheet(isPresented: $showalert, content: {
                        ActionSheet(title: Text("Okay to Submit?"),
                                    message: Text("Task: \(newItem.task) \nComment: \(newItem.comment) \nDuration: \(newItem.duration)"),
                                    buttons: [.default(Text("Submit"))
                                    {
                                        if self.newItem.comment.isEmpty { self.newItem.comment="(no comment)"}
                                            
                                            
                                            let newItem = ListElement(date: self.newItem.date,task: self.newItem.task,duration: self.newItem.duration,comment: self.newItem.comment)
                                            // MARK: - saving to CloudKit
                                            CloudKitHelper.save(item: newItem) { (result) in
                                                switch result {
                                                case .success(let newItem):
                                                    self.listElements.items.insert(newItem, at: 0)
                                                    print("Successfully added item")
                                                    self.stopWatch.pause()
                                                    self.stopWatch.reset()
                                                    self.fetchdata()
                                                    //Request PUSH
                                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                                        if success {
                                                            print("All set!")
                                                        } else if let error = error {
                                                            print(error.localizedDescription)
                                                        }
                                                    }
                                                    
                                                    //Set up Local PUSH notification
                                                    
                                                    let notificationcontent = UNMutableNotificationContent()
                                                    notificationcontent.title = "Task Scheduler"
                                                    notificationcontent.subtitle = "Task has been submitted successfully."
                                                    notificationcontent.sound = UNNotificationSound.default
                                                    // show this notification five seconds from now
                                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                                    
                                                    // choose a random identifier
                                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationcontent, trigger: trigger)
                                                    
                                                    // add our notification request
                                                    UNUserNotificationCenter.current().add(request)
                                                    
                                                case .failure(let err):
                                                    print(err.localizedDescription)
                                                    print("Failed to add item")
                                                    let notificationcontent = UNMutableNotificationContent()
                                                    notificationcontent.title = "Failure"
                                                    notificationcontent.subtitle = "The task failed to add. \(err.localizedDescription)"
                                                    notificationcontent.sound = UNNotificationSound.default
                                                    // show this notification five seconds from now
                                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                                    
                                                    // choose a random identifier
                                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationcontent, trigger: trigger)
                                                    
                                                    // add our notification request
                                                    UNUserNotificationCenter.current().add(request)
                                                }
                                            }
                                            self.newItem = ListElement(date:Date(),task: "", duration: 0, comment: "")
                                        }
                                        
                                        ,.cancel()] )
                        
                    })
                    .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                //End of Button
            }
                .navigationBarTitle("Tasks")  //VSTACK 1
                .padding()
            //.navigationBarItems(
           //     trailing:
          //  Button("Refresh") { self.fetchdata() }
          //  )
            
        } //Navigation View
        
    } //body view
    
    
    
    func fetchdata () {
           
           CloudKitHelper.fetch { (result) in
               switch result {
               case .success(let newItem):
                   self.listElements.items = newItem
                   print("Successfully fetched item")
               case .failure(let err):
                   print(err.localizedDescription)
               }
           }
       }
    } //struct


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Entry().environmentObject(items)
    }
    
}
