//
//  FirebaseHelpers.swift
//  Shawa
//
//  Created by Alex on 29.03.24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public extension DocumentReference {
    /// Async version by me.
    /// Encodes an instance of `Encodable` and overwrites the encoded data
    /// to the document referred by this `DocumentReference`. If no document exists,
    /// it is created. If a document already exists, it is overwritten.
    ///
    /// See `Firestore.Encoder` for more details about the encoding process.
    ///
    /// - Parameters:
    ///   - value: An instance of `Encodable` to be encoded to a document.
    ///   - encoder: An encoder instance to use to run the encoding.
    func setData<T: Encodable>(from value: T,
                               encoder: Firestore.Encoder = Firestore.Encoder()) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            do {
                try setData(from: value, encoder: encoder) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
