//
//  EnlargedImageView.swift
//  MICHAELMCGINNIS-NameAndLocatePhoto
//
//  Created by Michael Mcginnis on 4/18/22.
//

import SwiftUI
import MapKit

struct EnlargedImageView: View {
    let image: UIImage
    //itll only be one location
    let locations: [Location]
    let locationFetcher = LocationFetcher()
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    var body: some View {
        VStack{
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            ZStack{
                Map(coordinateRegion: $mapRegion, annotationItems: locations){ location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())

                            Text(location.name)
                                .fixedSize()
                        }
                    }
                }
                    .ignoresSafeArea()
        }
    }
        .onAppear{
            let lat = locations[0].latitude
            let lon = locations[0].longitude
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat , longitude: lon), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        }
}
}
    

/*
struct EnlargedImageView_Previews: PreviewProvider {
    static var previews: some View {
        EnlargedImageView()
    }
}*/
