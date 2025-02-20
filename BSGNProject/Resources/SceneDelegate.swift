//
//  SceneDelegate.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    class var shared: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate ?? SceneDelegate()
    }
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        splash()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    func toIntro() {
        do {
            try Auth.auth().signOut()
            let firstVC = IntroViewController(nibName: "IntroViewController", bundle: nil)
            let navController = BaseNavigationController(rootViewController: firstVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        } catch {
            ToastApp.show(error.localizedDescription)
        }
    }
    
    func toPatient() {
        let vc = TabbarController()
        let navController = BaseNavigationController(rootViewController: vc)
        navController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func toDoctor() {
        let vc = DoctorHomeViewController()
        let navController = BaseNavigationController(rootViewController: vc)
//                navController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func splash() {
        let splashVC = SplashViewController()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
    }
    
    func rootApp() {
        guard let userId = Auth.auth().currentUser?.uid else {
            // Not Login
            Global.logout()
            toIntro()
            return
        }
        
        Global.uid = userId
        
        let ref = Database.database().reference()
        
        FirebaseDatabaseService.fetchDoctor(by: userId) { [weak self] result in
            switch result {
            case .success(let doctor):
                print("Doctor fetched successfully: \(doctor)")
                // Xử lý dữ liệu doctor, ví dụ hiển thị giao diện
                Global.doctor = doctor
                Global.role = .doctor
                self?.toDoctor()
            case .failure(let error):
                print("Failed to fetch doctor: \(error.localizedDescription)")
                FirebaseDatabaseService.fetchPatient(by: userId) { [weak self] result in
                    switch result {
                    case .success(let patient):
                        print("Patient fetched successfully: \(patient)")
                        // Xử lý dữ liệu doctor, ví dụ hiển thị giao diện
                        Global.patient = patient
                        Global.role = .patient
                        self?.toPatient()
                    case .failure(let error):
                        print("Failed to fetch doctor: \(error.localizedDescription)")
                        Global.logout()
                        self?.toIntro()
                    }
                }
            }
        }
    }
}

