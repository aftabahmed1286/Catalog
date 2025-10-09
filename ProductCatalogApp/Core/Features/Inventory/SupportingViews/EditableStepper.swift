//
//  EditableStepper.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI

struct EditStepper: View {
    let label: String
    @Binding var value: Int
    let minimum: Int
    
    init(label: String, value: Binding<Int>, minimum: Int) {
        self.label = label
        _value = value
        self.minimum = minimum
    }
    
    var body: some View {
        HStack {
            
            Text(label)
            
            Stepper {
                TextField("", value: $value, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .onChange(of: value) { oldValue, newValue in
                        if newValue < minimum {
                            value = minimum
                        }
                    }
            } onIncrement: {
                value += 1
            } onDecrement: {
                if value > minimum {
                    value -= 1
                }
            }
        }
    }
}

//#Preview {
//    @Previewable @State var test: Int = 1
//    EditStepper(label: "Units per Carton" ,value: $test, minimum: 1)
//}
