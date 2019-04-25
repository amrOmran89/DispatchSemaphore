//
//  ViewController.swift
//  Simaphore
//
//  Created by Amr Omran on 04/25/2019.
//  Copyright © 2019 Amr Omran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
    }
    
    
    func fetchData() {
        var breedId: String?
        var imageURL: String?
        
        do {
            let data: [Breed]? = try NetworkManager.shared.getRequestArray(urlString: URLs.breeds)
            breedId = data?.first?.id
            print(breedId as Any)
        } catch let error {
            print(error)
        }
        
        do {
            guard let breedId = breedId else { return }
            let query = URLQueryItem(name: "breed_id", value: breedId)
            let data: [ImageURL]? = try NetworkManager.shared.getRequestArray(urlString: URLs.imageSearch, query: [query])
            imageURL = data?.first?.url
            print(imageURL as Any)
        } catch let error {
            print(error)
        }
        
        do {
            guard let imageURL = imageURL else { return }
            let image = try NetworkManager.shared.loadImage(urlString: imageURL)
            print(image as Any)
        } catch let error {
            print(error)
        }
    }
}

