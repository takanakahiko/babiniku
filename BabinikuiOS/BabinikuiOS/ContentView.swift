//
//  ContentView.swift
//  BabinikuiOS
//
//  Created by takanakahiko on 2021/05/18.
//

import SwiftUI
import ARKit

struct ContentView: View {
    var body: some View {
        ARSCNViewContainer()
    }
}

struct ARSCNViewContainer: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard anchor is ARFaceAnchor else { return }
            print("add")
            DispatchQueue.main.async {
                if node.childNodes.isEmpty {
                    let url = Bundle.main.url(forResource: "coordinateOrigin", withExtension: "scn", subdirectory: "Models.scnassets")!
                    let contentNode = SCNReferenceNode(url: url)!
                    contentNode.load()
                    node.addChildNode(contentNode)
                }
            }
        }
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard anchor is ARFaceAnchor else { return }
            print("update" + UUID().uuidString)
            
        }
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            print("remove")
        }
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        let config = ARFaceTrackingConfiguration()
        sceneView.session.run(config)
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
