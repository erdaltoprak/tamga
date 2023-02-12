//
//  ProfileView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import CoreData

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
    
    var bannerView: some View {
        AsyncImage(
            url: URL(string: profiles[0].profileBanner ?? ""),
            content: { image in
                image.resizable()
                    .frame(maxWidth: .infinity, maxHeight: 200)
            },
            placeholder: {
                Image("nostrBanner1")
                    .resizable()
                    .aspectRatio(UIImage(named: "nostrBanner1")!.size, contentMode: .fill)
                    .frame(maxHeight:300)
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
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .background(Circle().foregroundColor(Color.black))
                    .shadow(radius: 10)
            },
            placeholder: {
                Image("nostrProfile1")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(CGSize(width: 50, height: 50), contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            }
        )
    }
    
    
    var body: some View {
        ScrollView{
            VStack{
                bannerView
                profilePictureView
                    .offset(x: 0, y: -75)
                    .padding(.bottom, -75)
                
                VStack(alignment: .center) {
                    Text("\(profiles[0].profileName ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("@\(profiles[0].profileHandle ?? "")\n")
                        .font(.title3)
                    
                    
                    HStack(spacing: 10){
                        Button(action: {
                            if let url = URL(string: "https://nostr.band/?q=\(profiles[0].id!)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("See profile")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://nostr.directory/p/\(profiles[0].id!)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Check profile")   
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                    }
                    .padding(.bottom)
                    
                    HStack{
                        VStack{
                            LinearGradient(colors: [.purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .hueRotation(.degrees(animateGradient ? 45 : 0))
                                .frame(width: 350, height: 100, alignment: .leading)
                                .mask(
                                    Text("\(profiles[0].id ?? "")\n\n")
                                        .font(.body)
                                        .frame(width: 350, height: 100, alignment: .leading)
                                        .multilineTextAlignment(.center)
                                )
                                .onTapGesture {
                                    UIPasteboard.general.string = self.profiles[0].id
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                            
                            Text(profiles[0].profileDescription ?? "")
                                .font(.body)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(!isProfileTab ? .all : .init())
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
}
