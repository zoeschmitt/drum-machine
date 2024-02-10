//
//  ContentView.swift
//  ThisIsReality
//
//  Created by Zoe Schmitt on 2/3/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))

        arView.scene.anchors.append(anchor)
        arView.addGestureRecognizer(tapGestureRecognizer)

        var cards: [Entity] = []

        for _ in 1...16 {
            let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
            let model = ModelEntity(mesh: box, materials: [metalMaterial])
            model.generateCollisionShapes(recursive: true)
            cards.append(model)
        }

        for (index, card) in cards.enumerated() {
            let x = Float(index % 4)
            let z = Float(index / 4)

            print(index, x, z)

            card.position = [x * 0.1, 0, z * 0.1]
            anchor.children.append(card)
        }

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject {
        var parent: ARViewContainer

        init(_ parent:ARViewContainer) {
            self.parent = parent
        }
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let location=sender.location(in:sender.view)
            if let arView = sender.view as? ARView {
                let results = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .any)
                for result in results {
                    print(result.target)
                    print(location)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
