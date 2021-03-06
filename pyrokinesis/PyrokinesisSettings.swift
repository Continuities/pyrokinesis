//
//  PyrokinesisSettings.swift
//  pyrokinesis
//
//  Created by Callum Hay on 2015-07-19.
//  Copyright (c) 2015 s3fa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PyrokinesisSettings : NSManagedObject {
    
    static let FLAME_EFFECT_RESEND_TIME_S : TimeInterval = 0.050
    static let FLAME_EFFECT_ON_TIME_S: TimeInterval = 0.1
    static let NUM_FLAME_EFFECTS: Int = 8
    
    static let INNER_MOST_FLAME_INDICES: [Int] = [0, 4]
    static let OUTER_MOST_FLAME_INDICES: [Int] = [1, 2, 3, 5, 6, 7]
    static let ALL_FLAME_INDICES: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    
    static let DEFAULT_CONN_ENABLED = true
    static let DEFAULT_IP_ADDRESS: String = "192.168.1.1"
    static let DEFAULT_PORT_NUMBER: Int32 = 2000
    
    static let DEFAULT_GAME_MODE: String = GameMode.Calm.rawValue
    static let DEFAULT_JAW_CLENCHING_ENABLED = true
    
    @NSManaged var connectionEnabled: Bool
    @NSManaged var fireIPAddress: String
    @NSManaged var firePort: Int32
    @NSManaged var gameMode: String
    @NSManaged var jawClenchingEnabled: Bool
    
    enum GameMode: String {
        case Calm = "Calm"
        case Concentration = "Concentration"
        
        static let allValues = [Calm, Concentration]
    }
    
    class func getSettings() -> PyrokinesisSettings? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PyrokinesisSettings")
        fetchRequest.fetchLimit = 1
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            var fetchedEntities: [PyrokinesisSettings];
            do { fetchedEntities = try managedObjectContext.fetch(fetchRequest) as! [PyrokinesisSettings] }
            catch { fetchedEntities = [] }
            
            if fetchedEntities.isEmpty {
                
                // Create a new GameData entity
                let newSettings = NSEntityDescription.insertNewObject(forEntityName: "PyrokinesisSettings", into: managedObjectContext) as! PyrokinesisSettings
                
                newSettings.resetToDefaults()
                newSettings.save()
                
                fetchedEntities = [newSettings]
            }
            
            return fetchedEntities[0]
        }
        
        return nil
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func resetToDefaults() {
        self.connectionEnabled = PyrokinesisSettings.DEFAULT_CONN_ENABLED
        self.fireIPAddress = PyrokinesisSettings.DEFAULT_IP_ADDRESS
        self.firePort = PyrokinesisSettings.DEFAULT_PORT_NUMBER
        self.gameMode = PyrokinesisSettings.DEFAULT_GAME_MODE
        self.jawClenchingEnabled = PyrokinesisSettings.DEFAULT_JAW_CLENCHING_ENABLED
    }
    
}
