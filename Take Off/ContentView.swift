//
//  ContentView.swift
//  Take Off
//
//  Created by MyMac on 8/9/20.
//  Copyright © 2020 White Paladin Games. All rights reserved.
//

import GridStack
import SwiftUI
import Introspect

struct ContentView: View {
    @State var originalList: [TakeOffAppInfo] = []
    @State private var text = ""
    @State private var itemCount = 0
    @State var appInfoArray = [TakeOffAppInfo]()
    @State private var initialized = false
    
    func refreshApps(){
        var r = [TakeOffAppInfo]()
        let ff = FileFunctions();
        r = ff.getFiles(path: "/Applications/", first: true)
        r.append(contentsOf: ff.getFiles(path: "/System/Applications/", first: true))
        let r1 = r.sorted{
            ($0.lowerName, $0.lowerName) <
            ($1.lowerName, $1.lowerName)
        }
        self.originalList = r1
        self.appInfoArray = r1
    }
    func launchApp(name n: String){
        let myWorkspace = NSWorkspace.shared
        myWorkspace.launchApplication(n)
        self.text = ""
        self.appInfoArray = self.originalList
    }
    func launchIt() {
        if self.text != "" {
            self.launchApp(name: self.appInfoArray[0].LaunchName)
        }
    }
    func find(value searchValue: String, in array: [TakeOffAppInfo]) -> [Int]
    {
        var result = [Int]()
        let sv = searchValue.lowercased()
        for (index, value) in array.enumerated()
        {
            if value.lowerName.contains(sv) {
                result.append(index)
            }
        }

        return result
    }
    var body: some View {
        VStack(alignment:.center){
            TextField("Search", text: Binding<String>(get: {
                return self.text
            }, set: {
                self.text = $0
                var temp = [TakeOffAppInfo]()
                if self.text == "" {
                    temp = self.originalList
                } else {
                    let result = self.find(value: self.text, in: self.originalList)
                    print(result)
                    for (_, value) in result.enumerated() {
                        temp.append(self.originalList[value])
                    }
                }
                self.appInfoArray = temp
            }), onCommit: self.launchIt).frame(width: 300.0).introspectTextField { textField in
                if !self.initialized {
                    self.initialized = true
                    textField.becomeFirstResponder()
                }
            }
            Button(action: {self.refreshApps()}){
                Image("refresh").renderingMode(.original).resizable().frame(width: 16.0, height: 16.0)}
            .buttonStyle(BorderlessButtonStyle())
            GridStack (minCellWidth: 100, spacing: 15, numItems: appInfoArray.count) {index, cellWidth in
                Button(action: {
                    self.launchApp(name: self.appInfoArray[index].LaunchName)
                }){
                    VStack {
                        Image(nsImage: NSImage(byReferencingFile: self.appInfoArray[index].Icon)!)
                            .renderingMode(.original)
                            .resizable().frame(width: 32.0, height: 32.0)
                        Text(self.appInfoArray[index].ProperName).foregroundColor(   Color.gray)}}
                        .id(self.appInfoArray[index].id)
                        .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
