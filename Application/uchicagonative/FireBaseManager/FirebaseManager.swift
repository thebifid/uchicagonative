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
                let isActive = data["active"] as? Bool ?? false
                if isActive {
                    let group = data["name"] as? String ?? ""
                    groups[group] = document.documentID
                }
            }

            completion(.success(groups))
        }
    }

    /// Fetches user info
    func fetchUserInfo(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        let document = db.collection("userProfiles").document(uid)

        document.getDocument { document, error in
            if error != nil {
                completion(.failure(error!))
            } else {
                var userInfo = [String: Any]()
                guard let data = document?.data() else { return }
                userInfo["firstName"] = data["firstName"]
                userInfo["lastName"] = data["lastName"]
                userInfo["gender"] = data["gender"]
                userInfo["birthYear"] = data["birthYear"]
                userInfo["email"] = data["email"]
                userInfo["zipCode"] = data["zipCode"]
                userInfo["projectId"] = data["projectId"]
                userInfo["role"] = data["role"]

                completion(.success(userInfo))
            }
        }
    }

    /// Add listener for user info
    func addUserInfoChangeListener(completion: @escaping ((User) -> Void)) -> ListenerRegistration? {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return nil }
        let document = db.collection("userProfiles").document(uid)

        let listener = document.addSnapshotListener { document, error in
            if error == nil {
                guard let data = document?.data() else { return }
                let user = User(firstName: data["firstName"] as? String ?? "",
                                lastName: data["lastName"] as? String ?? "",
                                email: data["email"] as? String ?? "",
                                birthYear: data["birthYear"] as? Int ?? 0,
                                gender: data["gender"] as? String ?? "",
                                projectId: data["projectId"] as? String ?? "",
                                zipCode: data["zipCode"] as? Int ?? 0)
                completion(user)
            }
        }
        return listener
    }

    /// Add new document (userInfo) to userProfiles collection
    func addDocumentToUserProfiles(attributes: [String: Any],
                                   completion: @escaping (Result<Void, Error>) -> Void) {
        let collection = "userProfiles"
        addDocumentToFireBase(collection: collection,
                              documentName: FirebaseAuth.Auth.auth().currentUser!.uid,
                              attributes: attributes, completion: completion)
    }

    /// TEMP
    func addDocumentToBlocks(attributes: [String: Any]) {
        let collection = "blocks"
        addDocumentToFireBase(collection: collection, documentName: "testDocument", attributes: attributes) { _ in
        }
    }

    /// Main method for add documents in firestore. Add document to collection from params.
    private func addDocumentToFireBase(collection: String, documentName: String, attributes: [String: Any],
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

    /// Update document (userInfo) in userProfiles collection
    func updateUserInfo(attributes: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let collection = "userProfiles"
        updateFirebaseDocument(colletction: collection,
                               documentName: FirebaseAuth.Auth.auth().currentUser!.uid,
                               attributes: attributes,
                               completion: completion)
    }

    /// Main method to update document in collection
    private func updateFirebaseDocument(colletction: String, documentName: String, attributes: [String: Any],
                                        completion: @escaping ((Result<Void, Error>) -> Void)) {
        var attributesWithTimestamp = attributes
        attributesWithTimestamp["updatedAt"] = FieldValue.serverTimestamp()
        db.collection(colletction).document(documentName).updateData(attributesWithTimestamp) { error in

            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
            }
        }
    }

    /// Check if userData is set
    func isUserDataExitsts(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        guard FirebaseAuth.Auth.auth().currentUser?.uid != nil else { return }

        let document = db.collection("userProfiles").document(FirebaseAuth.Auth.auth().currentUser!.uid)
        document.getDocument { document, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document else { return }
            if document.exists {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }

    /// Fetch user data
    func fetchUser(completion: @escaping (User) -> Void) {
        var user = User()

        fetchUserInfo { result in

            switch result {
            case .failure:
                completion(user)

            case let .success(userInfo):
                user.firstName = userInfo["firstName"] as? String ?? ""
                user.lastName = userInfo["lastName"] as? String ?? ""
                user.email = userInfo["email"] as? String ?? ""
                user.birthYear = userInfo["birthYear"] as? Int ?? 0
                user.gender = userInfo["gender"] as? String ?? ""
                user.projectId = userInfo["projectId"] as? String ?? ""
                user.zipCode = userInfo["zipCode"] as? Int ?? 0
                completion(user)
            }
        }
    }

    func fetchSessionConfigurations(withSessionId id: String, completion: @escaping ((Result<SessionConfiguration, Error>) -> Void)) {
        let collection = "sessionConfigurations"
        let document = db.collection(collection).document(id)

        document.getDocument { document, error in

            if error != nil {
                completion(.failure(error!))

            } else {
                guard let data = document?.data() else { return }
                let sessionConfigurations = SessionConfiguration(rawDict: data)
                completion(.success(sessionConfigurations!))
            }
        }
    }
}
