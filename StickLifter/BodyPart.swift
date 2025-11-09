import SceneKit
import UIKit

class BodyPart: SCNNode {

    // MARK: - Connection Points (neutral axis-based)
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

    // MARK: - Initialization
    init(name: String,
         radius: CGFloat,
         height: CGFloat,
         color: UIColor = .white,
         showMarkers: Bool = false) {

        self.radius = radius
        self.height = height
        self.color = color
        self.showMarkers = showMarkers

        super.init()

        self.name = name

        // Capsule geometry
        let capsule = SCNCapsule(capRadius: radius, height: height)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.locksAmbientWithDiffuse = true
        capsule.firstMaterial = material
        self.geometry = capsule

        // Optional markers
        if showMarkers {
            addConnectionMarkers()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Connection Point Vectors
    func connectionPoint(_ point: ConnectionPoint) -> SCNVector3 {
        // SCNCapsule.height represents only the cylindrical section.
        // The hemispherical caps add an extra radius to each end, so the
        // total half-height is height/2 + radius.
        let radial = Float(radius)
        let axial = Float(height / 2 + radius)

        switch point {
        case .X1: return SCNVector3(-radial, 0, 0)
        case .X2: return SCNVector3( radial, 0, 0)
        case .Y1: return SCNVector3(0,  axial, 0)
        case .Y2: return SCNVector3(0, -axial, 0)
        case .Z1: return SCNVector3(0, 0,  radial)
        case .Z2: return SCNVector3(0, 0, -radial)
        }
    }

    // MARK: - Connection Logic
    @discardableResult
    func connect(from selfPoint: ConnectionPoint,
                 to other: BodyPart,
                 at otherPoint: ConnectionPoint,
                 rotation: SCNVector3? = nil,
                 spacer: CGFloat = 0.0) -> SCNNode {

        // Create a joint container for hierarchy and optional visualization
        let joint = SCNNode()
        joint.name = "\(self.name ?? "Parent")_to_\(other.name ?? "Child")_joint"

        // Optional rotation for the child before placement
        if let rot = rotation {
            other.eulerAngles = rot
        }

        // Get the parent connection point in this part’s local space
        let parentAnchorLocal = connectionPoint(selfPoint)

        // Prepare joint marker
        let jointMarker = SCNSphere(radius: 0.05)
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.systemGreen
        jointMarker.firstMaterial = mat
        joint.geometry = jointMarker
        joint.position = parentAnchorLocal

        // Build hierarchy before aligning the child so convertPosition works
        self.addChildNode(joint)
        joint.addChildNode(other)

        // Determine the child anchor location in joint space taking rotation into account
        let childAnchorLocal = other.connectionPoint(otherPoint)
        let childAnchorInJoint = other.convertPosition(childAnchorLocal, to: joint)

        other.position = SCNVector3(
            -childAnchorInJoint.x,
            -childAnchorInJoint.y,
            -childAnchorInJoint.z
        )

        // Optional spacer along the parent's direction vector
        let dir = directionVector(for: selfPoint)
        other.position.x += dir.x * Float(spacer)
        other.position.y += dir.y * Float(spacer)
        other.position.z += dir.z * Float(spacer)

        return joint
    }

    // MARK: - Helpers
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

    // MARK: - Connection Markers
    private func addConnectionMarkers() {
        let markerRadius: CGFloat = 0.05

        for point in ConnectionPoint.allCases {
            let sphere = SCNSphere(radius: markerRadius)
            let mat = SCNMaterial()
            mat.locksAmbientWithDiffuse = true

            // color-code by axis
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
