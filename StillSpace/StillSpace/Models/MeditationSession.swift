//
//  MeditationSession.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import Foundation

enum SessionType: String, Codable {
    case breathing
    case meditation
    case ambience
}

struct MeditationSession: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String
    let type: SessionType
    let duration: TimeInterval // in seconds
    let description: String
}
