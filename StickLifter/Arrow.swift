import SceneKit
import UIKit

class Arrow: SCNNode {

    init(length: CGFloat = 1.0,
         shaftRadius: CGFloat = 0.02,
         color: UIColor = .systemYellow) {
        super.init()

        // shaft (cylinder)
        let shaft = SCNCylinder(radius: shaftRadius, height: length * 0.8)
        let shaftMat = SCNMaterial()
        shaftMat.diffuse.contents = color
        shaft.firstMaterial = shaftMat

        let shaftNode = SCNNode(geometry: shaft)
        shaftNode.position = SCNVector3(0, Float(length * 0.4), 0) // center vertically

        // head (cone)
        let cone = SCNCone(topRadius: 0, bottomRadius: shaftRadius * 2.5, height: length * 0.2)
        let coneMat = SCNMaterial()
        coneMat.diffuse.contents = color
        cone.firstMaterial = coneMat

        let coneNode = SCNNode(geometry: cone)
        coneNode.position = SCNVector3(0, Float(length * 0.9), 0)

        // assemble
        addChildNode(shaftNode)
        addChildNode(coneNode)

        // orient arrow to point along +Z (forward)
        self.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
