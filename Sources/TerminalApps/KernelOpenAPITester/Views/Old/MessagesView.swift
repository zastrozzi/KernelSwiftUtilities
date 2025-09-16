//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal

struct MessagesView: View {
    var formatter: DateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            Text("Logs").bold()
            Text("-----------------")
            ScrollView {
                Button(" ") {
                    
                }
                ForEach(Messager.messages, id: \.id) { msg in
                    HStack {
                        Text("\(msg.value)")
                    }
                }
            }
            
        }
    }
}
