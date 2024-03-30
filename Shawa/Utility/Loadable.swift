//
//  Loadable.swift
//  EffectiveMobileTest
//
//  Created by Alex on 17.03.24.
//

import Foundation

/// An enum representing the loading state of a resource.
enum Loadable<T> {
    /// The resource is not loaded, with an optional error.
    case notLoaded(error: Error?)
    /// The resource is currently loading, with an optional last known value.
    case loading(last: T?)
    /// The resource is loaded with a value.
    case loaded(T)
    
    /// The value of the loaded resource, if available.
    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .loading(last): return last
        default: return nil
        }
    }
    /// The error associated with the resource, if available.
    var error: Error? {
        switch self {
        case let .notLoaded(error): return error
        default: return nil
        }
    }
    /// Indicates whether the resource is currently loading.
    var isLoading: Bool {
        switch self {
        case .loading(_):
            return true
        default:
            return false
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(lhsV), .loading(rhsV)): return lhsV == rhsV
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.notLoaded(lhsE), .notLoaded(rhsE)):
            return lhsE?.localizedDescription == rhsE?.localizedDescription
        default: return false
        }
    }
}
