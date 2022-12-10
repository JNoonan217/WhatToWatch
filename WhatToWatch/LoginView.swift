//
//  LoginView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct LoginView: View {
    enum Field {
        case email, password
    }
    @FirestoreQuery(collectionPath: "shows") var shows: [SavedShow]
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    @State private var showsArr: [SavedShow] = []
    var body: some View {
        NavigationStack{
            
            VStack(spacing: 0) {
                Image("tvcover")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("What to Watch")
                    .foregroundColor(Color("MyColor"))
                    .font(Font.custom("American Typewriter", size: 32))
                    .bold()
            }
            .padding(.bottom, 60)
            
            Group {
                TextField("E-Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign-up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log-In")
                }
                .padding(.leading)
            }
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Color("MyColor"))
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            //if logged in when app runs then moves to listview
            if shows.count > 10 {
                showsArr = Array(shows[0...9])
            } else {
                showsArr = shows
            }
            
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            HomepageView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if  let error = error {
                print("😡SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration Success")
                presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if  let error = error {
                print("😡LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful")
                presentSheet = true
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
