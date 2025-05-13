//
//  FriendsModel.swift
//  FriendsApp
//
//  Created by Chirag Dodia on 4/19/25.
//

import Foundation

class FriendsModel: Codable {
    private(set) var allTheFriends: [[String]] = []

    init() {
        if !loadFromDisk() {
            allTheFriends = [
                ["Billie",  "Holiday",  "strange@fruit.jazz"],
                ["Jon",     "Hendricks","cotton@tail.jazz"],
                ["Carmen",  "McRae",    "round@midnight.jazz"],
                ["Johnny",  "Hartman",  "lush@life.jazz"]
            ]
            sortFriends()
        }
    }
    
    // MARK: - Friend Operations
    func numberOfFriends() -> Int {
        return allTheFriends.count
    }
    func addFriend(firstName: String, lastName: String, email: String) {
        allTheFriends.append([firstName, lastName, email])
        sortFriends()
    }
    private func sortFriends() {
        allTheFriends.sort { a, b in
            let aLast  = a[1]
            let bLast  = b[1]
            if aLast.caseInsensitiveCompare(bLast) == .orderedSame {
                return a[0].caseInsensitiveCompare(b[0]) == .orderedAscending
            }
            return aLast.caseInsensitiveCompare(bLast) == .orderedAscending
        }
    }
    private static var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("FriendsData.plist")
    }
    func saveToDisk() {
        do {
            let data = try PropertyListEncoder().encode(self)
            try data.write(to: Self.fileURL)
        } catch {
            print("Failed to save friends data: \(error)")
        }
    }
    @discardableResult
    func loadFromDisk() -> Bool {
        let url = Self.fileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return false
        }
        do {
            let data = try Data(contentsOf: url)
            let saved = try PropertyListDecoder().decode(FriendsModel.self, from: data)
            self.allTheFriends = saved.allTheFriends
            sortFriends()
            return true
        } catch {
            print("Failed to load friends data: \(error)")
            return false
        }
    }
}
