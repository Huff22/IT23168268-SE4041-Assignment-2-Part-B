//
//  PersistenceService.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    private let storageKey = "stillspace_saved_sessions"
    
    private init() {}
    
    func saveSession(_ record: SessionRecord) {
        var currentSessions = getSessions()
        currentSessions.insert(record, at: 0) // Add newest to the top
        
        if let encoded = try? JSONEncoder().encode(currentSessions) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func getSessions() -> [SessionRecord] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // For testing purposes
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
