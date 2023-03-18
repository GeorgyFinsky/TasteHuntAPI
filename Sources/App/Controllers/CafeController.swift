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
    }
    
//    func isUsernameEnabled(_ req: Request) async throws -> GuestNameExistModel {
//        if let username = try? req.query.get(String.self, at: "username") {
//            let isExist = try await GuestModel.query(on: req.db)
//                .filter(\.$username == username)
//                .first()
//
//            return GuestNameExistModel(isExist: isExist != nil)
//        } else {
//            throw Abort(.badRequest)
//        }
//    }
    
    func createCafeHandler(_ req: Request) async throws -> CafeModel.Public {
        guard let cafeData = try? req.content.decode(CafeImageDTO.self) else {
            throw Abort(.badRequest)
        }
        
        let cafe = CafeModel(
            id: cafeData.id,
            name: cafeData.name,
            password: try Bcrypt.hash(cafeData.password),
            phone: cafeData.password,
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
        
        let storagePath = req.application.directory.workingDirectory + "/Storage/Cafes" + "/\(cafeData.id).jpg"
        
        try await req.fileio.writeFile(.init(data: cafeData.profileImageURL), at: storagePath)
        cafe.profileImageURL = storagePath
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
