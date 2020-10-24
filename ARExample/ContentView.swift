//
//  ContentView.swift
//  ARExample
//
//  Created by Den on 2020-10-21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Button("Test button", action: { })
                    .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)
        let material = SimpleMaterial(color: .gray, isMetallic: false)
        let objectSize: Float = 0.03
        let object = MeshResource.generateSphere(radius: objectSize)
        let entity = ModelEntity(mesh: object, materials: [material])
        entity.transform.translation = [0, objectSize, 0]
        anchor.addChild(entity)
        
        let lightObject = PointLight()
        lightObject.light.intensity *= 0.01
        lightObject.transform.translation = [0, objectSize * 3, 0]
        anchor.addChild(lightObject)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
