//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by user on 20.08.2023.
//

import UIKit

final class NetworkService {

    static let shared = NetworkService()
    
    private let imageCache = NSCache<NSString, AnyObject>()
    private init() {}

    private let startUrl = "https://rickandmortyapi.com/api"

    // MARK: - Public

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

    func getDataFrom <T: Decodable> (urlString: String? = nil, completion: @escaping (T?) -> () ) {
        guard let url = URL(string: urlString ?? startUrl) else {
            completion(nil)
            return
        }
        getData(with: url, completion: completion)
    }

    func downloadImageFrom(url: URL, imageView: UIImageView) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            imageView.image = cachedImage
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let imageToCache = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = imageToCache
                        self?.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                    }
                }
            }
        }
    }

    // MARK: - Private

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
                completion(nil)
            }
        }.resume()
    }
}
