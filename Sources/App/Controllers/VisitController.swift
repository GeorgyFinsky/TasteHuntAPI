//
//  VisitController.swift
//  
//
//  Created by Georgy Finsky on 16.03.23.
//

import Vapor
import Fluent

struct VisitController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let visitsGroup = routes.grouped("visits")
        visitsGroup.get(use: getGuestVisits)
        visitsGroup.post(use: createVisitHandler)
    }
    
    func createVisitHandler(_ req: Request) async throws -> VisitModel {
        guard let visit = try? req.content.decode(VisitModel.self) else {
            throw Abort(.badRequest)
        }
        try await visit.save(on: req.db)
        
        return visit
    }
    
    private func getGuestVisits(_ req: Request) async throws -> [VisitModel] {
        guard let id = req.headers.first(name: "AccessToken") else {
            throw Abort(.badRequest)
        }
        
        let visits = try await VisitModel.query(on: req.db).all()
        var userVisits = [VisitModel]()
        
        visits.forEach { visit in
            let guestsIDstr = parseStringIntoArray(value: visit.guestsID)
            if guestsIDstr.first(where: { $0 == id }) != nil {
                userVisits.append(visit)
            }
        }
        return userVisits
    }
    
    private func parseStringIntoArray(value: String) -> [String] {
        var outputArray = [String]()
        var outputArrayObject: String = ""
        
        for i in value {
            if i == "|" {
                outputArray.append(outputArrayObject)
                outputArrayObject = ""
            } else {
                outputArrayObject += String(i)
            }
        }
        return outputArray
    }
    
}
