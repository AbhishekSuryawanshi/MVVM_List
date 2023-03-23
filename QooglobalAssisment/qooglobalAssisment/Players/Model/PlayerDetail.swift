//
//  PlayerDetail.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

struct PlayerDetail: Decodable {
    let message: String
    let data: Detail?
}

struct Detail: Decodable {
    let player_photo: String
    let player_name: String
    let player_country: String
    let team_photo: String
    let team_name: String
    let indicators: [IndicatorsDetail]
    let about: String
}

struct IndicatorsDetail: Decodable {
    let key: String
    let value: String
}
