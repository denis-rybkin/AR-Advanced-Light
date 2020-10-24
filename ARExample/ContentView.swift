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
        let sphereAnchor = AnchorEntity(plane: .horizontal)
        let material = SimpleMaterial(color: .gray, roughness: 0.5, isMetallic: false)
        let object = MeshResource.generateSphere(radius: objectSize)
        let sphereEntity = ModelEntity(mesh: object, materials: [material])
        sphereAnchor.addChild(sphereEntity)
        arView.scene.anchors.append(sphereAnchor)
        arView.renderOptions = ARView.RenderOptions.disableGroundingShadows
        let lightAnchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(lightAnchor)
        let lightObject = PointLight()
        lightObject.light.intensity *= 0.01
        // debug object
//        let lightObject = MeshResource.generateSphere(radius: objectSize / 4)
//        lightObject.transform.translation = [offset, objectSize * 2, 0]
//        let lightEntity = ModelEntity(mesh: lightObject, materials: [material])
        lightAnchor.addChild(lightObject)
        
        sphereEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation], for: sphereEntity)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        uiView.scene.anchors[0].transform.translation = [0, objectSize, 0] // need fix
        uiView.scene.anchors[1].transform.translation = [offset, objectSize * 3, 0]
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
