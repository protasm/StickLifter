import SceneKit
import UIKit

class BodyPart: SCNNode {

    // MARK: - Connection Points (neutral, axis-based)
    enum ConnectionPoint: CaseIterable {
        case X1   // local -X
        case X2   // local +X
        case Y1   // local +Y
        case Y2   // local -Y
        case Z1   // local +Z
        case Z2   // local -Z
    }

    // MARK: - Properties
    let radius: CGFloat
    let height: CGFloat
    let color: UIColor
    let showMarkers: Bool

    // MARK: - Init
    init(name: String,
         radius: CGFloat,
         height: CGFloat,
         color: UIColor = .white,
         showMarkers: Bool = true) {

        self.radius = radius
        self.height = height
        self.color = color
        self.showMarkers = showMarkers

        super.init()
        self.name = name

        // Capsule geometry
        let capsule = SCNCapsule(capRadius: radius, height: height)
        let mat = SCNMaterial()
        mat.diffuse.contents = color
        mat.locksAmbientWithDiffuse = true
        capsule.firstMaterial = mat
        self.geometry = capsule

        // Optional debug markers
        if showMarkers {
            addConnectionMarkers()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Connection Point Local Vectors
    func connectionPoint(_ point: ConnectionPoint) -> SCNVector3 {
        let h = Float(height / 2)
        let r = Float(radius)
        switch point {
        case .X1: return SCNVector3(-r, 0, 0)
        case .X2: return SCNVector3( r, 0, 0)
        case .Y1: return SCNVector3(0,  h, 0)
        case .Y2: return SCNVector3(0, -h, 0)
        case .Z1: return SCNVector3(0, 0,  r)
        case .Z2: return SCNVector3(0, 0, -r)
        }
    }

    // MARK: - Connection Logic
    @discardableResult
    func connect(from selfPoint: ConnectionPoint,
                 to other: BodyPart,
                 at otherPoint: ConnectionPoint,
                 rotation: SCNVector3? = nil,
                 spacer: CGFloat = 0.0) -> SCNNode {

        let joint = SCNNode()
        joint.name = "\(self.name ?? "Parent")_to_\(other.name ?? "Child")_joint"

        // Optional rotation
        if let rot = rotation {
            other.eulerAngles = rot
        }

        // Convert connection markers to world coordinates
        let parentWorldPos = self.convertPosition(connectionPoint(selfPoint), to: nil)
        let childWorldPos  = other.convertPosition(other.connectionPoint(otherPoint), to: nil)

        // Compute offset vector to align child marker to parent marker
        let offset = SCNVector3(
            parentWorldPos.x - childWorldPos.x,
            parentWorldPos.y - childWorldPos.y,
            parentWorldPos.z - childWorldPos.z
        )

        // Position child so its connection point coincides with parent's
        other.position = offset

        // Optional spacer along parent's connection axis
        let dir = directionVector(for: selfPoint)
        let worldDir = self.convertVector(dir, to: nil)
        other.position.x += worldDir.x * Float(spacer)
        other.position.y += worldDir.y * Float(spacer)
        other.position.z += worldDir.z * Float(spacer)

        // Attach both to the same root as the parent
        self.parent?.addChildNode(joint)
        joint.addChildNode(other)

        return joint
    }

    // MARK: - Direction Helpers
    private func directionVector(for point: ConnectionPoint) -> SCNVector3 {
        switch point {
        case .X1: return SCNVector3(-1, 0, 0)
        case .X2: return SCNVector3( 1, 0, 0)
        case .Y1: return SCNVector3( 0, 1, 0)
        case .Y2: return SCNVector3( 0,-1, 0)
        case .Z1: return SCNVector3( 0, 0, 1)
        case .Z2: return SCNVector3( 0, 0,-1)
        }
    }

    // MARK: - Debug Markers
    private func addConnectionMarkers() {
        let markerRadius: CGFloat = 0.05

        for point in ConnectionPoint.allCases {
            let sphere = SCNSphere(radius: markerRadius)
            let mat = SCNMaterial()
            mat.locksAmbientWithDiffuse = true

            // Color-code by axis
            switch point {
            case .X1, .X2: mat.diffuse.contents = UIColor.systemBlue
            case .Y1, .Y2: mat.diffuse.contents = UIColor.systemRed
            case .Z1, .Z2: mat.diffuse.contents = UIColor.systemYellow
            }

            sphere.firstMaterial = mat
            let node = SCNNode(geometry: sphere)
            node.position = connectionPoint(point)
            self.addChildNode(node)
        }
    }
}
