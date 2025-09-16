//
//  SwiftUIView.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/03/2025.
//

import SwiftUI

#if os(iOS)
import UIKit
import SafariServices

struct InAppSafariBrowserView: UIViewControllerRepresentable {
    let url: URL
    // We will use this in the future for attribution
//    var configuration: SFSafariViewController.Configuration = .init()
    
    
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<Self>
    ) {
        
    }
}

#Preview {
    InAppSafariBrowserView(url: URL(string: "https://www.google.com")!)
}

#endif
