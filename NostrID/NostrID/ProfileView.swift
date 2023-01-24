//
//  ProfileView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI


struct ProfileView: View {
    @AppStorage(UserDefaultKeys.publicKey) var publicKey: String?
    @ObservedObject var nostrProfile = NostrEvent.shared
    
    
    var bannerView: some View {
        AsyncImage(
            url: URL(string: nostrProfile.profile.profileBanner ?? ""),
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
            url: URL(string: nostrProfile.profile.profilePicture ?? ""),
            content: { image in
                image.resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(CGSize(width: 50, height: 50), contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
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
                        Text("\(nostrProfile.profile.displayName ?? "")")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("@\(nostrProfile.profile.handle ?? "")\n")
                            .font(.title3)
                        
                        Text("\(nostrProfile.profile.id)\n\n")
                            .font(.footnote)
                            
                        
                        Text(nostrProfile.profile.description ?? "")
                            .font(.body)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .redacted(if: nostrProfile.isReady == false)
                    
                    Spacer()
                    
                }
            }
            .refreshable {
                let _ = print("REFRESHED VIEW")
                NostrEvent.shared.isReady = false
                NostrManager.shared.release()
                if WebSocketManager.shared.isConnected == false {
                    NostrManager.shared.setup()
                }
            }
            .navigationTitle("Profile")
            
        }
    }
    
    
    
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
}

