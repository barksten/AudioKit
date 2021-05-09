// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Physical model of the sound of dripping water. 
/// When triggered, it will produce a droplet of water.
/// 
public class Drip: NodeBase, AudioUnitContainer {

    /// Unique four-letter identifier "drip"
    public static let ComponentDescription = AudioComponentDescription(instrument: "drip")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for intensity
    public static let intensityDef = NodeParameterDef(
        identifier: "intensity",
        name: "The intensity of the dripping sounds.",
        address: akGetParameterAddress("DripParameterIntensity"),
        defaultValue: 10,
        range: 0 ... 100,
        unit: .generic,
        flags: .default)

    /// The intensity of the dripping sound.
    @Parameter(intensityDef) public var intensity: AUValue

    /// Specification details for dampingFactor
    public static let dampingFactorDef = NodeParameterDef(
        identifier: "dampingFactor",
        name: "The damping factor. Maximum value is 2.0.",
        address: akGetParameterAddress("DripParameterDampingFactor"),
        defaultValue: 0.2,
        range: 0.0 ... 2.0,
        unit: .generic,
        flags: .default)

    /// The damping factor. Maximum value is 2.0.
    @Parameter(dampingFactorDef) public var dampingFactor: AUValue

    /// Specification details for energyReturn
    public static let energyReturnDef = NodeParameterDef(
        identifier: "energyReturn",
        name: "The amount of energy to add back into the system.",
        address: akGetParameterAddress("DripParameterEnergyReturn"),
        defaultValue: 0,
        range: 0 ... 100,
        unit: .generic,
        flags: .default)

    /// The amount of energy to add back into the system.
    @Parameter(energyReturnDef) public var energyReturn: AUValue

    /// Specification details for mainResonantFrequency
    public static let mainResonantFrequencyDef = NodeParameterDef(
        identifier: "mainResonantFrequency",
        name: "Main resonant frequency.",
        address: akGetParameterAddress("DripParameterMainResonantFrequency"),
        defaultValue: 450,
        range: 0 ... 22_000,
        unit: .hertz,
        flags: .default)

    /// Main resonant frequency.
    @Parameter(mainResonantFrequencyDef) public var mainResonantFrequency: AUValue

    /// Specification details for firstResonantFrequency
    public static let firstResonantFrequencyDef = NodeParameterDef(
        identifier: "firstResonantFrequency",
        name: "The first resonant frequency.",
        address: akGetParameterAddress("DripParameterFirstResonantFrequency"),
        defaultValue: 600,
        range: 0 ... 22_000,
        unit: .hertz,
        flags: .default)

    /// The first resonant frequency.
    @Parameter(firstResonantFrequencyDef) public var firstResonantFrequency: AUValue

    /// Specification details for secondResonantFrequency
    public static let secondResonantFrequencyDef = NodeParameterDef(
        identifier: "secondResonantFrequency",
        name: "The second resonant frequency.",
        address: akGetParameterAddress("DripParameterSecondResonantFrequency"),
        defaultValue: 750,
        range: 0 ... 22_000,
        unit: .hertz,
        flags: .default)

    /// The second resonant frequency.
    @Parameter(secondResonantFrequencyDef) public var secondResonantFrequency: AUValue

    /// Specification details for amplitude
    public static let amplitudeDef = NodeParameterDef(
        identifier: "amplitude",
        name: "Amplitude.",
        address: akGetParameterAddress("DripParameterAmplitude"),
        defaultValue: 0.3,
        range: 0 ... 1,
        unit: .generic,
        flags: .default)

    /// Amplitude.
    @Parameter(amplitudeDef) public var amplitude: AUValue

    // MARK: - Initialization

    /// Initialize this drip node
    ///
    /// - Parameters:
    ///   - intensity: The intensity of the dripping sound.
    ///   - dampingFactor: The damping factor. Maximum value is 2.0.
    ///   - energyReturn: The amount of energy to add back into the system.
    ///   - mainResonantFrequency: Main resonant frequency.
    ///   - firstResonantFrequency: The first resonant frequency.
    ///   - secondResonantFrequency: The second resonant frequency.
    ///   - amplitude: Amplitude.
    ///
    public init(
        intensity: AUValue = intensityDef.defaultValue,
        dampingFactor: AUValue = dampingFactorDef.defaultValue,
        energyReturn: AUValue = energyReturnDef.defaultValue,
        mainResonantFrequency: AUValue = mainResonantFrequencyDef.defaultValue,
        firstResonantFrequency: AUValue = firstResonantFrequencyDef.defaultValue,
        secondResonantFrequency: AUValue = secondResonantFrequencyDef.defaultValue,
        amplitude: AUValue = amplitudeDef.defaultValue
    ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.intensity = intensity
            self.dampingFactor = dampingFactor
            self.energyReturn = energyReturn
            self.mainResonantFrequency = mainResonantFrequency
            self.firstResonantFrequency = firstResonantFrequency
            self.secondResonantFrequency = secondResonantFrequency
            self.amplitude = amplitude
        }
    }

    // MARK: - Control

    /// Trigger the sound with an optional set of parameters
    ///
    public func trigger() {
        internalAU?.start()
        internalAU?.trigger()
    }

}
