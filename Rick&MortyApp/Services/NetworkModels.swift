//
//  NetworkModels.swift
//  Rick&MortyApp
//
//  Created by user on 15.04.2024.
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
