//
//  Home.swift
//  Unspalsh
//
//  Created by Asge Yohannes on 6/5/20.
//  Copyright © 2020 AsgeY. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home : View {
    
    @State var expand = false
    @State var search = ""
    @ObservedObject var RandomImages = getData()
    @State var page = 1
    @State var isSearching = false
    
    var foregroundColor: Color = Color("navTitle1")
    
    var body: some View{
        
        VStack(spacing: 0){
            
            HStack{
                
                // Hiding this view when search bar is expanded...
                
                if !self.expand{
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("UnSplash")
                            .font(.title)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(foregroundColor)
                        
                        Text("Beautiful,Free Photos")
                            .font(.caption)
                            .foregroundColor(foregroundColor)
                    }
                    .foregroundColor(.black)
                }
                
                
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(foregroundColor)
                    .onTapGesture {
                        withAnimation{
                            
                            self.expand = true
                        }
                }
                
                // Displaying Textfield when search bar is expanded...
                
                if self.expand{
                    
                    TextField("Search...", text: self.$search)
        
                    .foregroundColor(foregroundColor)
                    // Displaying Close Button....
                    
                    // Displaying search button when search txt is not empty...
                    
                    if self.search != ""{
                        
                        Button(action: {
                            
                            // Search Content....
                            // deleting all existing data and displaying search data...
                            
                            self.RandomImages.Images.removeAll()
                            
                            self.isSearching = true
                            
                            self.page = 1
                            
                            self.SearchData()
                            
                        }) {
                            
                            Text("Find")
                                .fontWeight(.bold)
                                .foregroundColor(foregroundColor)
                        }
                    }
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.expand = false
                        }
                        
                        self.search = ""
                        
                        if self.isSearching{
                            
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                            // updating home data....
                            self.RandomImages.updateData()
                        }
                        
                    }) {
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(foregroundColor)
                    }
                    .padding(.leading,10)
                }
                
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
            
            if self.RandomImages.Images.isEmpty{
                
                // Data is Loading...
                // or No Data...
                
                Spacer()
                
                if self.RandomImages.noresults{
                    
                    Text("No Results Found")
                    .foregroundColor(foregroundColor)
                }
                else{
                    
                    Indicator()
                }
                
                Spacer()
            }
            else{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    //Collection View...
                    
                    VStack(spacing: 15){
                        
                        ForEach(self.RandomImages.Images,id: \.self){i in
                            
                            VStack(spacing: 20){
                                
                                ForEach(i){j in
                                    
                                    AnimatedImage(url: URL(string: j.urls["regular"]!))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        // padding on both sides 30 and spacing 20 = 50
//                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 310)
                                        .frame(width: 370, height:  600)
                                        .cornerRadius(15)
                                        .modifier(ShadowViewModifier())
                                        .contextMenu {
                                            
                                            // Save Button
                                            
                                            Button(action: {
                                                
                                                // saving Image...
                                                
                                                // Image Quality...
                                                SDWebImageDownloader().downloadImage(with: URL(string: j.urls["regular"]!)) { (image, _, _, _) in
                                                    
                                                    // For this we need permission...
                                                    
                                                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                                }
                                                
                                            }) {
                                                
                                                HStack{
                                                    
                                                    Text("Save")
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "square.and.arrow.down.fill")
                                                }
                                                .foregroundColor(self.foregroundColor)
                                            }
                                    }
                                }
                            }
        
                        }
                        
                        // Load More Button
                        
                        if !self.RandomImages.Images.isEmpty{
                            
                            if self.isSearching && self.search != ""{
                                
                                HStack{
                                    
                                    Text("Page \(self.page)")
                                    .foregroundColor(foregroundColor)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        // Updating Data...
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                        self.SearchData()
                                        
                                    }) {
                                        
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(foregroundColor)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                                
                            else{
                                
                                HStack{
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        // Updating Data...
                                        self.RandomImages.Images.removeAll()
                                        self.RandomImages.updateData()
                                        
                                    }) {
                                        
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(foregroundColor)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
    }
    
    func SearchData(){
        
        let key = "e94756983cb858a4de750ca8816d455eced142ced95b713aa5ea26a0494deb2f"
        // replacing spaces into %20 for query...
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        // updating page every time...
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        self.RandomImages.SearchData(url: url)
    }
}

// Fetching Data....

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
