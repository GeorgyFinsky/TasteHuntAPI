//
//  GuestModel.swift
//  
//
//  Created by Georgy Finsky on 20.02.23.
//

import Fluent
import Vapor

final class GuestModel: Model, Content {    
    static let schema = "guests"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "profileImageURL")
    var profileImageURL: String?
    
    @Field(key: "kitchens")
    var kitchens: String?
    
    final class Public: Content {
        var username: String
        var profileImageURL: String?
        var kitchens: String?
        
        init(
            username: String,
            profileImageURL: String? = nil,
            kitchens: String? = nil
        ) {
            self.username = username
            self.profileImageURL = profileImageURL
            self.kitchens = kitchens
        }
        
    }
    
    init() {}
    
    init(
        id: UUID? = nil,
        username: String,
        password: String,
        profileImageURL: String? = nil,
        kitchens: String? = nil
    ) {
        self.id = id
        self.username = username
        self.password = password
        self.profileImageURL = profileImageURL
        self.kitchens = kitchens
    }
    
}

extension GuestModel: ModelAuthenticatable {
    
    static let usernameKey = \GuestModel.$username
    static var passwordHashKey = \GuestModel.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
}

extension GuestModel {
    
    func convertToPublic() -> GuestModel.Public {
        let pub = GuestModel.Public(
            username: self.username,
            profileImageURL: self.profileImageURL
        )
        return pub
    }
    
}
