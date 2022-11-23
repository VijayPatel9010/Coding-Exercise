//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import Foundation

public enum ResultSet<A, CustomError> {
    case success(A)
    case failure(WebError<CustomError>)
}

extension ResultSet {
    init(value: A?, or error: WebError<CustomError>) {
        guard let value = value else {
            self = .failure(error)
            return
        }
        self = .success(value)
    }
    
    public var value: A? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    public var error: WebError<CustomError>? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
