//
//  Model.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct GitHubRoot: Codable {
    var items: [Items]
}

struct Items: Codable {
    var id: Int
    var name: String
    var fullname: String
    var owner: Owner
    var htmlUrl: String
    var description: String?
    var language: String?
    var forks: Int
    var openIssues: Int
    var watchers: Int
    var score: Double
    
    enum CodingKeys: String, CodingKey {
        case fullname = "full_name"
        case htmlUrl = "html_url"
        case openIssues = "open_issues"
        case name,owner,description,language,forks,watchers,score,id
    }
}

struct Owner: Codable {
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
