//
//  FireBaseManager.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 28.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

/// Helps to interacte with Firestore
class FirebaseManager {
    private init() {}
    private let db = Firestore.firestore()

    static let sharedInstance = FirebaseManager()

    /// Fetches available groups for user
    func fetchAvailableGroups(completion: @escaping (Result<[String: String], Error>) -> Void) {
        db.collection("sessionConfigurations").getDocuments { snapshot, error in

            if error != nil {
                completion(.failure(error!))
                return
            }

            var groups = [String: String]()
            snapshot?.documents.forEach { document in
                let data = document.data()
                let group = data["name"] as? String ?? ""
                groups[group] = document.documentID
            }

            completion(.success(groups))
        }
    }

    /// Add new document (userInfo) to userProfiles collection
    func addDocumentToUserProfiles(documentName: String, attributes: [String: Any],
                                   completion: @escaping (Result<Void, Error>) -> Void) {
        let collection = "userProfiles"
        addDocumentToFireBase(collection: collection, documentName: documentName, attributes: attributes, completion: completion)
    }

    /// Main for add documents in firestore. Add document to collection from params.
    func addDocumentToFireBase(collection: String, documentName: String, attributes: [String: Any],
                               completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(documentName).setData(attributes) { error in

            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
            }
        }
    }

    /// Check if userData is set 
    func checkIfCreateAtExist(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let document = db.collection("userProfiles").document(FirebaseAuth.Auth.auth().currentUser!.uid)
        document.getDocument { document, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document else { return }
            if document.exists {
                completion(.success((true)))
            } else {
                completion(.success(false))
            }
        }
    }
}