//
//  MidiModel.swift
//  MC3
//
//  Created by Nicola Rigoni on 26/02/23.
//

import Foundation

struct MidiModel {
    
    func getMidiNumber(step: Step, octave: Int, alter: Int) -> UInt8 {
        var startNumber: Int = 21
        let octaveMultiplier: Int = 12
        
        switch step {
        case .A:
            /* 21 + (octave * 12) */
            startNumber = 21 + (octave * octaveMultiplier)
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .B:
            startNumber = 23 + (octave * octaveMultiplier)
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .C:
            startNumber = 24 + (octave * octaveMultiplier) - octaveMultiplier
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .D:
            startNumber = 26 + (octave * octaveMultiplier) - octaveMultiplier
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .E:
            startNumber = 28 + (octave * octaveMultiplier) - octaveMultiplier
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .F:
            startNumber = 29 + (octave * octaveMultiplier) - octaveMultiplier
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        case .G:
            startNumber = 31 + (octave * octaveMultiplier) - octaveMultiplier
            
            if alter == 1 {
                startNumber += 1
            } else if alter == -1 {
                startNumber -= 1
            }
            
            return UInt8(startNumber)
            
        default:
            return 0
        }
    }
    
}
