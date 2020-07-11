//
//  Data.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Vapor

func load<T: Decodable>(_ fileUrl: URL) -> T {
    
    
    return decodeFile(url: fileUrl)
}

func decodeFile<T: Decodable>(url: URL) -> T {
    let data: Data
    print("Decoding file \(url.absoluteString)")
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Couldn't load file from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(url) as \(T.self):\n\(error)")
    }
    
}



