//
//  MessagesView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI

struct MessagesView: View {
    var body: some View {
        VStack{
            Text("Messages")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 15.0)
            Spacer()
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
