//
//  Hands.swift
//  Matthew
//
//  Created by Paul Norris (PJ) on 01/07/2020.
//  Copyright © 2020 Paul Norris (PJ). All rights reserved.
//

import SwiftUI
import UIKit


struct Hands: View {
    @State private var favoriteColor = 0
    var colors = ["Red", "Green", "Blue"]
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    var body: some View {
        VStack {
            Picker(selection: $favoriteColor, label: Text("What is your favorite color?")) {
                ForEach(0..<colors.count) { index in
                    Text(self.colors[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            
            

            Text("Value: \(colors[favoriteColor])")
        }
    }
}



struct Hands_Previews: PreviewProvider {
    static var previews: some View {
        Hands()
    }
}
