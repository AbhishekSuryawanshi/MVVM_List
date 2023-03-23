//
//  Player.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

struct Player: Decodable {
    let message: String
    let data: [PlayerData]
}

struct PlayerData: Decodable {
    let id: String
    let slug: String
    let name: String
    let rating: String
    let positionName: String
    let teamName: String
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug, name, rating,photo
        case positionName = "position_name"
        case teamName = "team_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.name = try container.decode(String.self, forKey: .name)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.positionName = try container.decode(String.self, forKey: .positionName)
        self.teamName = try container.decode(String.self, forKey: .teamName)
        self.photo = try container.decode(String.self, forKey: .photo)
    }
}

extension PlayerData: Comparable {
    static func <(lhs: PlayerData, rhs: PlayerData) -> Bool {
        lhs.rating > rhs.rating
    }
}
