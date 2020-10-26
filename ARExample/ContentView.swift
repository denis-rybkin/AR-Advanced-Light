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
    let keyboardDepth: Float = 0.19
    let keyboardWidth: Float = 0.3
    
    let lightHeight: Float = 0.05
    var lightDepth: Float { -keyboardDepth/2 }
    
    let needDebug = true
    
    func makeUIView(context: Context) -> ARView {
        if needDebug {
            arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins]
        }
        arView.renderOptions = ARView.RenderOptions.disableGroundingShadows
        addPlane(arView)
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
    
    private func makeLight() -> Entity {
        if needDebug {
            let lightObject = MeshResource.generateSphere(radius: objectSize / 4)
            let lightEntity = ModelEntity(mesh: lightObject, materials: [material])
            return lightEntity
        } else {
            let lightObject = PointLight()
            lightObject.light.intensity *= 0.01
            return lightObject
        }
    }
    
    private func addPlane(_ arView: ARView) {
        let anchor = AnchorEntity(plane: .horizontal)
        let object = MeshResource.generatePlane(width: keyboardWidth,
                                                depth: keyboardDepth,
                                                cornerRadius: 0.01)
        let entity = ModelEntity(mesh: object, materials: [material])
        anchor.addChild(entity)
        arView.scene.anchors.append(anchor)
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: entity)
        let lightEntity = makeLight()
        entity.addChild(lightEntity)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // light
        uiView.scene.anchors[0].children[0].children[0]
                    .transform.translation = [offset, lightHeight, lightDepth]
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
