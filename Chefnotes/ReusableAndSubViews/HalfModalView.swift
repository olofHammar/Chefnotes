//
//  HalfModalView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-05.
//

import SwiftUI

struct HalfModalView<Content:View>: View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var isShown: Bool
    var isNear_tabView = false
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = modalHeight * (2/3)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold {
            UIApplication.shared.endEditing()
            isShown = false
        }
    }
    //modalHeight sätter höjden på HalfModalView
    var modalHeight: CGFloat = 400
    
    var content: () -> Content
    var body: some View {
        
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return Group {
            //Background. Bakgrundens opacity ändras när modal dras upp och ner.
            ZStack{
                Spacer()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    .background(isShown ? Color.black.opacity(0.5 * fractionProgress(lowerLimit: 0, upperLimit: Double(modalHeight), current: Double(dragState.translation.height), inverted: true)) :
                                    Color.clear)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                //Varje gång vi stänger halfModal med tapGesture så stänger vi också tangentbordet om det är uppe
                                //Vi sätter också isShown till false
                                UIApplication.shared.endEditing()
                                self.isShown = false
                            }
                    )
            }
            //Foreground
            VStack{
                Spacer()
                ZStack{
                    Color("ColorWhiteLightBlack").opacity(1.0)
                        .frame(width: UIScreen.main.bounds.size.width, height: modalHeight)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    self.content()
                        .padding()
                        .frame(width: UIScreen.main.bounds.size.width, height: modalHeight)
                        .clipped()
                    if isNear_tabView {
                        Spacer().frame(height:65)
                    }
                }
                //offset läser av när användaren drar halfModal neråt
                .offset(y: isShown ? ((self.dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                .gesture(drag)
            }.KeyboardAwarePadding()
            
        }.edgesIgnoringSafeArea(.all)
    }
}
