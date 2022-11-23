//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import Foundation

class AlbAcronymViewModel {
    
    var albAcrList: [AlbAcronymModel]?
    var acronym: String?
    var longFormList: [LF]?
    var custError: Error?
    func fetchAcronymListWithName( _ acronym:String, completion: @escaping (ResultSet<[AlbAcronymModel], CustomError>) -> ()) {
        Request.queryParam = acronym
        Request.searchAcronym(completion: { [weak self ](acronymListResponse) in
            switch(acronymListResponse){
            case .success(let response):
                self?.albAcrList = response
                if let sf = self?.albAcrList?.first?.sf {
                    self?.acronym = sf
                }
                if let lfs = self?.albAcrList?.first?.lfs{
                    self?.longFormList = lfs
                }
                completion(acronymListResponse)
            case .failure(_):
                completion(acronymListResponse)
            }
        })
    }
}
