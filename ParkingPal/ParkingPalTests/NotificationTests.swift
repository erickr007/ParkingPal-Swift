//
//  NotificationTests.swift
//  ParkingPalTests
//
//  Created by Eric on 3/2/19.
//  Copyright © 2019 Eric Robertson. All rights reserved.
//

import XCTest
import CoreData
import ArcGIS

class NotificationTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ParkingPal", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (desc, error) in
            precondition(desc.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        
        return container
    }()
 
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(container: mockPersistentContainer)
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotificationExpiredTrue() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
