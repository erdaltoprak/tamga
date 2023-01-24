//
//  ContactView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI


struct ContactView: View {
    
    @ObservedObject var nostrManager = NostrManager.shared
    @ObservedObject var nostrEvent = NostrEvent.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if nostrEvent.isReady == false {
                    
                    LoadingTimeline()
                }
                
              
                ForEach(nostrEvent.contacts, id: \.id) { contact in
                    HStack(alignment: .top){

                        AsyncImage(
                            url: URL(string: contact.profilePicture!),
                            content: { image in
                                image.resizable()
                                    .frame(maxWidth: 60, maxHeight: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            },
                            placeholder: {
                                Image("nostrProfile1")
                                    .resizable()
                                    .frame(maxWidth: 60, maxHeight: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                            }
                        )
                        

                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Anonymous")
                                .font(.headline)
                            Text("Anonymous")
                                .font(.subheadline)
                            Spacer(minLength: 5)
                            Text(contact.id)
                                .font(.footnote)
                            
                        }
                        
                        
                        Spacer()
                        
                    }
                    
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear(perform: {
                if nostrEvent.isReady == false{
                    nostrManager.setup()
                }
            })
            .redacted(if: nostrEvent.isReady == false)
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.large)
            
            .refreshable {
                let _ = print("REFRESHED VIEW")
                NostrEvent.shared.isReady = false
                NostrManager.shared.release()
                if WebSocketManager.shared.isConnected == false {
                    NostrManager.shared.setup()
                }
            }
        }
    }
    
    
    
    
    struct ContactView_Previews: PreviewProvider {
        static var previews: some View {
            ContactView()
        }
    }
    
    
    
    
}

//extension View {
//    @ViewBuilder
//    func redacted(if condition: @autoclosure () -> Bool) -> some View {
//        redacted(reason: condition() ? .placeholder : [])
//    }
//}
