//
//  ContentView.swift
//  ARExample
//
//  Created by Den on 2020-10-21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @State private var offset: Float = 0
    
    var body: some View {
        ZStack {
            ARViewContainer(offset: $offset)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Slider(value: $offset, in: -0.1...0.1)
                    .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var offset: Float
    
    private let objectSize: Float = 0.03
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)
        let material = SimpleMaterial(color: .gray, isMetallic: false)
        let object = MeshResource.generateSphere(radius: objectSize)
        let entity = ModelEntity(mesh: object, materials: [material])
        entity.transform.translation = [0, objectSize, 0]
        anchor.addChild(entity)
        
        let lightAnchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(lightAnchor)
//        let lightObject = PointLight()
        let lightObject = MeshResource.generateSphere(radius: objectSize / 4)
//        lightObject.light.intensity *= 0.01
//        lightObject.transform.translation = [offset, objectSize * 2, 0]
        let lightEntity = ModelEntity(mesh: lightObject, materials: [material])
        lightAnchor.addChild(lightEntity)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let anchor = uiView.scene.anchors[1]
        anchor.transform.translation = [offset, 0, 0]
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
