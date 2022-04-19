//
//  ContentView.swift
//  MICHAELMCGINNIS-NameAndLocatePhoto
//
//  Created by Michael Mcginnis on 4/18/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var photos = NamedImageC()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: UIImage?
    @State private var imgName: String = ""
    let context = CIContext()
    let defaultImage = Image(systemName: "star.fill")
    let locationFetcher = LocationFetcher()
    
    //To remove from ForEach
    func removeRows(at offsets: IndexSet) {
        photos.photosArr.remove(atOffsets: offsets)
        photos.save()
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {
            return
        }
        let beginImage = CIImage(image: inputImage)

        if let cgimg = context.createCGImage(beginImage!, from: beginImage!.extent){
            let uiImage = UIImage(cgImage: cgimg)
            image = uiImage
            //image = Image(uiImage: uiImage)
        }
    }
    
    func addLocation() {
        if imgName == ""{
            return
        }
        
        let newLocation = Location(id: UUID(), name: imgName, description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
        locations.append(newLocation)
        //save()
    }
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State private var locations: [Location] = []
    
    var body: some View {
        NavigationView{
            VStack{
                if image != nil{
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                    TextField("Name me! ", text: $imgName)
                        .padding()
                        .disabled(locations.count > 0)
                    //map
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
                                        .disabled(imgName == "")

                                    Text(location.name)
                                        .fixedSize()
                                }
                            }
                        }
                            .ignoresSafeArea()
                        Circle()
                            .fill(.blue)
                            .opacity(0.3)
                            .frame(width: 32, height: 32)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    addLocation()
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                            }
                        }
                    }.onAppear{
                        let lat = self.locationFetcher.lastKnownLocation?.latitude
                        let lon = self.locationFetcher.lastKnownLocation?.longitude
                        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat ?? 50, longitude: lon ?? 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
                    }
                    
                    Button("Save"){
                        // image can't be nil here so force-unwrap works!
                        let img = NamedImage(image: image!, name: imgName, location: locations)
                        photos.photosArr.append(img)
                        photos.save()
                        image = nil
                        imgName = ""
                        locations = []
                        //save image and add to list
                    }
                    .disabled(locations.count == 0)
                }
                List{
                    ForEach(photos.photosArr.sorted()) { photo in
                        NavigationLink(destination: EnlargedImageView(image: photo.image, locations: photo.location)){
                            HStack{
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Spacer()
                                Text(photo.name)
                                    .font(.title)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: removeRows)
                }
            }
            .sheet(isPresented: $showingImagePicker){
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add Image"){
                        showingImagePicker = true
                    }
                    .disabled(image != nil)
                }
            }
            .onChange(of: inputImage){ _ in
                loadImage()
            }
            .navigationTitle("Name That Photo!")
            .onAppear{
                self.locationFetcher.start()
            }
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
