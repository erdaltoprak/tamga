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
        NavigationView{
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
                        
                        Text("\(profiles[0].id ?? "")\n\n")
                            .font(.footnote)
                        
                        Text(profiles[0].profileDescription ?? "")
                            .font(.body)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                    
                }
            }
            .edgesIgnoringSafeArea(!isProfileTab ? .all : .init())
            .navigationTitle("Profile")
        }

    }
    
}
