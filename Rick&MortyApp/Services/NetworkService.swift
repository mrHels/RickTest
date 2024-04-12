//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by user on 20.08.2023.
//

import Foundation

struct UrlList: Decodable {
    let characters: String?
    let locations: String?
    let episodes: String?
}

struct resultCharacters: Decodable {
    let info: InfoForCharacterData?
    let results: [Person]?
}

struct InfoForCharacterData: Decodable {
    let countCharacters: Int?
    let pages: Int?
}

struct Person: Decodable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let typeCreated: String?
    let gender: String?
    let origin: OriginStruct
    let image: String?
    let episode: [String]?
}

struct OriginStruct: Decodable {
    let name: String?
    let url: String?
}

struct ResultId: Decodable {
    let name: String?
    let type: String?
    let dimension: String?
    let created: String?
}

struct EpisodeRM: Decodable {
    let results: [EpisodeDetail]?
}

struct EpisodeDetail: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
}

class NetworkService {

    static let shared = NetworkService()
    private init() {}

    private let startUrl = "https://rickandmortyapi.com/api"

    private func getData <T:Decodable> (with url: URL, completion: @escaping (T?) -> () ) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let urlList = try JSONDecoder().decode(T.self, from: data)
                completion(urlList)
            } catch let error {
                print(error)
            }
        }.resume()
    }

    func getDataFrom <T: Decodable> (urlString: String? = nil, completion: @escaping (T?) -> () ) {
        guard let url = URL(string: urlString ?? startUrl) else {
            completion(nil)
            return
        }
        getData(with: url, completion: completion)
    }

    func getCharacterList(completion: @escaping (resultCharacters?) -> () ) {
        getDataFrom { [weak self] (urlList: UrlList?) in
            guard let urlString = urlList?.characters, let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            self?.getData(with: url, completion: completion)
        }
    }

    func getEpisodesDetail(completion: @escaping (EpisodeRM?) -> ()) {
        getDataFrom { [weak self] (urlList: UrlList?) in
            guard let urlString = urlList?.episodes, let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            self?.getData(with: url, completion: completion)
        }
    }
}


