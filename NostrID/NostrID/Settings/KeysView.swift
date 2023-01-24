//
//  KeysView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import UIKit



struct KeysView: View {
    
    
    @AppStorage(UserDefaultKeys.publicKey) var publicKey: String?
    @State private var showCopyAlert = false
    
    var body: some View {
        ZStack{
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0){
                    
                    List{
                        
                        Section("Public key"){
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Hex : \(publicKey ?? "empty")")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIPasteboard.general.string = self.publicKey
                                self.showCopyAlert = true
                                hapticNotify(.success)
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Npub : Coming Soon...")
                            }
                        }
                        
                        
                        Section("Private key"){
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "key")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                Text("Hex : Coming Soon...")
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "key")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                Text("Nsec : Coming Soon...")
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Keys")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(GroupedListStyle())
        }
        .overlay{
            if showCopyAlert{
                CheckmarkPopover()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.spring().delay(1)) {
                                self.showCopyAlert = false
                            }
                        }
                    }
            }
        }
    }
    
    struct KeysView_Previews: PreviewProvider {
        static var previews: some View {
            KeysView()
        }
    }
}

