//
//  ProfileView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import Foundation
import CoreData
import FluidGradient

struct ProfileView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var userSettings = UserSettings.shared
    @State var isProfileTab = true
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "isMainUser == %@", NSNumber(value: true))
    ) var profiles: FetchedResults<Profile>
    @State private var showCopyAlert = false
    @State private var animateGradient = true
    @State private var isPopoverVisible = false
    @State private var viewDynamicHeight : Double = 900.0
    
    func dynamicHeight(){
        let numberOfCharacters = profiles[0].profileDescription?.count ?? 0
        
        
        let jsonString = String(profiles[0].profileRelays ?? "")
        let data = Data(jsonString.utf8)
        let count = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])
            .map { $0.keys.count } ?? 0
        
        //        print("numberOfCharacters = \(numberOfCharacters)")
        //        print("count = \(count)")
        
        let heightByNumberOfCharacters: [Range<Int>: Double] = [
            0..<100: 900.0,
            100..<200: 1000.0,
            200..<300: 1100.0,
            300..<500: 1200.0,
            500..<800: 1400.0
        ]
        viewDynamicHeight = heightByNumberOfCharacters.first { $0.key.contains(numberOfCharacters) }?.value ?? 0
        
        
        let heightByCount: [Range<Int>: Double] = [
            0..<10: 300,
            10..<20: 600,
            20..<30: 800,
            30..<Int.max: 1200
        ]
        viewDynamicHeight += heightByCount.first { $0.key.contains(count) }?.value ?? 0
        
        
        
    }
    
    var bannerView: some View {
        AsyncImage(
            url: URL(string: profiles[0].profileBanner ?? ""),
            content: { image in
                image
                    .resizable()
                    .frame(height: 250)
            },
            placeholder: {
                Image("nostrBanner1")
                    .resizable()
                    .frame(height: 250)
            }
        )
    }
    
    
    var profilePictureView: some View {
        AsyncImage(
            url: URL(string: profiles[0].profilePicture ?? ""),
            content: { image in
                image.resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(CGSize(width: 50, height: 50), contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.black))
            },
            placeholder: {
                Image("nostrProfile1")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(CGSize(width: 50, height: 50), contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.black))
            }
        )
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    bannerView
                    profilePictureView
                        .offset(x: 0, y: -75)
                        .padding(.bottom, -75)
                    
                    List{
                        
                        Section(header: Text("Handle")){
                            Text("@\(profiles[0].profileHandle ?? "")")
                                .font(.body)
                                .fontWeight(.bold)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                        }
                        
                        Section(header: Text("Public Key")){
                            
                            FluidGradient(blobs: [.red, .teal, .indigo],
                                          highlights: [.orange, .red, .indigo],
                                          speed: 0.7,
                                          blur: 0.75)
                            .background(.quaternary)
                            .frame(width: 350, height: 70, alignment: .leading)
                            .mask(
                                Text("\(NostrKey.shared.bech32_pubkey(self.profiles[0].id  ?? "") ?? "")\n\n")
                                    .font(.body)
                                    .frame(width: 350, height: 70, alignment: .leading)
                                    .multilineTextAlignment(.center)
                            )
                            .onTapGesture {
                                UIPasteboard.general.string = self.profiles[0].id
                                self.showCopyAlert = true
                                HapticsManager.shared.hapticNotify(.success)
                            }
                            
                        }
                        .ignoresSafeArea(.all)
                        
                        Section(header: Text("Lightning")){
                            Text((self.profiles[0].profileLud16 != "" ? self.profiles[0].profileLud16 : self.profiles[0].profileLud06) ?? "")
                                .font(.body)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    UIPasteboard.general.string = self.profiles[0].profileLud16
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                        }
                        
                        
                        Section(header: Text("NIP-05")){
                            HStack{
                                Text(self.profiles[0].profileNip05 ?? "")
                                    .font(.body)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIPasteboard.general.string = self.profiles[0].profileNip05
                                self.showCopyAlert = true
                                HapticsManager.shared.hapticNotify(.success)
                            }
                        }
                        
                        Section(header: Text("Website")) {
                            if let website = profiles[0].profileWebsite,
                               let url = URL(string: website),
                               UIApplication.shared.canOpenURL(url) {
                                HStack{
                                    Text(website)
                                        .font(.body)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            } else {
                                HStack{
                                    Text(profiles[0].profileWebsite ?? "")
                                        .font(.body)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    UIPasteboard.general.string = self.profiles[0].profileWebsite
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                            }
                        }
                        
                        
                        
                        Section(header: Text("Description")){
                            Text(profiles[0].profileDescription ?? "")
                                .font(.body)
                                .lineLimit(20)
                                .multilineTextAlignment(.leading)
                                .onTapGesture {
                                    UIPasteboard.general.string = self.profiles[0].profileDescription
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                        }
                        
                        Section(header: Text("Relays")){
                            
                            let jsonString = self.profiles[0].profileRelays ?? ""
                            let data = Data(jsonString.utf8)
                            
                            if let jsonArray = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
                            {
                                ForEach(jsonArray.keys.sorted(), id: \.self) { key in
                                    HStack{
                                        Text("\(key)")
                                            .font(.body)
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                        Spacer()
                                    }
                                    
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        UIPasteboard.general.string = key
                                        self.showCopyAlert = true
                                        HapticsManager.shared.hapticNotify(.success)
                                    }
                                }
                                
                            } else {
                                Text("")
                            }
                            
                        }
                        
                    }
                    .frame(height: viewDynamicHeight)
                }
            }
            .navigationTitle("\(profiles[0].profileName ?? profiles[0].profileHandle ?? "")")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        
                        Button(action: {
                            isPopoverVisible = true
                        }) {
                            Text("Show QR Code")
                            Image(systemName: "qrcode")
                                .resizable()
                        }
                        
                        Button(action: {
                            if let url = URL(string: "nostr://\(NostrKey.shared.bech32_pubkey(profiles[0].id  ?? "") ?? "")") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open Profile in Damus")
                            Image(systemName: "app.connected.to.app.below.fill")
                                .resizable()
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://nostr.band/?q=\(NostrKey.shared.bech32_pubkey(profiles[0].id  ?? "") ?? "")") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open Profile on the web")
                            Image(systemName: "arrow.up.forward.app")
                                .resizable()
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://nostr.directory/p/\(NostrKey.shared.bech32_pubkey(profiles[0].id  ?? "") ?? "")") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Check Profile on the web")
                            Image(systemName: "arrow.up.forward.app")
                                .resizable()
                        }
                        
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 21))
                    }
                }
            }
        }
        //        .edgesIgnoringSafeArea(!isProfileTab ? .all : .init())
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
        .popover(isPresented: $isPopoverVisible) {
            QrCodeView(npubQrCode: NostrKey.shared.bech32_pubkey(profiles[0].id  ?? "") ?? "")
        }
        .onAppear{
            dynamicHeight()
        }
    }
}
