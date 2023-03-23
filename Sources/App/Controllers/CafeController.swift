//
//  CafeController.swift
//  
//
//  Created by Georgy Finsky on 16.03.23.
//

import Vapor
import Fluent

struct CafeController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let cafeGroup = routes.grouped("cafes")
        cafeGroup.post(use: createCafeHandler)
        cafeGroup.get(use: getAllCafesHandler)
        cafeGroup.get("login", use: loginCafeHandler)
        cafeGroup.get("current", use: getCafeHandler)
    }
    
    func createCafeHandler(_ req: Request) async throws -> CafeModel.Public {
        guard let cafeData = try? req.content.decode(CafeImageDTO.self) else {
            throw Abort(.badRequest)
        }
        
        let cafe = CafeModel(
            id: cafeData.id,
            name: cafeData.name,
            password: try Bcrypt.hash(cafeData.password),
            phone: cafeData.phone,
            profileImageURL: "",
            gpsX: cafeData.gpsX,
            gpsY: cafeData.gpsY,
            kitchens: cafeData.kitchens,
            mondayWorkTime: cafeData.mondayWorkTime,
            thesdayWorkTime: cafeData.thesdayWorkTime,
            wednesdayWorkTime: cafeData.wednesdayWorkTime,
            thusdayWorkTime: cafeData.thusdayWorkTime,
            fridayWorkTime: cafeData.fridayWorkTime,
            saturdayWorkTime: cafeData.saturdayWorkTime,
            sundayWorkTime: cafeData.saturdayWorkTime
        )
        
        let fileName = "\(cafeData.id).jpg"
        let storagePath = req.application.directory.publicDirectory + fileName
        
        try await req.fileio.writeFile(.init(data: cafeData.profileImageURL), at: storagePath)
        cafe.profileImageURL = "http://localhost:8080/" + fileName
        try await cafe.save(on: req.db)
        return cafe.convertToPublic()
    }
    
    func loginCafeHandler(_ req: Request) async throws -> String {
        guard let name = try? req.query.get(String.self, at: "name") else {
            throw Abort(.badRequest)
        }
        guard let password = try? req.query.get(String.self, at: "password") else {
            throw Abort(.badRequest)
        }
        let cafe = try await CafeModel.query(on: req.db)
            .filter(\.$name == name)
            .first()
        
        let isVerify = try cafe?.verify(password: password)
        
        if isVerify != nil {
            return String((cafe?.$id.value)!)
        } else {
            throw Abort(.unauthorized)
        }
    }
    
    func getCafeHandler(_ req: Request) async throws -> CafeModel.Public {
        guard let id = try? req.query.get(String.self, at: "cafeID") else {
            throw Abort(.badRequest)
        }
        guard let cafe = try await CafeModel.find(UUID(id), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return cafe.convertToPublic()
    }
    
    func getAllCafesHandler(_ req: Request) async throws -> [CafeModel.Public] {
        let cafes = try await CafeModel.query(on: req.db).all()
        
        let publicCafes = cafes.map({ $0.convertToPublic() })
        return publicCafes
    }
    
}

struct CafeImageDTO: Content {
    var id: UUID
    var name: String
    var phone: String
    var password: String
    var profileImageURL: Data
    var gpsX: String
    var gpsY: String
    var kitchens: String
    var mondayWorkTime: String
    var thesdayWorkTime: String
    var wednesdayWorkTime: String
    var thusdayWorkTime: String
    var fridayWorkTime: String
    var saturdayWorkTime: String
    var sundayWorkTime: String
}
