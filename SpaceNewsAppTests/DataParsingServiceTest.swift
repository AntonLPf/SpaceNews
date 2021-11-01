//
//  NewsLoaderServiceTest.swift
//  SpaceNewsAppTests
//
//  Created by Skep Tic on 30.10.2021.
//

import XCTest
@testable import SpaceNewsApp

class DataParsingServiceTest: XCTestCase {
    
    var sut: DataParsingService!
    var bundle: Bundle!
    var correctDecodedRawDataObject: RawNewsItem!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataParsingService.shared
        self.bundle = Bundle(for: type(of: self))
        self.correctDecodedRawDataObject = RawNewsItem(
            id: 11289,
            title: "L3 Harris wins $120 million contract to upgrade Space Force electronic jammers",
            summary: "The U.S. Space Force awarded L3Harris Technologies a $120.7 million contract to upgrade a ground-based communications jammer used to block adversaries’ satellite transmissions.",
            publishedAt: "2021-10-22T23:13:11.000Z",
            imageUrl: URL(string: "https://spacenews.com/wp-content/uploads/2021/10/200312-F-GR961-1030.jpg")!,
            newsSite: "SpaceNews",
            url: URL(string: "https://spacenews.com/l3-harris-wins-120-million-contract-to-upgrade-space-force-electronic-jammers/")!)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_data_parser_parses_with_correct_data() {
        guard let url = bundle.url(forResource: "SpaceNews", withExtension: "json") else {
            XCTFail("Missing file: User.json")
            return
        }
        
        var jsonData: Data
        jsonData = try! Data(contentsOf: url)
        let expectedData: Set<RawNewsItem> = [correctDecodedRawDataObject]
        
        guard let decodedData: Set<RawNewsItem> = sut.parseData(jsonData) else {
            XCTFail()
            return
        }
        XCTAssertEqual(expectedData, decodedData)
    }
}
