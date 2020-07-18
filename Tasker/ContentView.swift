//
//  ContentView.swift
//  Tasker
//
//  Created by Paul Norris on 18/07/2020.
//  Copyright © 2020 Paul Norris. All rights reserved.
//

import SwiftUI
var items = ListElements()

struct ContentView: View {
    @State private var selection = 1
    @EnvironmentObject var listElements: ListElements
    var body: some View {
    
        TabView(selection: $selection){
            Entry().environmentObject(items)
                .onTapGesture { self.selection = 1 }
                .tabItem {
                        Image(systemName: "text.badge.plus")
                        Text("Entry")
                }.tag(1)
            TaskEntries()
                .onTapGesture { self.selection = 2 }
                .tabItem {
                        Image(systemName: "doc.plaintext")
                        Text("Entires")
                }.tag(2)
            Reports()
                .onTapGesture { self.selection = 3 }
                .tabItem {
                        Image(systemName: "doc.plaintext")
                        Text("Reports")
                }.tag(3)
            Settings()
                .onTapGesture { self.selection = 4 }
                .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                }.tag(4)
        }//.onAppear(perform: self.fetchdata)
    }
    




    
 func fetchdata()  {

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


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
