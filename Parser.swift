//
//  Parser.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation

struct JSONParser {
    
    static func parse<T>(_ data: Data, type: T.Type) throws -> T where T : Decodable {
        
        return try JSONDecoder().decode(type.self, from: data)
        
    }
    
}
