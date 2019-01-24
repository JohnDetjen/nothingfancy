//
//  AppDelegate.swift
//  Topcoin
//
//  Created by John Detjen on 11/26/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import Parse
import Sparrow

struct ApiUserDTO : Codable {
    let email : String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
}

struct ApiVerifySuccessDTO : Codable {
    let user : ApiUserDTO?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(ApiUserDTO.self, forKey: .user)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize:18, weight: .bold)]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "RuO7mWjcbI4nOu1J31NXz8B5EGhklBPE7pw9YjQm"
            $0.clientKey = "KCYrcvt4oQmUBHIdfYJpnBq2YLkimqQ3Uolr6VcM"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        saveInstallationObject()
        
//        SPLaunchAnimation.asTwitter(onWindow: self.window!)

        return true
    }
    
    func apiVerify(id: String, token: String, callback: @escaping (String, String) -> Void, error errorCallback: @escaping (String) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/users/\(id)")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let verifySuccessModel = try jsonDecoder.decode(ApiVerifySuccessDTO.self, from: data)
                    if let email = verifySuccessModel.user?.email {
                        DispatchQueue.main.async {
                            callback(email, token)
                        }
                        return
                    }
                } catch { }
                do {
                    let jsonDecoder = JSONDecoder()
                    let errorModel = try jsonDecoder.decode(ApiErrorDTO.self, from: data)
                    if let message = errorModel.message {
                        DispatchQueue.main.async {
                            errorCallback(message)
                        }
                        return
                    }
                } catch { }
            }
            DispatchQueue.main.async {
                errorCallback("An unknown error occurred.")
            }
        }).resume()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard (url.pathComponents.count == 3) else {
            return true
        }
        
        let id = url.pathComponents[1]
        let token = url.pathComponents[2]
        
        apiVerify(id: id, token: token, callback: { email, token in
            print("Success")
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(token, forKey: "token")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyBoard.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
            self.topMostController()?.present(main, animated: false, completion: nil)
        }, error: { message in
            print("Error: \(message)")
        })
    
        return true
    }
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        
        return topController
    }

    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

