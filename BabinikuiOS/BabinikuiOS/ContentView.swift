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
    
    let udpSender = UDPSender(address: "192.168.3.5", portNum: 41234)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARSCNViewContainer
        init (parent: ARSCNViewContainer) {
            self.parent = parent
        }
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
            print("update : " + UUID().uuidString)
            let cs = anchor.transform.columns
            let message = """
            {
                "matrix" : [
                    [\(cs.0.x),\(cs.1.x),\(cs.2.x),\(cs.3.x)],
                    [\(cs.0.y),\(cs.1.y),\(cs.2.y),\(cs.3.y)],
                    [\(cs.0.z),\(cs.1.z),\(cs.2.z),\(cs.3.z)],
                    [\(cs.0.w),\(cs.1.w),\(cs.2.w),\(cs.3.w)]
                ]
            }
            """
            parent.udpSender.send(message: message)
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
