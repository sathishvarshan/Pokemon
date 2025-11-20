//
//  ProfileVM.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ProfileVM {
    
    static let shared = ProfileVM()
    
    func addUser(context: ModelContext,user: User){
        context.insert(user)
    }
    
    func updatePassword(context: ModelContext, phone: String, password: String) -> Bool{
        do{
            let predicate = #Predicate<User> { user in
                user.phone == phone
            }
            let descriptor = FetchDescriptor<User>(predicate: predicate)
            let list = try context.fetch(descriptor)
            let user = list[0]
            user.password = password
            try context.save()
            return true
        }catch{
            
        }
        return false
    }
    
    func fetchUser(context: ModelContext) -> [User] {
        let descriptor = FetchDescriptor<User>()
        return try! context.fetch(descriptor)
    }
    
}


@Model
class User: Identifiable, Equatable {
    var name: String
    var email: String
    var phone: String
    var password: String
    
    init(name: String, email: String, phone: String, password: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
    }
}
