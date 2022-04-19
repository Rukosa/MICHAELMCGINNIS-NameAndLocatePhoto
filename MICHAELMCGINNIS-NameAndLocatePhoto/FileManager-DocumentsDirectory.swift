//
//  FileManager-DocumentsDirectory.swift
//  MICHAELMCGINNIS-NameAndLocatePhoto
//
//  Created by Michael Mcginnis on 4/18/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
