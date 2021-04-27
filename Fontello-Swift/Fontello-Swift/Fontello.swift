//
//  Fontello.swift
//  Fontello-Swift
//
//  Created by chisj on 16/5/15.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

open class Fontello {
    public static func fontOfSize(_ fontSize: CGFloat, name: String) -> UIFont {
        if UIFont.fontNames(forFamilyName: name).isEmpty {
            Fontello.loadFont(name)
        }
        
        return UIFont(name: name, size: fontSize)!
    }

    static func loadFont(_ name: String) {
        let bundle = Bundle(for: Fontello.self)
        var fontURL: URL?
        let identifier = bundle.bundleIdentifier
        
        if identifier?.hasPrefix("org.cocoapods") == true {
            fontURL = bundle.url(forResource: name, withExtension: "ttf", subdirectory: "\(name).bundle")
        }
        else {
            fontURL = bundle.url(forResource: name, withExtension: "ttf")
        }
        
        guard
            let url = fontURL,
            let data = try? Data(contentsOf: url),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
        else { return }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}
