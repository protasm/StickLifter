import SceneKit
import UIKit

func StickFigureScene() -> SCNScene {
    let scene = SCNScene()
    scene.background.contents = UIColor.white

    // MARK: - Parts
    let head = BodyPart(name: "Head", radius: 0.5, height: 1.0)
    let neck = BodyPart(name: "Neck", radius: 0.1, height: 0.4)
    let shoulders = BodyPart(name: "Shoulders", radius: 0.1, height: 2.0)
    let torso = BodyPart(name: "Torso", radius: 0.5, height: 4.0)
    let armLeftUpper = BodyPart(name: "ArmLeftUpper", radius: 0.25, height: 2.0)
    let armLeftLower = BodyPart(name: "ArmLeftLower", radius: 0.20, height: 2.0)
    let armRightUpper = BodyPart(name: "ArmRightUpper", radius: 0.25, height: 2.0)
    let armRightLower = BodyPart(name: "ArmRightLower", radius: 0.20, height: 2.0)

    shoulders.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)

    // MARK: - Scene hierarchy root
    let figureRoot = SCNNode()

    // Add both to the same coordinate space before connecting
    figureRoot.addChildNode(head)
    figureRoot.addChildNode(neck)
    figureRoot.addChildNode(shoulders)
    figureRoot.addChildNode(torso)
    figureRoot.addChildNode(armLeftUpper)
    figureRoot.addChildNode(armLeftLower)
    figureRoot.addChildNode(armRightUpper)
    figureRoot.addChildNode(armRightLower)

    // Now connect in world-space
    head.connect(from: .Y2, to: neck, at: .Y1)
    neck.connect(from: .Y2, to: shoulders, at: .X2)
    shoulders.connect(from: .X1, to: torso, at: .Y1)
    shoulders.connect(from: .Y1, to: armLeftUpper, at: .Y1)
    armLeftUpper.connect(from: .Y2, to: armLeftLower, at: .Y1)
    shoulders.connect(from: .Y2, to: armRightUpper, at: .Y1)
    armRightUpper.connect(from: .Y2, to: armRightLower, at: .Y1)

    scene.rootNode.addChildNode(figureRoot)

    // MARK: - Reference arrow
    let forwardArrow = Arrow(length: 1.0)

    forwardArrow.position = SCNVector3(0, 1.5, 1.0)
    scene.rootNode.addChildNode(forwardArrow)

    // MARK: - Camera
    let cameraNode = SceneFactory.orthoCam(scale: 4.0, zPosition: 8.0)

    scene.rootNode.addChildNode(cameraNode)

    return scene
}
