//
//  WelcomeView.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/26/22.
//

import SwiftUI

struct WelcomeView: View {
    var bluetooth = BluetoothController.shared
    @State var displayedTab: Int = 0

    var body: some View {
        TabView(selection: $displayedTab) {
            HelloView(displayedTab: $displayedTab)
                .containerShape(Rectangle())
                .gesture(DragGesture()) // Maybe disable swipe gesture?
                .tag(0)
            PairView(bluetooth: bluetooth, displayedTab: $displayedTab)
                .gesture(DragGesture())
                .tag(1)
            // TODO: Pass ViewModel as env
            LoadingView(displayedTab: $displayedTab)
                .gesture(DragGesture())
                .tag(2)
            // TODO: Pass ViewModel as env
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear(perform: {
               UIScrollView.appearance().isScrollEnabled = false
             })
    }

    struct WelcomeView_Previews: PreviewProvider {
        static var previews: some View {
            WelcomeView()
        }
    }
}

struct HelloView: View {
    @Binding var displayedTab: Int

    var body: some View {
        VStack {
            Text("Welcome")
                .padding(.top, 100)
                .font(.custom("Nunito", size: 40))
                .fontWeight(.black)
                .padding(.bottom, 50)
            Image(systemName: "pawprint.circle.fill")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 200, height: 200)
            Text("Welcome to Feeder! Let's get your devices setup! Click below to get started.")
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Get Started") {
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
    var bluetooth: BluetoothController
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var displayedTab: Int
    @State var list = [BluetoothController.Device]()
    @State var connectedToWifi: Bool = false
    @State var response = Data() { didSet {
        if !response.isEmpty {
            connectedToWifi = true
        } else {
            connectedToWifi = false
        }}}
    @State var isConnected: Bool = BluetoothController.shared.current != nil {
            didSet {
                if isConnected {
                    presented.toggle()
                }
            }
        }
    @State var presented: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "pawprint.circle.fill")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 80, height: 80)
                .padding(.top, 40)
            Text("Pair with Feeder")
                .padding(.top, 30)
                .font(.custom("Nunito", size: 40))
                .fontWeight(.black)
            Text("""
            Select your feeder device from the list below. Check out [the tutorial](https://jdiggity.me/feeder-tutorial) for help with pairing!
            """)
                .font(.custom("Nunito", size: 16))
                .padding(.horizontal, 30)
            if !connectedToWifi {
                List(list) { peripheral in
                    Button(action: { bluetooth.connect(peripheral.peripheral) }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(peripheral.peripheral.name ?? "Unknown")
                            }
                            Spacer()
                            if isConnected {
                                if peripheral.peripheral == bluetooth.current! {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    })
                }.listStyle(.automatic).onAppear {
                    bluetooth.startScanning()
                }.onDisappear {
                    bluetooth.stopScanning()
                }.padding(.vertical, 0)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 130, height: 130)
                    .padding(.top, 50)
            }
            Spacer()
            Button("Next") {
                displayedTab += 1
            }
                .padding()
                .buttonStyle(AppButton())
                .if(!connectedToWifi) { view in
                    view.disabled(true)
                }
        }.onAppear {
            bluetooth.delegate = self
        }.sheet(isPresented: $presented, onDismiss: {
            //bluetooth.disconnect()
        }) {
            WifiLoginView(bluetooth: bluetooth, presented: $presented, displayedTab: $displayedTab)
                .if(!.iOS16) { view in
                    view.presentationDetents([.height(500)])
                }
        }
    }
}

extension PairView: BluetoothProtocol {
    func state(state: BluetoothController.State) {
        switch state {
        case .unknown: print("◦ .unknown")
        case .resetting: print("◦ .resetting")
        case .unsupported: print("◦ .unsupported")
        case .unauthorized: print("◦ .unauthorized")
        case .poweredOff: print("◦ .poweredOff")
        case .poweredOn: print("◦ .poweredOn")
        case .error: print("• error")
        case .connected:
            print("◦ connected to \(bluetooth.current?.name ?? "")")
            isConnected = true
        case .disconnected:
            print("◦ disconnected")
            isConnected = false
        }
    }

    func list(list: [BluetoothController.Device]) {
        self.list = list
    }

    func value(data: Data) {
        response = data
    }
}

struct WifiLoginView: View {
    var bluetooth: BluetoothController
    
    @Binding var presented: Bool
    @Binding var displayedTab: Int
    
    @State var ssidInput: String = ""
    @State var passInput: String = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { presented = false }, label: {
                    Color(UIColor.secondarySystemBackground).overlay(
                        Image(systemName: "multiply").foregroundColor(Color(UIColor.systemGray))
                    ).frame(width: 30, height: 30).cornerRadius(15)
                        .padding([.top, .trailing], 20)
                })
            }
            Text("Get Connected")
                .font(.custom("Nunito", size: 30))
                .fontWeight(.black)
                .padding(.bottom, 25)
                .if(.iOS16) { view in
                    view.padding(.top, 20)
                }
            Image(systemName: "wifi.circle.fill")
                .resizable()
                .foregroundColor(.accentColor)
                .if(.iOS16) { view in
                    view.frame(width: 150, height: 150)
                }
                .if(!.iOS16) { view in
                    view.frame(width: 75, height: 75)
                }
            Text("""
                We just need to connect your feeder to WiFi! Choose your network below and provide your network password to get it connected!
                """)
                .font(.custom("Nunito", size: 18))
                .padding(.vertical, 25)
                .padding(.horizontal, 30)
            TextField("SSID (Network name)", text: $ssidInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 25)
                .padding(.horizontal, 30)
            TextField("Password", text: $passInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .padding(.horizontal, 30)
            Button("Connect") {
                let loginString = "\(ssidInput);\(passInput)"
                bluetooth.send(Array(loginString.utf8))
                presented = false
                // displayedTab += 1
            }.buttonStyle(AppButton())
                .padding()
            Spacer()
        }
    }
}

struct LoadingView: View {
    @Binding var displayedTab: Int
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAnimation: Bool = false
    @State private var success: Bool = false

    var body: some View {
        VStack {
            Text("Verifying Connection...")
            if !success {
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(.green, lineWidth: 8)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle.degrees(showAnimation ? 360 : 0))
                    .animation(.linear(duration: 0.8).repeatForever(autoreverses: false), value: showAnimation)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 200, height: 200)
            }
            Button("Next") {

            }.buttonStyle(AppButton())
                .padding()
        }.onAppear {
            // Show loading
            showAnimation.toggle()
            // Ping ESP32
            // TODO: Get host from CoreData, JIC
            do {
                /*
                let url = URL(string: "http://\(hostname).local/ping")!
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let data = data else { return }
                    guard let resp = String(data: data, encoding: .utf8) else { return }
                    if resp.contains("success") {
                        // We did it, Joe
                        success.toggle()
                        // TODO: Navigate to home screen <3
                    }
                }
                task.resume()
                 */
            } catch {
                print("Couldn't fetch settings")
            }
        }
    }

    struct LoadingView_Previews: PreviewProvider {
        static var previews: some View {
            LoadingView(displayedTab: .constant(0))
        }
    }
}
