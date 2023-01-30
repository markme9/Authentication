//
//  SingUpView.swift
//  Authentication
//
//  Created by Mark on 1/30/23.
//

import SwiftUI
import FirebaseAuth
import Combine

struct SignUpView: View {
    
    @EnvironmentObject var user: User
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isLoading: Bool
    @Binding var error: String
    @State private var cancellables = Set<AnyCancellable>()
    @Environment (\.dismiss) var dismiss
    
    
    var signUpPublisher: AnyPublisher<Void, Error> {
        return Future { promise in
            self.user.auth.createUser(withEmail: self.email, password: self.password) { (result, error) in
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
        VStack {
            Image("signup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350)
                .offset(y: -25)
            
            Text("Sign Up")
                .font(.system(size: 50))
                .fontWeight(.semibold)
                .foregroundStyle(LinearGradient(colors: [Color.purple, Color.pink, Color.yellow, Color.blue], startPoint: .leading, endPoint: .trailing))
                .underline()
            
                .offset(x: -93)
                .offset(y: -20)
            
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
            .offset(y: -20)
            
            
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
            .offset(y: -20)
            
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                
                Button {
                    self.isLoading = true
                    self.signUpPublisher
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
                            // Sign up successful
                            self.user.isLoggedIn = true
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        })
                        .store(in: &self.cancellables)
                    
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                    
                }
                
                Spacer()
            }
            Text(error)
                .foregroundColor(.red)
                .padding()
            
        }.padding()
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isLoading: .constant(false), error: .constant(""))
    }
}
