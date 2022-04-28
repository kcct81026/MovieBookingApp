//
//  GoogleAuth.swift
//  TestingForAll
//
//  Created by KC on 04/04/2022.
//

import Foundation
import GoogleSignIn
import UIKit

public class GoogleAuth : NSObject {
    
    private let OAUTH_ID_GOOGLE_SIGN_IN = "855497756479-eom2b6dinrlpqi7mnlhp7htm9cikibks.apps.googleusercontent.com"
    
    public func start(
        view : UIViewController?,
        success: @escaping ((GoogleAuthProfileResponse) -> Void),
        failure: @escaping ((String) -> Void) ) {
        
        print("Google-Sign-In Authentication Started")
        
        guard let viewController = view else {
            failure("Referencing view controller is nil")
            return
        }
        
        let signInConfig = GIDConfiguration(clientID: OAUTH_ID_GOOGLE_SIGN_IN)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController) { [weak self] (user, error) in
            guard let self = self else {
                print("vc is already gone")
                return
                
            } /// If nil, viewcontroller reference is already gone.
            
            if let error = self.handleSignInError(error) {
                print("Google-Sign-In ended with error.")
                failure(error)
            }
            
            
            if let userData = self.handleUserData(user) {
                print("Google-Sign-In completed successfully.")
                success(userData)
            } else {
                failure("\(#function) Google-Sign-In returns no user information")
            }
        }
    
    }
    
    private func handleSignInError(_ error : Error?) -> String? {
        /// Handle Error
        if let error = error {
            let errorCode : Int = (error as NSError).code
            switch errorCode {
            case GIDSignInError.hasNoAuthInKeychain.rawValue:
                return "The user has not signed in before or they have since signed out."
            default:
                return "\(error.localizedDescription)"
            }
        }
        return nil
    }
    
    
    private func handleUserData(_ user : GIDGoogleUser?) -> GoogleAuthProfileResponse? {
        /// Handle User Information
        guard let user = user else {
            return nil
        }
        
        // Perform any operations on signed in user here.
        let userId = user.userID ?? "" // For client-side use only!
        let token = user.authentication.idToken ?? ""
        let fullName = user.profile?.name ?? ""
        let givenName = user.profile?.givenName ?? ""
        let familyName = user.profile?.familyName ?? ""
        let email = user.profile?.email ?? ""
        
        let userData = GoogleAuthProfileResponse(
            id: userId,
            token: token,
            fullname: fullName,
            giveName: givenName,
            familyName: familyName,
            email: email
        )
        
        return userData
    }
}

public struct GoogleAuthProfileResponse {
    public let id, token, fullname, giveName, familyName, email : String
}


/*
 (id: "112437796399882672855", token: "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg2MTY0OWU0NTAzMTUzODNmNmI5ZDUxMGI3Y2Q0ZTkyMjZjM2NkODgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI4NTU0OTc3NTY0NzktZW9tMmI2ZGlucmxwcWk3bW5saHA3aHRtOWNpa2lia3MuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI4NTU0OTc3NTY0NzktZW9tMmI2ZGlucmxwcWk3bW5saHA3aHRtOWNpa2lia3MuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTI0Mzc3OTYzOTk4ODI2NzI4NTUiLCJlbWFpbCI6Im1zLmtoaW5jaG85MEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6Ild2VXZIUUJUWnVEQi1NQk1vRkYtQXciLCJub25jZSI6ImUzUEo4SnU0MjFwRjUzbHlSU0gyc3BuUmVma2R2Y3FOTmNMczNXT0J6NVkiLCJuYW1lIjoiSyBDIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdpcXYxeFE0S0hOaU5hbTJDaGRkbGRBNkoweDU2SGZCZ0VOOTZUOWJ3PXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IksiLCJmYW1pbHlfbmFtZSI6IkMiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY1MTEzNzcxNSwiZXhwIjoxNjUxMTQxMzE1fQ.fjj3irogTRYnor0haZE6GWf3sgcEhRoJpF0ISY9M-P6mpNlfw8AcAM9Ndhmq0_PDnLBYxKuhZ65Cqgo0-XY_bOLPsDsK6U1XcrmRwYbkwkKj-67mwBoFovn9tB09UyWlZph8GOJzOMaetvLuE5lbJN2hbyHp3tMm7IdMoLYhKDgOI_Vk6PMEQnnTp2S7o5CdM5D95-3tNq4wHA41og8iPgocYo91rNmA7_ePTDgzgAz0C2eNDcVrCPyI5TqgOBA7jdhgGS4oSMHnDiEXY4BRpe77MbmqUKDv59HmBm3pEpIYPGTUvYzsxwQS_3bATBUGXTitA8pk4O1s9n9MSfCzGw", fullname: "K C", giveName: "K", familyName: "C", email: "ms.khincho90@gmail.com")
 */
