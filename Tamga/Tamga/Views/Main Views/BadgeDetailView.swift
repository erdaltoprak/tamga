//
//  BadgeDetailView.swift
//  Tamga
//
//  Created by Erdal Toprak on 06/03/2023.
//

import SwiftUI
import CoreData

struct BadgeDetailView: View {
    
    let badge : Badge
    @State private var showCopyAlert = false
    @FetchRequest(sortDescriptors: []) private var contactsList : FetchedResults<Profile>
    
    var body: some View {
//        NavigationView{
            ScrollView{
                VStack(alignment: .center, spacing: 20){
                    ZStack{
                        AsyncImage(
                            url: URL(string: badge.badgePicture ?? ""),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                            },
                            placeholder: {
                                Image("nostrProfile1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)

                            }
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text(badge.badgeName ?? "")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.horizontal)
                        
                        List {
                            Section("Created by"){
                                HStack{
                                    Text(badge.badgeCreator ?? "")
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    UIPasteboard.general.string = badge.badgeCreator ?? ""
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }

                            }
                            
                            Section("Description"){
                                Text(badge.badgeDescription ?? "")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(height: 600)


                    }
                    
                }

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
            .ignoresSafeArea(.all)
    }
}

//struct BadgeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgeDetailView()
//    }
//}
