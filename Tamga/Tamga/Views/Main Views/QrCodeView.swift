//
//  QrCodeView.swift
//  Tamga
//
//  Created by Erdal Toprak on 03/03/2023.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QrCodeImage {
    let context = CIContext()

    func generateQRCode(from text: String) -> UIImage {
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data = Data(text.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 20, y: 20)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let image = context.createCGImage(
                outputImage,
                from: outputImage.extent) {
                qrImage = UIImage(cgImage: image)
            }
        }
        return qrImage
    }
}



struct QrCodeView: View {
    
    let key : String
    var qrCodeImage = QrCodeImage()
    @State private var showCopyAlert = false
    
    var body: some View {
        NavigationView{
            HStack{
                VStack{
                    Image(uiImage: qrCodeImage.generateQRCode(from: "nostr:\(key)" ))
                        .resizable()
                        .frame(width: 300, height: 300)
                    Text(key)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 25)
                }
            }
            .onTapGesture {
                UIPasteboard.general.string = key
                self.showCopyAlert = true
                HapticsManager.shared.hapticNotify(.success)
            }
            .navigationTitle("QR Code")
            .edgesIgnoringSafeArea(.all)
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
}
