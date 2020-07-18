//
//  Reports.swift
//  Matthew
//
//  Created by Paul Norris (PJ) on 01/07/2020.
//  Copyright © 2020 Paul Norris (PJ). All rights reserved.
//

import SwiftUI
import UIKit
struct Reports: View {
    @State private var favoriteColor = "Red"
    @State var editingFlag = false
    var body: some View {
        VStack {
            
            Spacer()
            Text("Picker Test")
            Spacer()
            Picker(selection: $favoriteColor, label: Text("What is your favorite color?")) {
                Text("Red").tag("Red")
                Text("Green").tag("Green")
                Text("Blue").tag("Blue")
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
                
            //    print("tap \(self.favoriteColor)")
            
            
            Text("Value: \(favoriteColor)").navigationBarTitle("Reports")
            Spacer()
        }
    }
    
}



struct Reports_Previews: PreviewProvider {
    static var previews: some View {
        Reports()
    }
}
