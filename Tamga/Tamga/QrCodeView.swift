//
//  QrCodeView.swift
//  NostrID
//
//  Created by Erdal Toprak on 27/02/2023.
//

import Foundation
import SwiftUI


struct QrCodeView: View {
    
    let npubQrCode : String
    
    var body: some View {
        NavigationView{
            HStack{
                VStack{
                    Image(uiImage: UIImage(data: generateQRCode(text: "nostr:\(npubQrCode)" )!)!)
                        .resizable()
                        .frame(width: 300, height: 300)
                    Text(npubQrCode)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 25)
                }
            }
            .navigationTitle("QR Code")
            .edgesIgnoringSafeArea(.all)

        }
    }
}

//struct QrCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        QrCodeView()
//    }
//}
