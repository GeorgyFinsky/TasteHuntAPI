//
//  DichesModel.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

final class DichesModel: Model, Content {
    static let schema = "diches"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "cafeID")
    var cafeID: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "profileImageURL")
    var profileImageURL: String
    
    @Field(key: "price")
    var price: String
    
    final class Public: Content {
        var name: String
        var profileImageURL: String
        var price: String?
        
        init(
            name: String,
            profileImageURL: String,
            price: String
        ) {
            self.name = name
            self.profileImageURL = profileImageURL
            self.price = price
        }
        
    }
    
    init() {}
    
    init(
        id: UUID? = nil,
        cafeID: String,
        name: String,
        profileImageURL: String,
        price: String
    ) {
        self.id = id
        self.cafeID = cafeID
        self.name = name
        self.profileImageURL = profileImageURL
        self.price = price
    }
    
}

extension DichesModel {
    
    func convertToPublic() -> DichesModel.Public {
        let pub = DichesModel.Public(
            name: self.name,
            profileImageURL: self.profileImageURL,
            price: self.price
        )
        return pub
    }
    
}
