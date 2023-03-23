//
//  DichesController.swift
//  
//
//  Created by Georgy Finsky on 23.03.23.
//

import Vapor
import Fluent

struct DichesController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let dichesGroup = routes.grouped("diches")
        dichesGroup.get(use: getCafeDiches)
        dichesGroup.post(use: createDichHandler)
    }
    
    func createDichHandler(_ req: Request) async throws -> DichesModel {
        guard let dichData = try? req.content.decode(DichImageDTO.self) else {
            throw Abort(.badRequest)
        }
        
        var dich = DichesModel(
            id: dichData.id,
            cafeID: dichData.cafeID,
            name: dichData.name,
            profileImageURL: "",
            price: dichData.price
        )
        
        let fileName = "\(dichData.id).jpg"
        let storagePath = req.application.directory.publicDirectory + fileName
        
        try await req.fileio.writeFile(.init(data: dichData.profileImageURL), at: storagePath)
        dich.profileImageURL = "http://localhost:8080/" + fileName
        try await dich.save(on: req.db)
        
        return dich
    }
    
    private func getCafeDiches(_ req: Request) async throws -> [DichesModel] {
        guard let id = try? req.query.get(String.self, at: "cafeID") else {
            throw Abort(.badRequest)
        }
        
        let diches = try await DichesModel.query(on: req.db).all()
        var cafeDiches = [DichesModel]()
        
        diches.forEach { dich in
            if dich.cafeID == id {
                cafeDiches.append(dich)
            }
        }
        return cafeDiches
    }
    
}

struct DichImageDTO: Content {
    var id: UUID
    var cafeID: String
    var name: String
    var profileImageURL: Data
    var price: String
}
