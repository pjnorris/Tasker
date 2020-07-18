//
//  Settings.swift
//  Matthew
//
//  Created by Paul Norris (PJ) on 01/07/2020.
//  Copyright © 2020 Paul Norris (PJ). All rights reserved.
//

import SwiftUI

struct Settings: View {
 @State private var alerting = false

    var body: some View {
        VStack {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Button("Hello") {
            self.alerting = true
        }
            .actionSheet(isPresented: $alerting, content: {
            ActionSheet(title: Text("Title"),
                  message: Text("Message"),
                  buttons: [.default(Text("Submit")),.cancel()] )
            })
            
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
