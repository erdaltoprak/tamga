//
//  RelaysView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct RelayView: View{
    @ObservedObject var oneRelay : Relay
    var body: some View {
        HStack{
            switch oneRelay.connectionState as Int{
            case 1:
                Text("🔴")
            case 2:
                Text("🟠")
            case 3:
                Text("🟢")
            default:
                Text("🔴")
            }
//            Text(oneRelay.connectionState ? "🟢" : "🔴")
            Text("\(oneRelay.url)")
        }
    }
}


struct RelaysView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @ObservedObject var relayManager = NostrRelayManager.shared
    @State private var isAddingRelay = false
    @State private var newRelayURL = ""
    
    var body: some View {
        VStack{
            List{
                ForEach(relayManager.relaysList, id: \.id) { relay in
                    RelayView(oneRelay: relay)
                }
//                .onDelete { indices in
//                    self.relayManager.deleteRelay(at: indices)
//                }
                
                
                Text("nostr.band is an event archiver/browser that allows this app to pull the latest contacts and profile across the most popular relays.")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        let url = URL(string: userSettings.nostrband)
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                
            }
            
        }
        .navigationTitle("Relays")
//        .navigationBarItems(trailing: Button(action: {
//            self.isAddingRelay = true
//        }) {
//            Image(systemName: "plus")
//        })
//
//        .sheet(isPresented: $isAddingRelay) {
//            NavigationView{
//                VStack(alignment: .center, spacing: 16) {
//                    Text("You can add a relay below, it must start with wss://")
//                        .font(.system(size: 16))
//                    TextField("Relay URL", text: self.$newRelayURL)
//                        .padding()
//                        .background(.gray, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                    Button(action: {
//                        let newRelay = Relay(url: URL(string: self.newRelayURL)!)
//                        self.relayManager.addDefaultRelay(newRelayURL)
//                        self.relayManager.relaysList.append(newRelay)
//                        self.isAddingRelay = false
//                        HapticsManager.shared.hapticNotify(.success)
//                        newRelayURL = ""
//                    }) {
//                        Text("Save")
//                    }
//                    .font(.system(size: 20, weight: .bold, design: .rounded))
//                    .frame(width: 150, height: 50)
//                    .foregroundColor(newRelayURL.isEmpty ? Color.white : Color.black)
//                    .background(newRelayURL.isEmpty ? Color.red : Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    .offset(y: 50)
//                    .transition(.scale.combined(with: .opacity))
//                    .disabled(newRelayURL.isEmpty)
//                    .onTapGesture {
//                        if newRelayURL.isEmpty {
//                            HapticsManager.shared.hapticNotify(.error)
//                        }
//                    }
//
//                    Button(role: .destructive, action: {
//                        self.isAddingRelay = false
//                        HapticsManager.shared.hapticNotify(.warning)
//                    }) {
//                        Text("Cancel")
//                    }
//                    .font(.system(size: 20, weight: .bold, design: .rounded))
//                    .frame(width: 150, height: 50)
//                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    .offset(y: 50)
//                    .transition(.scale.combined(with: .opacity))
//                }
//                .padding(.horizontal)
//                .navigationTitle("Add Relay ⚡️")
//            }
//
//        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RelaysView()
    }
}

