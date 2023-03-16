//
//  CreateVisit.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

struct CreateVisit: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("visits")
            .id()
            .field("guestsID", .string, .required)
            .field("cafeID", .string, .required)
            .field("date", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("visits").delete()
    }
    
}
