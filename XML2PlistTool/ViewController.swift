//
//  ViewController.swift
//  XML2PlistTool
//
//  Created by hechao on 2017/5/23.
//  Copyright © 2017年 UBTech Robotics Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 动画帧数
    var frameArray = [Array<NSNumber>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // XML
        guard let fileURL = Bundle.main.url(forResource: "crazyDance", withExtension: "xml") else {
            return
        }
        let parser = XMLParser.init(contentsOf: fileURL)
        parser?.delegate = self
        parser?.parse()
        
        // 写入文件 plist
        self.saveWithFile(dataSource: frameArray as! NSMutableArray)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 写文件
    func saveWithFile(dataSource: NSMutableArray) {
        // 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        // 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString;
        // 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("data.plist");
        print("filePath = \(filePath)")
        // 4、将数据写入文件中
        dataSource.write(toFile: filePath, atomically: true);
    }
    
    // 读文件
    func readWithFile() {
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("data.plist");
        print(filePath)
    }


}

extension ViewController: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        var angleArray = [NSNumber]()
        
        if elementName == "Root" {
            
            guard let nodeType = attributeDict["nodeType"] else {
                return
            }
            
            if nodeType == "body" {
                
                guard let nodeAnglesString = attributeDict["rotas"] else {
                    return
                }
                print("\(nodeAnglesString)")
                
                // 分割
                let angles = nodeAnglesString.components(separatedBy: ";")
                for angle in angles {
                 
                    let startIndex = angle.startIndex
                    let index = angle.index(startIndex, offsetBy: 2)
                    
                    let newAngle = angle.substring(from: index)
                    
                    let angleInt = Int(string: newAngle)
                    
                    // 每一帧数据
                    angleArray.append(NSNumber(integerLiteral: angleInt))
                }
                
                // 帧数组
                frameArray.append(angleArray)
            }
        }
    }
}

extension Int {
    
    public init(string: String?) {
        self = Int(string ?? "0") ?? 0
    }
}
