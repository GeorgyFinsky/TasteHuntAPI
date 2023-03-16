//
//  CreareGuest.swift
//  
//
//  Created by Georgy Finsky on 15.03.23.
//

import Fluent
import Vapor

struct CreareGuest: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("guests")
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("profileImageURL", .string)
            .field("kitchens", .string)
            .field("visits", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("guests").delete()
    }
    
}
