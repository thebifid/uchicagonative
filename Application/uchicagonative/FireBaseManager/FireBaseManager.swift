//
//  FireBaseManager.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 28.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseFirestore
import Foundation

class FireBaseManager {
    private init() {}
    private let db = Firestore.firestore()

    static let sharedInstance = FireBaseManager()

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

    func addDocumentToUserProfiles(documentName: String, attributes: [String: Any],
                                   completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("userProfiles").document(documentName).setData(attributes) { error in

            if let error = error {
                completion(.failure(error))
                print("error")
                return
            } else {
                completion(.success(()))
                print("added")
            }
        }
    }
}
