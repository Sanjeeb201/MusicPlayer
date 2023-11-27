//
//  APIManager.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import Foundation
import UIKit


struct APIManager {
    static let shared = APIManager()
    
    let BASE_URL_STRING = "https://cms.samespace.com/items/songs"
    let IMAGE_URL = "https://cms.samespace.com/assets/"
    
    func fetchMusics(completion : @escaping (MusicList) -> Void) {
        let url = URL(string: BASE_URL_STRING)!
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if error == nil && data != nil {
                do {
                    let results = try JSONDecoder().decode(MusicList.self, from: data!)
                    print(results.data)
                    completion(results)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
