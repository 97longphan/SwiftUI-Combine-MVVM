//
//  Services.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case getListPokemon(limit: Int, loadMore: String?)
    case getDetailPokemon(id: String)
    
    private var baseUrl: String {
        switch self {
        case .getDetailPokemon(let id):
            return id
        case .getListPokemon(_ , let loadMore):
            if let loadMore = loadMore, loadMore != "" {
                return loadMore
            } else {
                return "https://pokeapi.co/api/v2/"
            }
        }
    }
    
    private var path: String? {
        switch self {
        case .getListPokemon(_ , let loadMore):
            if let loadMore = loadMore, loadMore != "" {
                return nil
            } else {
                return "pokemon"
            }
        case .getDetailPokemon:
            return nil
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getListPokemon, .getDetailPokemon:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getListPokemon(let limit, let loadMore):
            if let loadMore = loadMore, loadMore != "" {
                return nil
            } else {
                return ["limit": limit]
            }
        case .getDetailPokemon:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path ?? ""))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                print("Encoding fail")
            }
        }
        return urlRequest
    }
}

