//
//  ContentView.swift
//  Authentication
//
//  Created by Mark on 1/29/23.
//

import SwiftUI
import FirebaseAuth
import Combine


class User: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    let auth = FirebaseAuth.Auth.auth()
    func signOut() {
        do {
            try auth.signOut()
            self.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var user: User
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoading: Bool = false
    @State var error: String = ""
    @State var showSignUp = false
    
    var signInPublisher: AnyPublisher<Void, Error> {
        return Future { promise in
            self.user.auth.signIn(withEmail: self.email, password: self.password) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    var body: some View {
        NavigationView {
            if !user.isLoggedIn {
                VStack {
                    Image("login")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)
                        .offset(y: -50)
                    
                    Text("Sign In")
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .foregroundStyle(LinearGradient(colors: [Color.purple, Color.pink, Color.yellow, Color.blue], startPoint: .leading, endPoint: .trailing))
                        .underline()
                    
                        .offset(y: -40)
                        .offset(x: -105)
                    
                    HStack {
                        Image(systemName: "at")
                        
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                    }
                    .padding(.vertical, 6)
                    .background(Divider(), alignment: .bottom)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 8)
                    .offset(y: -50)
                    
                    HStack {
                        Image(systemName: "lock")
                        
                        
                        SecureField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                    }
                    .padding(.vertical, 6)
                    .background(Divider(), alignment: .bottom)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 8)
                    .offset(y: -50)
                    
                    
                    if isLoading {
                        ProgressView()
                            .padding()
                        
                    } else {
                        Button(action: {
                            self.isLoading = true
                            self.signInPublisher
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { (completion) in
                                    switch completion {
                                    case .failure(let error):
                                        self.error = error.localizedDescription
                                    case .finished:
                                        break
                                    }
                                    self.isLoading = false
                                }, receiveValue: { _ in
                                    // Sign in successful
                                    user.isLoggedIn = true
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                })
                                .store(in: &self.cancellables)
                        }) {
                            Text("Sign In")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(15)
                        }
                        .offset(y: -25)
                        HStack {
                            Text("Don't have an account yet?")
                            Button {
                                self.showSignUp.toggle()
                            } label: {
                                Text("Sign Up")
                                
                            }
                        }
                        .offset(y: 100)
                    }
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .offset(y: -30)
                    
                }
                .padding()
                
            } else {
                HomeView().environmentObject(user)
            }
        }
        .sheet(isPresented: $showSignUp, content: {
            SignUpView(isLoading: $isLoading, error: $error)
        })
        
        .onAppear {
            self.user.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(User())
        
    }
}
