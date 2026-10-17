//
//  AmbientEnvironment.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import Foundation

struct AmbientEnvironment: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let imageName: String
    let audioName: String
    let videoName: String // New property
    let themeColorHex: String
}
