//
//  ContactDetailView.swift
//  NostrID
//
//  Created by Erdal Toprak on 04/02/2023.
//

import SwiftUI

struct ProfileDetailView: View {
    let profile : Profile
    var isProfileTab : Bool
    @State private var showCopyAlert = false
    @State private var animateGradient = true

    var bannerView: some View {
        AsyncImage(
            url: URL(string: profile.profileBanner ?? ""),
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
            url: URL(string: profile.profilePicture ?? ""),
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
                    Text("\(profile.profileName ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("@\(profile.profileHandle ?? "")\n")
                        .font(.title3)
                    
                    
                    HStack(spacing: 10){
                        Button(action: {
                            if let url = URL(string: "https://nostr.band/?q=\(profile.id!)") {
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
                            if let url = URL(string: "https://nostr.directory/p/\(profile.id!)") {
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
                                    Text("\(profile.id ?? "")\n\n")
                                        .font(.body)
                                        .frame(width: 350, height: 100, alignment: .leading)
                                        .multilineTextAlignment(.center)
                                )
                                .onTapGesture {
                                    UIPasteboard.general.string = self.profile.id
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                            
                            Text(profile.profileDescription ?? "")
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
    
    
    
    
    
    //    struct ContactDetailView_Previews: PreviewProvider {
    //        static var previews: some View {
    //            ContactDetailView(profile: NostrProfile(id: "12345", lastProfileUpdate: 99999, handle: "nostrID", displayName: "nostrID", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", profilePicture: "https://raw.githubusercontent.com/erdaltoprak/nostrid/landing-page/assets/nostrid_icon.png", profileBanner: "https://raw.githubusercontent.com/erdaltoprak/nostrid/landing-page/assets/nostrBanner.jpg"))
    //        }
    //    }
}
