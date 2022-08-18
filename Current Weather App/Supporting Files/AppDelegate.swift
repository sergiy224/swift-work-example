//
//  AppDelegate.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/24/22.
//

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dataController = DataController(modelName: "CurrentWeather")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(APIkeys.googlePlacesKey)
//        dataController.load()
//        let myCitiesVC = MyCitiesViewController()
//        myCitiesVC.dataController = dataController
        
        return true
    }
    
    func checkIfFirstLaunch(){
        if UserDefaults.standard.bool(forKey: "Has launched before"){
            print("App has launched before")
        } else{
            print("This is the first launch ever")
            UserDefaults.standard.set(true, forKey: "Has launched before")
            UserDefaults.standard.set(0.0, forKey: "Slider value key")
            
            
            UserDefaults.standard.synchronize()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // Lock the orientation to Portrait mode
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        checkIfFirstLaunch()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewcontext()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func saveViewcontext(){
        try? dataController.viewContext.save()
    }

}

