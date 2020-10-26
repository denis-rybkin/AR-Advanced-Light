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
    
    let arView = ARView(frame: .zero)
    let material = SimpleMaterial(color: .gray, roughness: 0.5, isMetallic: false)
    
    func makeUIView(context: Context) -> ARView {
        arView.renderOptions = ARView.RenderOptions.disableGroundingShadows
//        addSphere(arView)
        addPlane(arView)
        addLight(arView)
        return arView
    }
    
    private func addSphere(_ arView: ARView) {
        let sphereAnchor = AnchorEntity(plane: .horizontal)
        let object = MeshResource.generateSphere(radius: objectSize)
        let sphereEntity = ModelEntity(mesh: object, materials: [material])
        sphereAnchor.addChild(sphereEntity)
        arView.scene.anchors.append(sphereAnchor)
        sphereEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation], for: sphereEntity)
    }
    
    private func addLight(_ arView: ARView, needDebugObject: Bool = true) {
        let lightAnchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(lightAnchor)
        if needDebugObject {
            let lightObject = MeshResource.generateSphere(radius: objectSize / 4)
            let lightEntity = ModelEntity(mesh: lightObject, materials: [material])
            lightAnchor.addChild(lightEntity)
        } else {
            let lightObject = PointLight()
            lightObject.light.intensity *= 0.01
            lightAnchor.addChild(lightObject)
        }
    }
    
    private func addPlane(_ arView: ARView) {
        let anchor = AnchorEntity(plane: .horizontal)
        let object = MeshResource.generatePlane(width: 0.3, depth: 0.19,
                                                cornerRadius: 0.01)
        let entity = ModelEntity(mesh: object, materials: [material])
        anchor.addChild(entity)
        arView.scene.anchors.append(anchor)
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.all], for: entity)
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
