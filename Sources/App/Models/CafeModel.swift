//
//  CafeModel.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

final class CafeModel: Model, Content {
    static let schema = "cafes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "profileImageURL")
    var profileImageURL: String
    
    @Field(key: "gpsX")
    var gpsX: String
    
    @Field(key: "gpsY")
    var gpsY: String
    
    @Field(key: "kitchens")
    var kitchens: String
    
    @Field(key: "mondayWorkTime")
    var mondayWorkTime: String
    
    @Field(key: "thesdayWorkTime")
    var thesdayWorkTime: String
    
    @Field(key: "wednesdayWorkTime")
    var wednesdayWorkTime: String
    
    @Field(key: "thusdayWorkTime")
    var thusdayWorkTime: String
    
    @Field(key: "fridayWorkTime")
    var fridayWorkTime: String
    
    @Field(key: "saturdayWorkTime")
    var saturdayWorkTime: String
    
    @Field(key: "sundayWorkTime")
    var sundayWorkTime: String
    
    final class Public: Content {
        var id: UUID
        var name: String
        var phone: String
        var profileImageURL: String
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
        
        init(id: UUID,
             name: String,
             phone: String,
             profileImageURL: String,
             gpsX: String,
             gpsY: String,
             kitchens: String,
             mondayWorkTime: String,
             thesdayWorkTime: String,
             wednesdayWorkTime: String,
             thusdayWorkTime: String,
             fridayWorkTime: String,
             saturdayWorkTime: String,
             sundayWorkTime: String
        ) {
            self.id = id
            self.name = name
            self.phone = phone
            self.profileImageURL = profileImageURL
            self.gpsX = gpsX
            self.gpsY = gpsY
            self.kitchens = kitchens
            self.mondayWorkTime = mondayWorkTime
            self.thesdayWorkTime = thesdayWorkTime
            self.wednesdayWorkTime = wednesdayWorkTime
            self.thusdayWorkTime = thusdayWorkTime
            self.fridayWorkTime = fridayWorkTime
            self.saturdayWorkTime = saturdayWorkTime
            self.sundayWorkTime = sundayWorkTime
        }
        
    }
    
    init() {}
    
    init(id: UUID,
         name: String,
         password: String,
         phone: String,
         profileImageURL: String,
         gpsX: String,
         gpsY: String,
         kitchens: String,
         mondayWorkTime: String,
         thesdayWorkTime: String,
         wednesdayWorkTime: String,
         thusdayWorkTime: String,
         fridayWorkTime: String,
         saturdayWorkTime: String,
         sundayWorkTime: String
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.password = password
        self.profileImageURL = profileImageURL
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.kitchens = kitchens
        self.mondayWorkTime = mondayWorkTime
        self.thesdayWorkTime = thesdayWorkTime
        self.wednesdayWorkTime = wednesdayWorkTime
        self.thusdayWorkTime = thusdayWorkTime
        self.fridayWorkTime = fridayWorkTime
        self.saturdayWorkTime = saturdayWorkTime
        self.sundayWorkTime = sundayWorkTime
    }
    
}

extension CafeModel {
    
    func convertToPublic() -> CafeModel.Public {
        let pub = CafeModel.Public(
            id: self.id!,
            name: self.name,
            phone: self.phone,
            profileImageURL: self.profileImageURL,
            gpsX: self.gpsX,
            gpsY: self.gpsY,
            kitchens: self.kitchens,
            mondayWorkTime: self.mondayWorkTime,
            thesdayWorkTime: self.thesdayWorkTime,
            wednesdayWorkTime: self.wednesdayWorkTime,
            thusdayWorkTime: self.thesdayWorkTime,
            fridayWorkTime: self.fridayWorkTime,
            saturdayWorkTime: self.saturdayWorkTime,
            sundayWorkTime: self.saturdayWorkTime
        )
        return pub
    }
    
}

extension CafeModel: ModelAuthenticatable {
    
    static let usernameKey = \CafeModel.$name
    static var passwordHashKey = \CafeModel.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
}
