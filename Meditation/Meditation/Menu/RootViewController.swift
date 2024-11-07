//
//  RootViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit
import FDWaveformView
import FirebaseRemoteConfig
import WebKit

class RootViewController: UIViewController {
    private var remoteConfig: RemoteConfig!
    private var webViewController: WebViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundsViewModel.shared.preGenerateWaveformViews {
            for form in SoundsViewModel.shared.waveformViews {
                form.value.frame.origin.y = -1000
                self.view.addSubview(form.value)
            }
        }
        
        if isFirstLaunch() {
            if !NetworkMonitor.shared.isConnected {
                showAlert("No network connection available")
            }
        }
        
        if let savedUrl = (UIApplication.shared.delegate as? AppDelegate)?.getSavedUrl() {
            loadWebView(with: savedUrl, showAgreeButton: false)
        } else if isFirstLaunch() {
            initializeRemoteConfig()
        } else {
            if let menuVC = storyboard?.instantiateViewController(identifier: "MenuViewController") {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.viewControllers = [menuVC]
            }
        }
    }
    
    private func loadWebView(with urlString: String, showAgreeButton: Bool) {
        webViewController = WebViewController()
        webViewController?.currentUrlString = urlString
        webViewController?.showAgreeButton = showAgreeButton
        webViewController?.completion = { [weak self] in
            guard let self = self else { return }
            if let menuVC = storyboard?.instantiateViewController(identifier: "MenuViewController") {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.viewControllers = [menuVC]
            }
        }
        self.navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    private func initializeRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        fetchRemoteConfigLink()
    }
    
    private func fetchRemoteConfigLink() {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard error == nil else {
                print("Failed to fetch RemoteConfig: \(error!)")
                return
            }
            
            if let privacyLink = self?.remoteConfig["privacyLink"].stringValue, !privacyLink.isEmpty {
                self?.loadWebView(with: privacyLink, showAgreeButton: true)
            } else {
                print("Privacy link is empty in RemoteConfig.")
            }
        }
    }
    

    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
