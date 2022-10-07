//
//  Tags.swift
//  OctoKit
//
//  Created by Luís Silva on 07/10/2022.
//  Copyright © 2022 nerdish by nature. All rights reserved.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model

public struct Tag: Codable {
    public let name: String
    public let zipballURL: String
    public let tarballURL: String
    public let nodeId: String

    enum CodingKeys: String, CodingKey {
        case name
        case zipballURL = "zipball_url"
        case tarballURL = "tarball_url"
        case nodeId = "node_id"
    }
}

// MARK: request

public extension Octokit {
    /// Fetches the list of releases.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.shared()
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    ///   - perPage: Results per page (max 100). Default: `30`.
    ///   - completion: Callback for the outcome of the fetch.
    @discardableResult
    func listTags(_ session: RequestKitURLSession = URLSession.shared,
                      owner: String,
                      repository: String,
                      perPage: Int = 30,
                      completion: @escaping (_ response: Result<[Tag], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = TagsRouter.listTags(configuration, owner, repository, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Tag].self) { tags, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let tags = tags {
                    completion(.success(tags))
                }
            }
        }
    }
}

// MARK: Router

enum TagsRouter: JSONPostRouter {
    case listTags(Configuration, String, String, Int)

    var configuration: Configuration {
        switch self {
        case let .listTags(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listTags:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .listTags:
            return .url
        }
    }

    var params: [String: Any] {
        switch self {
        case let .listTags(_, _, _, perPage):
            return ["per_page": "\(perPage)"]
        }
    }

    var path: String {
        switch self {
        case let .listTags(_, owner, repo, _):
            return "repos/\(owner)/\(repo)/tags"
        }
    }
}
