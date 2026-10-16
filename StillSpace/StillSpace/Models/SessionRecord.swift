//
//  SessionRecord.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import Foundation

struct SessionRecord: Identifiable, Codable {
    var id = UUID()
    let sessionName: String
    let type: SessionType
    let durationCompleted: TimeInterval
    let completionDate: Date
}
