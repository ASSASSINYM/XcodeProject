//
//  PBXProjectParser.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Parser {
    func context() -> Context
}

public class PBXProjectParser {
    private let cachedContext: Context
    
    init(xcodeprojectUrl: URL) throws {
        guard
            let propertyList = try? Data(contentsOf: xcodeprojectUrl)
            else {
                throw XcodeProjectError.notExistsProjectFile
        }
        var format: PropertyListSerialization.PropertyListFormat = PropertyListSerialization.PropertyListFormat.binary
        let properties = try PropertyListSerialization.propertyList(from: propertyList, options: PropertyListSerialization.MutabilityOptions(), format: &format)
        
        guard
            let allPBX = properties as? PBXRawMapType
            else {
                throw XcodeProjectError.wrongFileFormat
        }
        
        let context = InternalContext(allPBX: allPBX, xcodeProjectUrl: xcodeprojectUrl)
        cachedContext = context
    }
}

extension PBXProjectParser: Parser {
    public func context() -> Context {
        return cachedContext
    }
}
