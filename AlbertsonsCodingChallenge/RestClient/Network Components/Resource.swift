//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import Foundation

public struct Resource<A, CustomError> {
    let path: Path
    let method: RequestMethod
    var headers: HTTPHeaders
    var params: JSON
    let parse: (Data) -> A?
    let parseError: (Data) -> CustomError?
    
    public init(path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:],
         parse: @escaping (Data) -> A?,
         parseError: @escaping (Data) -> CustomError?) {
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.parse = parse
        self.parseError = parseError
    }
}

public extension Resource where A: Decodable, CustomError: Decodable {
      init(jsonDecoder: JSONDecoder,
         path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:]) {
        
        var newHeaders = headers
        newHeaders["Accept"] = "application/json;charset=UTF-8"
        newHeaders["Content-Type"] = "application/json;charset=UTF-8"
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = newHeaders
        self.parse = {
            try? jsonDecoder.decode(A.self, from: $0)
        }
        self.parseError = {
            try? jsonDecoder.decode(CustomError.self, from: $0)
        }
    }
}
