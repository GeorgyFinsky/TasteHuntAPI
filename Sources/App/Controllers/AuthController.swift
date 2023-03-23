//
//  AuthController.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Vapor
import Fluent

struct AuthController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let userGroup = routes.grouped("users")
        userGroup.post(use: createGuestHandler)
        userGroup.get(use: getAllGuestsHandler)
        userGroup.get("login", use: loginUserHandler)
        userGroup.get("username", use: isUsernameEnabled)
        userGroup.put("kitchen", use: addKitchensHandler)
        userGroup.put("image", use: uploadProfileImageHandler)
    }
    
    func isUsernameEnabled(_ req: Request) async throws -> GuestNameExistModel {
        if let username = try? req.query.get(String.self, at: "username") {
            let isExist = try await GuestModel.query(on: req.db)
                .filter(\.$username == username)
                .first()
            
            return GuestNameExistModel(isExist: isExist != nil)
        } else {
            throw Abort(.badRequest)
        }
    }
    
    func createGuestHandler(_ req: Request) async throws -> GuestModel.Public {
        guard let user = try? req.content.decode(GuestModel.self) else {
            throw Abort(
                .custom(
                    code: 480,
                    reasonPhrase: "can not decode to UserModel"
                )
            )
        }
        
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        
        return user.convertToPublic()
    }
    
    func loginUserHandler(_ req: Request) async throws -> GuestTokenModel {
        guard let username = try? req.query.get(String.self, at: "username") else {
            throw Abort(.badRequest)
        }
        guard let password = try? req.query.get(String.self, at: "password") else {
            throw Abort(.badRequest)
        }
        let user = try await GuestModel.query(on: req.db)
            .filter(\.$username == username)
            .first()
        
        let isVerify = try user?.verify(password: password)
        
        if isVerify != nil {
            return GuestTokenModel(token: String((user?.$id.value)!))
        } else {
            throw Abort(.unauthorized)
        }
    }
    
    func addKitchensHandler(_ req: Request) async throws -> GuestModel.Public {
        guard let id = req.headers.first(name: "AccessToken") else {
            throw Abort(.badRequest)
        }
        guard let kitchens = try? req.content.decode(StringDecoder.self) else {
            throw Abort(.badRequest)
        }
        guard let guest = try await GuestModel.find(UUID(id), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guest.kitchens = kitchens.value
        try await guest.save(on: req.db)
        
        return guest.convertToPublic()
    }
    
    func uploadProfileImageHandler(_ req: Request) async throws -> GuestModel.Public {
        guard let id = req.headers.first(name: "AccessToken") else {
            throw Abort(.badRequest)
        }
        guard let imageData = try? req.content.decode(GuestImageDTO.self) else {
            throw Abort(.badRequest)
        }
        guard let guest = try await GuestModel.find(UUID(id), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let fileName = "\(id).jpg"
        let storagePath = req.application.directory.publicDirectory + fileName
        
        try await req.fileio.writeFile(.init(data: imageData.profileImageURL), at: storagePath)
        guest.profileImageURL = "http://localhost:8080/" + fileName
        try await guest.save(on: req.db)
        
        return guest.convertToPublic()
    }
    
    func getAllGuestsHandler(_ req: Request) async throws -> [GuestModel] {
        let guests = try await GuestModel.query(on: req.db).all()
        
        return guests
    }
    
}

struct GuestTokenModel: Content {
    var token: String
}

struct GuestNameExistModel: Content {
    var isExist: Bool
}

struct GuestImageDTO: Content {
    var profileImageURL: Data
}

struct StringDecoder: Content {
    var value: String
}
