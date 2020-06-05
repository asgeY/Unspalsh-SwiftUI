//
//  Photo.swift
//  Unspalsh
//
//  Created by Asge Yohannes on 6/5/20.
//  Copyright © 2020 Balaji. All rights reserved.
//

import SwiftUI


struct Photo : Identifiable,Decodable,Hashable{
    
    var id : String
    var urls : [String : String]
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
        
    }
}

// differnt model for search....

struct SearchPhoto : Decodable{

    var results : [Photo]
}
