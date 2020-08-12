//
//  fileFunctions.swift
//  Take Off
//
//  Created by MyMac on 8/9/20.
//  Copyright © 2020 White Paladin Games. All rights reserved.
//

import Foundation
import SwiftUI

class FileFunctions {
    func getFiles(path p: String, first fi: Bool) -> [TakeOffAppInfo]{
        let path = p

        let fileMgr = FileManager.default
        var result = [TakeOffAppInfo]()
        
        do {
            let f = try  fileMgr.contentsOfDirectory(atPath: path)
            for item in f {
                if !item.hasPrefix(".") {
                    if item.hasSuffix(".app") {
                        if item != "" {
                            let name = readPropertyList(path: p + item + "/Contents/Info.plist", property: "CFBundleDisplayName", property2: "CFBundleDisplayName", default: item.replacingOccurrences(of: ".app", with: ""))
                            var icon = readPropertyList(path: p + item + "/Contents/Info.plist", property: "CFBundleIconFile", property2: "CFBundleTypeIconFile", default: "AppIcon")
                            if icon != "" && !icon.hasSuffix(".icns") {
                                icon += ".icns"
                            }
                            let lname = name.lowercased()
                            let t = TakeOffAppInfo(id: ObjectIdentifier(lname as AnyObject), LaunchName: p + item, ProperName: name, lowerName: lname, Icon: p + item + "/Contents/Resources/" + icon)
                            result.append(t)
                        }
                    } else {
                        var pt = p
                        if !pt.hasSuffix("/"){
                            pt += "/"
                        }
                        pt += item
                        if !pt.hasSuffix("/") {
                            pt += "/"
                        }
                        let temp = getFiles(path: pt, first: false)
                        if temp.count > 0 {
                            result.append(contentsOf: temp)
                        }
                    }
                }
            }
        } catch  {
        }
        
        return result
    }
    
    func readPropertyList(path p: String, property prop: String, property2 prop2: String, default d: String) -> String {
        var result = ""
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = p //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!

        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            if plistData[prop] == nil {
                if plistData[prop2] == nil {
                result = d
                } else {
                    result = plistData[prop2] as! String
                }
            } else {
                result = plistData[prop] as! String
            }
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        return result
    }
}

struct TakeOffAppInfo: Identifiable, Hashable {
    let id: ObjectIdentifier
    let LaunchName: String
    let ProperName: String
    let lowerName: String
    let Icon: String
}
