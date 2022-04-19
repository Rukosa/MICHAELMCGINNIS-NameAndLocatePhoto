//
//  NamedImage.swift
//  MICHAELMCGINNIS-NameAndLocatePhoto
//
//  Created by Michael Mcginnis on 4/18/22.
//

import Foundation
import SwiftUI

struct NamedImage: Identifiable, Codable, Comparable{
    static func < (lhs: NamedImage, rhs: NamedImage) -> Bool {
        lhs.name < rhs.name
    }
    
    var id = UUID()
    var image: UIImage
    var name: String
    var location: [Location]
    
    enum CodingKeys: CodingKey{
        case name, id, image, location
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let jpegData = image.jpegData(compressionQuality: 0.8)
        try container.encode(jpegData, forKey: .image)
        
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(location, forKey: .location)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let jpegData = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: jpegData)!
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(UUID.self, forKey: .id)
        location = try container.decode([Location].self, forKey: .location)
    }
    init(image: UIImage, name: String, location: [Location]){
        self.name = name
        self.image = image
        self.location = location
    }
}

class NamedImageC: ObservableObject {
    init(){
        do{
            let data = try Data(contentsOf: savePath)
            photosArr = try JSONDecoder().decode([NamedImage].self, from: data)
        } catch {
            photosArr = []
            print(error.localizedDescription)
        }
    }
    @Published var photosArr: [NamedImage] = []
    
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedImages")
    
    func save() {
        do {
            let data = try JSONEncoder().encode(photosArr)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
