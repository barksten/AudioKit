// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#include "ModulatedDelay.h"
#include "ModulatedDelay_Defines.h"

ModulatedDelay::ModulatedDelay(ModulatedDelayType type, int channelCount, double sampleRate)
: modFreqHz(1.0f)
, modDepthFraction(0.0f)
, effectType(type)
{
    minDelayMs = kChorusMinDelayMs;
    maxDelayMs = kChorusMaxDelayMs;
    modOscillator.init(sampleRate, modFreqHz);
    switch (effectType) {
        case kFlanger:
            minDelayMs = kFlangerMinDelayMs;
            maxDelayMs = kFlangerMaxDelayMs;
            modOscillator.waveTable.triangle();
            break;
        case kChorus:
        default:
            modOscillator.waveTable.sinusoid();
            break;
    }
    delayRangeMs = 0.5f * (maxDelayMs - minDelayMs);
    midDelayMs = 0.5f * (minDelayMs + maxDelayMs);
    leftDelayLine.init(sampleRate, maxDelayMs);
    rightDelayLine.init(sampleRate, maxDelayMs);
    leftDelayLine.setDelayMs(minDelayMs);
    rightDelayLine.setDelayMs(minDelayMs);
}

ModulatedDelay::~ModulatedDelay()
{
    leftDelayLine.deinit();
    rightDelayLine.deinit();
    modOscillator.deinit();
}

void ModulatedDelay::setModFrequencyHz(float freq)
{
    modOscillator.setFrequency(freq);
}

void ModulatedDelay::setLeftFeedback(float feedback)
{
    leftDelayLine.setFeedback(feedback);
}

void ModulatedDelay::setRightFeedback(float feedback)
{
    rightDelayLine.setFeedback(feedback);
}

void ModulatedDelay::Render(unsigned channelCount, unsigned sampleCount,
                              float *inBuffers[], float *outBuffers[])
{
    float *pInLeft   = inBuffers[0];
    float *pInRight  = inBuffers[1];
    float *pOutLeft  = outBuffers[0];
    float *pOutRight = outBuffers[1];
    
    for (int i=0; i < (int)sampleCount; i++)
    {
        float modLeft, modRight;
        modOscillator.getSamples(&modLeft, &modRight);
        
        float leftDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modRight;
        switch (effectType) {
            case kFlanger:
                leftDelayMs = minDelayMs + delayRangeMs * modDepthFraction * (1.0f + modLeft);
                rightDelayMs = minDelayMs + delayRangeMs * modDepthFraction * (1.0f + modRight);
                break;
                
            case kChorus:
            default:
                break;
        }
        leftDelayLine.setDelayMs(leftDelayMs);
        rightDelayLine.setDelayMs(rightDelayMs);
        
        float dryFraction = 1.0f - dryWetMix;
        *pOutLeft++ = dryFraction * (*pInLeft) + dryWetMix * leftDelayLine.push(*pInLeft);
        pInLeft++;
        if (channelCount > 1)
        {
            *pOutRight++ = dryFraction * (*pInRight) + dryWetMix * rightDelayLine.push(*pInRight);
            pInRight++;
        }
    }
    
}
