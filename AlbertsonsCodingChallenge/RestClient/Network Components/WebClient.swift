//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import Foundation

public typealias JSON = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init<A, E>(baseUrl: String, resource: Resource<A, E>) {
        var components = URLComponents(string: BASE_URL)!
        let resourceComponents = URLComponents(string: resource.path.absolutePath)!
        
        components.path = Path(components.path).appending(path: Path(resourceComponents.path)).absolutePath
        components.queryItems = resourceComponents.queryItems
        
        switch resource.method {
        case .get, .delete:
            var queryItems = components.queryItems ?? []
            queryItems.append(contentsOf: resource.params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            })
            components.queryItems = queryItems
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init<A, E>(baseUrl: String, resource: Resource<A, E>) {
        let url = URL(baseUrl: baseUrl, resource: resource)
        self.init(url: url)
        httpMethod = resource.method.rawValue
        resource.headers.forEach{
            setValue($0.value, forHTTPHeaderField: $0.key)
        }
        switch resource.method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: resource.params, options: [])
        default:
            break
        }
    }
}

open class WebClient {
    private var baseUrl: String
    
    public var commonParams: JSON = [:]
 
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func load<A, CustomError>(resource: Resource<A, CustomError>,
                                     completion: @escaping (ResultSet<A, CustomError>) ->()) -> URLSessionDataTask? {
        let reachability: Reachability = Reachability()!
        do
        {
            try reachability.startNotifier()
        }
        catch
        {
             completion(.failure(.noInternetConnection))
            print( "ERROR: Could not start reachability notifier." )
        }
        var newResouce = resource
        newResouce.params = newResouce.params.merging(commonParams) { spec, common in
            return spec
        }
        // Something wrong in making request using baseurl and resource have to debug more.
        // hardcoding the url for time being.
        
        let request = URLRequest(baseUrl: baseUrl, resource: newResouce)
//        let request = URLRequest(url: URL(string: "https://fdo.rocketlaunch.live/json/launches/next/5")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            // Parsing incoming data
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.other))
                return
            }
            if (200..<300) ~= response.statusCode {
                completion(ResultSet(value: data.flatMap(resource.parse), or: .other))
            } else if response.statusCode == 401 {
                completion(.failure(.unauthorized))
            } else {
                completion(.failure(data.flatMap(resource.parseError).map({.custom($0)}) ?? .other))
            }
        }
        
        task.resume()
        
        return task
        
    }
}
