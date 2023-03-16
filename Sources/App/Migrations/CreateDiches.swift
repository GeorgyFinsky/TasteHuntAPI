//
//  CreateDiches.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

struct CreateDiches: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("diches")
            .id()
            .field("cafeID", .string, .required)
            .field("name", .string, .required)
            .field("profileImageURL", .string, .required)
            .field("price", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("diches").delete()
    }
    
}
