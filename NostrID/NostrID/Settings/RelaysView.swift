//
//  RelaysView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct RelaysView: View {
    
    @AppStorage(UserDefaultKeys.relay) private var relay: String = UserDefaultKeys.relay
    
    var body: some View {
        
        ZStack{
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0){
                    
                    List{
                        
                        Section("Current Relay"){
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .resizable()
                                    .frame(width: 16, height: 20)
                                TextField("Relay", text: $relay)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Relays")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RelaysView_Previews: PreviewProvider {
    static var previews: some View {
        RelaysView()
    }
}

