//
//  ClassData.swift
//  Unspalsh
//
//  Created by Asge Yohannes on 6/5/20.
//  Copyright © 2020 AsgeY. All rights reserved.
//

import SwiftUI

class getData : ObservableObject{
    
    // Going to Create Collection View.....
    // Thats Why 2d Array...
    @Published var Images : [[Photo]] = []
    @Published var noresults = false
    
    init() {
        
        // Intial Data...
        updateData()
    }
    
    func updateData(){
        
        self.noresults = false
        
        let key = "e94756983cb858a4de750ca8816d455eced142ced95b713aa5ea26a0494deb2f"
        let url = "https://api.unsplash.com/photos/random/?count=100&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            // JSON decoding...
            
            do{
                
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                
                // going to create collection view each row has two views...
                
                for i in stride(from: 0, to: json.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2{
                        
                        // Index out bound ....
                        
                        if j < json.count{
                            
                        
                            ArrayData.append(json[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch{
                
                print(error.localizedDescription)
            }
            
        }
        .resume()
    }
    
    func SearchData(url: String){
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            // JSON decoding...
            
            do{
                
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                
                if json.results.isEmpty{
                    
                    self.noresults = true
                }
                else{
                    
                    self.noresults = false
                }
                
                // going to create collection view each row has two views...
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2{
                        
                        // Index out bound ....
                        
                        if j < json.results.count{
                            
                        
                            ArrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
        }
        .resume()
    }
}
