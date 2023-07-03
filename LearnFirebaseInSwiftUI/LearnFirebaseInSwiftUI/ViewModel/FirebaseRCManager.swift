//
//  FirebaseRCManager.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 7/3/23.
//

import Foundation
import FirebaseRemoteConfig

class FirebaseRCManager: ObservableObject {
    
    static let shared = FirebaseRCManager()
    @Published var isItemView_2: Bool = false
    
    private var remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // NOTE: This value only for debugging
        remoteConfig.configSettings = settings
    }
    
    func fetchRemoteConfig() {
        remoteConfig.fetch { (_, error) -> Void in
            if let error {
                print("Config not fetched")
                print("Error: \(error.localizedDescription)")
            } else {
                self.remoteConfig.activate { changed, error in
                    if let error {
                        print("Activate remote config data error:", error)
                    } else if changed {
                        print("Successfully fetched and activated the remote config data")
                        self.readRemoteConfigData()
                    } else {
                        print("Failed to activate remote config data")
                    }
                }
            }
        }
    }
    
    func readRemoteConfigData() {
        let remoteConfigValue = remoteConfig["learning_swift"]
        if let json = remoteConfigValue.jsonValue as? [String: Any],
            let boolValue = json["isItemView_2"] as? Bool {
            
            DispatchQueue.main.async {
                self.isItemView_2 = boolValue
                print("New remote config data:", self.isItemView_2)
            }
        }
    }
}
