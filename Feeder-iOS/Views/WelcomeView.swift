//
//  WelcomeView.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/26/22.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var bluethooth = BluetoothController.shared
    @State var displayedTab: Int = 0

    var body: some View {
        TabView(selection: $displayedTab) {
            HelloView(displayedTab: $displayedTab)
                .containerShape(Rectangle())
                .gesture(DragGesture()) // Maybe disable swipe gesture?
                .tag(0)
            PairView(displayedTab: $displayedTab)
                .gesture(DragGesture())
                .tag(1)
            WifiLoginView(displayedTab: $displayedTab)
                .gesture(DragGesture())
                .tag(2)
            LoadingView(displayedTab: $displayedTab)
                .gesture(DragGesture())
                .tag(3)
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear(perform: {
               UIScrollView.appearance().isScrollEnabled = false
             })
    }

    struct WelcomeView_Previews: PreviewProvider {
        static var previews: some View {
            WelcomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

struct HelloView: View {
    @Binding var displayedTab: Int

    var body: some View {
        VStack {
            Text("Hello")
            Button("Next") {
                displayedTab += 1
            }.buttonStyle(AppButton())
                .padding()
        }
    }
    
    struct HelloView_Previews: PreviewProvider {
        static var previews: some View {
            HelloView(displayedTab: .constant(0))
        }
    }
}

struct PairView: View {
    @Binding var displayedTab: Int

    var body: some View {
        VStack {
            Text("Pair")
            Button("Next") {
                displayedTab += 1
            }.buttonStyle(AppButton())
                .padding()
        }
    }
    struct PairView_Previews: PreviewProvider {
        static var previews: some View {
            PairView(displayedTab: .constant(0))
        }
    }
}

struct WifiLoginView: View {
    @Binding var displayedTab: Int

    var body: some View {
        VStack {
            Text("WifiLogin")
            Button("Next") {
                displayedTab += 1
            }.buttonStyle(AppButton())
                .padding()
        }
    }

    struct WifiLoginView_Previews: PreviewProvider {
        static var previews: some View {
            WifiLoginView(displayedTab: .constant(0))
        }
    }
}

struct LoadingView: View {
    @Binding var displayedTab: Int

    var body: some View {
        VStack {
            Text("Loading")
            Button("Next") {
                displayedTab += 1
            }.buttonStyle(AppButton())
                .padding()
        }
    }
    
    struct LoadingView_Previews: PreviewProvider {
        static var previews: some View {
            LoadingView(displayedTab: .constant(0))
        }
    }
}
