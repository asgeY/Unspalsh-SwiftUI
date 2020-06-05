//
//  ShadowModifier.swift
//  Unspalsh
//
//  Created by Asge Yohannes on 6/5/20.
//  Copyright © 2020 AsgeY. All rights reserved.
//

import SwiftUI


struct ShadowModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 12)
            .shadow(color: Color.gray.opacity(0.1), radius: 1, x: 0, y: 1)
    }
    
}

struct ShadowViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .modifier(ShadowModifier())
        .overlay(RoundedRectangle(cornerRadius: 16)
        .stroke(Color.gray,
                lineWidth: 0.05))
    }
    
}
