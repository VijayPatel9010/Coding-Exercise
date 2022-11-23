//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//

import Foundation

class Request {

    static let sharedWebClient = WebClient.init(baseUrl: BASE_URL)
    static var statsTask: URLSessionDataTask!
    static var launchListResponse: ResultSet<AlbAcronymModel,CustomError>!
    static var queryParam: String?
    // MARK: - searchLaunches - Makes Actual rest client load request to fetch launches
    class func searchAcronym(completion: @escaping (ResultSet<[AlbAcronymModel], CustomError>) -> ()){
        statsTask?.cancel()
        var pathString : String = SEARCH_PATH
        if let query = queryParam {
            pathString = pathString + "?sf=" + query
        }
        let launchSearchResource = Resource<[AlbAcronymModel], CustomError>(
            jsonDecoder: JSONDecoder(),
            path: pathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
            method: .get)
        
        statsTask = sharedWebClient.load(resource: launchSearchResource, completion: { (response) in
            DispatchQueue.main.async {
               completion(response)
            }
        })
    }
}
