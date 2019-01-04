//
//  Nebula_MessengerTests.swift
//  Nebula MessengerTests
//
//  Created by Shelby McCowan on 9/19/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import XCTest
@testable import Nebula_Messenger

class Nebula_MessengerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Utility tests

    func testUtilityAlphabetSort() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let testConvId = "MusicDev:gorilla:testaccount:tanner:Zenith;"
        
        let outputConvId = Utility.alphabetSort(preConvId: testConvId)
        XCTAssertEqual(outputConvId, "MusicDev:Zenith:gorilla:tanner:testaccount;")
    }
    
    func testUtilityCreateConvId(){
        let friends = ["MusicDev", "goofy", "1dwight", "Zenith", "dwight"]
        
        let outputFriends = Utility.createConvId(names: friends)
        XCTAssertEqual(outputFriends, "1dwight:MusicDev:Zenith:dwight:goofy;")
    }
    
    func testFriendsFromConvIdAsString(){
        let convId = "MusicDev:gorilla:testaccount:tanner:Zenith;"
        let outputFriends = Utility.getFriendsFromConvId(user: "MusicDev", convId: convId)
        XCTAssertEqual(outputFriends, "Zenith, gorilla, tanner, testaccount")
    }
    
    func testFriendsFromConvIdAsArray(){
        let convId = "MusicDev:gorilla:1dwight:testaccount:tanner:Zenith;"
        let outputFriends = Utility.getFriendsFromConvIdAsArray(user: "MusicDev", convId: convId)
        XCTAssertEqual(outputFriends, ["1dwight", "Zenith", "gorilla", "tanner", "testaccount"])
    }
    
    func testJSONToArray(){
        var testDict = [String:Any]()
        testDict["array"] = ["A", "B", "C"]
        let testJSON = JSON(testDict)
        
        let outputArray = Utility.toArray(json: testJSON["array"])
        
        XCTAssertEqual(outputArray, ["A", "B", "C"])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
