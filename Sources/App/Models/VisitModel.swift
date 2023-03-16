//
//  VisitModel.swift
//  
//
//  Created by Georgy Finsky on 14.03.23.
//

import Fluent
import Vapor

final class VisitModel: Model, Content {
    static let schema = "visits"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "guestsID")
    var guestsID: String
    
    @Field(key: "cafeID")
    var cafeID: String
    
    @Field(key: "date")
    var date: String
    
    init() {}
    
    init(
        id: UUID? = nil,
        guestsID: String,
        cafeID: String,
        date: String
    ) {
        self.id = id
        self.guestsID = guestsID
        self.cafeID = cafeID
        self.date = date
    }
    
}
