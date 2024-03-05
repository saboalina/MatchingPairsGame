//
//  Api.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 03.03.2024.
//

import Foundation

struct API {
    func fetchGames(completion: @escaping ([Game]?) -> Void) {
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching themes: \(error)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    completion(games)
                } catch {
                    print("Error decoding themes: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}
