//
//  CreateCafe.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

struct CreateCafe: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("cafes")
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("phone", .string, .required)
            .field("profileImageURL", .string, .required)
            .field("gpsX", .string, .required)
            .field("gpsY", .string, .required)
            .field("kitchens", .string, .required)
            .field("mondayWorkTime", .string, .required)
            .field("thesdayWorkTime", .string, .required)
            .field("wednesdayWorkTime", .string, .required)
            .field("thusdayWorkTime", .string, .required)
            .field("fridayWorkTime", .string, .required)
            .field("saturdayWorkTime", .string, .required)
            .field("sundayWorkTime", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("cafes").delete()
    }
    
}
