//
//  SessionStore.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 7/30/20.
//

import SwiftUI
import Firebase
import Combine

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet{self.didChange.send(self)}}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
        })
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}

struct User {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}

class AccountDataStore: ObservableObject {
    var didChange = PassthroughSubject<AccountDataStore, Never>()
    
    @Published var accountStatus: String? {didSet{self.didChange.send(self)}}
    
       let user = Auth.auth().currentUser
       let db = Firestore.firestore()
       
       func confrim() {
           let docRef = db.collection("UserData").document(user?.uid ?? "None")
        
           docRef.getDocument { (document, error) in
               if let document = document {
                   if document.exists{
                       print("True")
                       self.accountStatus = "Exists"
                   } else {
                       print("False")
                       self.accountStatus = nil
                   }
               }
           }
       }
}


struct SessionStore_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
