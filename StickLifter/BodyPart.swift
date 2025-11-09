import SceneKit
import UIKit

class BodyPart: SCNNode {

    // MARK: - Anatomical Orientation

    enum ConnectionPoint: CaseIterable {
        case superior     // top (+Y)
        case inferior     // bottom (–Y)
        case left         // (–X)
        case right        // (+X)
        case anterior     // front (+Z)
        case posterior    // back (–Z)
    }

    enum AnatomicalAxis {
        case transverse   // vertical (Y-axis)
        case sagittal     // horizontal, left–right (X-axis)
        case coronal      // front–back (Z-axis)
    }


    // MARK: - Properties

    let radius: CGFloat
    let height: CGFloat
    let color: UIColor
    let axis: AnatomicalAxis
    let showConnectionMarkers: Bool


    // MARK: - Initialization

    init(name: String,
         radius: CGFloat,
         height: CGFloat,
         color: UIColor = .white,
         axis: AnatomicalAxis = .transverse,
         showConnectionMarkers: Bool = false) {

        self.radius = radius
        self.height = height
        self.color = color
        self.axis = axis
        self.showConnectionMarkers = showConnectionMarkers

        super.init()

        self.name = name


        // MARK: - Geometry
        let capsule = SCNCapsule(capRadius: radius, height: height)
        let material = SCNMaterial()

        material.diffuse.contents = color
        material.locksAmbientWithDiffuse = true

        capsule.firstMaterial = material
        self.geometry = capsule


        // MARK: - Orientation
        switch axis {
        case .transverse:
            break  // default vertical (Y-axis)
        case .sagittal:
            self.rotation = SCNVector4(0, 0, 1, Float.pi / 2)
        case .coronal:
            self.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        }


        // MARK: - Optional Connection Markers
        if showConnectionMarkers {
            addConnectionMarkers()
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Connection Points

    func connectionPoint(_ point: ConnectionPoint) -> SCNVector3 {
        let halfHeight = Float(height / 2)
        let r = Float(radius)

        switch point {
        case .superior:  return SCNVector3(0,  halfHeight, 0)
        case .inferior:  return SCNVector3(0, -halfHeight, 0)
        case .left:      return SCNVector3(-r, 0, 0)
        case .right:     return SCNVector3( r, 0, 0)
        case .anterior:  return SCNVector3(0, 0,  r)
        case .posterior: return SCNVector3(0, 0, -r)
        }
    }

    // MARK: - Connection Logic

    func connect(from selfPoint: ConnectionPoint,
                 to other: BodyPart,
                 at otherPoint: ConnectionPoint,
                 spacer: CGFloat = 0.0) {

        // local position of our connection point
        let anchor = connectionPoint(selfPoint)

        // the direction that points outward from us (in local space)
        let selfDir = directionVector(for: selfPoint)

        // how far the child’s own connection point is from its center
        let childOffset = vectorLength(other.connectionPoint(otherPoint))

        // total space between the two surfaces
        let totalOffset = childOffset + Float(spacer)

        // place the child so its chosen connection point sits exactly at our connection point
        other.position = SCNVector3(
            x: anchor.x + selfDir.x * totalOffset,
            y: anchor.y + selfDir.y * totalOffset,
            z: anchor.z + selfDir.z * totalOffset
        )

        self.addChildNode(other)
    }

    private func vectorLength(_ v: SCNVector3) -> Float {
        sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    }

    // MARK: - Direction Helper

    private func directionVector(for point: ConnectionPoint) -> SCNVector3 {
        switch point {
        case .superior:  return SCNVector3( 0,  1,  0)
        case .inferior:  return SCNVector3( 0, -1,  0)
        case .left:      return SCNVector3(-1,  0,  0)
        case .right:     return SCNVector3( 1,  0,  0)
        case .anterior:  return SCNVector3( 0,  0,  1)
        case .posterior: return SCNVector3( 0,  0, -1)
        }
    }

    // MARK: - Marker Rendering

    private func addConnectionMarkers() {
        let markerRadius: CGFloat = 0.025   // fixed size, about half a joint

        for point in ConnectionPoint.allCases {
            let sphere = SCNSphere(radius: markerRadius)

            // choose color based on anatomical direction
            let material = SCNMaterial()
            material.locksAmbientWithDiffuse = true

            switch point {
            case .superior, .inferior:
                material.diffuse.contents = UIColor.systemRed
            case .left, .right:
                material.diffuse.contents = UIColor.systemBlue
            case .anterior, .posterior:
                material.diffuse.contents = UIColor.systemYellow
            }

            sphere.firstMaterial = material

            let node = SCNNode(geometry: sphere)
            node.position = connectionPoint(point)

            self.addChildNode(node)
        }
    }
}
