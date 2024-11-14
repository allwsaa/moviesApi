//
//  ActorDetails.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//

import Foundation
struct ActorDetails: Codable {
    let id: Int
    let name: String
    let biography: String
    let profilePath: String?
    let knownForDepartment: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
    }
}
