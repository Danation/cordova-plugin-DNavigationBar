import Foundation
import UIKit
import WebKit

@objc(DNavigationBar) public class DNavigationBar : CDVPlugin, DNavigationBarDelegate {

    // Note: These initializers actually don't do anything.  They need to be initialized again in create() *shrug*
    var navBarController = DNavigationBarController()
    var statusBarHeight:CGFloat = 0
    var homeUrl = ""
    
    override public func pluginInitialize() {
        homeUrl = commandDelegate.settings["homeurl"] as! String;
    }
    
    /*!
    * Creates the Navigation bar.
    * \param command Contains the tint color at index 0
    */
    @objc(create:)
    func create(command : CDVInvokedUrlCommand) {
        navBarController = DNavigationBarController()
        statusBarHeight = 20
        navBarController.delegate = self
        let navBar = navBarController.view as! UINavigationBar
        
        // Set up navigation bar
        navBar.titleTextAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        
        // Set tint color
        if let tint = command.arguments[0] as? NSString {
            navBar.tintColor = colorStringToColor(input: tint)
        }
        
        navBar.frame.origin.y = statusBarHeight
        navBar.isHidden = true
        
        // Add navigation bar to the web view
        
        self.webView?.superview!.addSubview(navBarController.view)
        
        // Add back button
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DNavigationBarDelegate.backButtonTapped))
        navBarController.navItem.leftBarButtonItem = backButton
        navBarController.backButton = backButton
        
        // Add home button
        let homeButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DNavigationBarDelegate.homeButtonTapped))
        navBarController.navItem.rightBarButtonItem = homeButton
        navBarController.homeButton = homeButton
    }
    
    func colorStringToColor(input : NSString) -> UIColor {
        let stringComponents = input.components(separatedBy: ",")
        
        // String to CGFloat conversion
        let cgfloatComponents = stringComponents.map {
            CGFloat(($0 as NSString).doubleValue)/255
        }
        let result = UIColor(red: cgfloatComponents[0],
            green: cgfloatComponents[1],
            blue: cgfloatComponents[2],
            alpha: cgfloatComponents[3])
        return result
    }
    
    /*!
    * Shows/Hides the Back button
    * \param command The visibiliy is at index 0
    */
    @objc(setBackButtonVisible:)
    func setBackButtonVisible(command : CDVInvokedUrlCommand) {
        let shouldShow = command.arguments[0] as! Bool
        if shouldShow {
            navBarController.navItem.setLeftBarButton(navBarController.backButton, animated: false)
        }
        else {
            navBarController.navItem.setLeftBarButton(nil, animated: false)
        }
    }
    
    /*!
    * Shows/Hides the Home button
    * \param command The visibiliy is at index 0
    */
    @objc(setHomeButtonVisible:)
    func setHomeButtonVisible(command : CDVInvokedUrlCommand) {
        let shouldShow = command.arguments[0] as! Bool
        if shouldShow {
            navBarController.navItem.setRightBarButton(navBarController.homeButton, animated: false)
        }
        else {
            navBarController.navItem.setRightBarButton(nil, animated: false)
        }
    }
    
    /*!
    * Event handler for the back button
    */
    public func backButtonTapped() {
        if (self.webView is UIWebView) {
            (self.webView as! UIWebView).goBack()
        }
        else if (self.webView is WKWebView) {
            (self.webView as! WKWebView).goBack()
        }
    }
    
    /*!
    * Event handler for the home button
    */
    public func homeButtonTapped() {
        let request = NSURLRequest(url: NSURL(string: self.homeUrl)! as URL)
        
        if (self.webView is UIWebView) {
            (self.webView as! UIWebView).loadRequest(request as URLRequest)
        }
        else {
            (self.webView as! WKWebView).load(request as URLRequest)
        }
    }
    
    /*!
    * Shows/Hides the whole navigation bar
    * \param command The visibiliy is at index 0
    */
    @objc(setVisible:)
    func setVisible(command : CDVInvokedUrlCommand) {
        let shouldShow = command.arguments[0] as! Bool
        let navBar = navBarController.view as! UINavigationBar
        navBar.isHidden = !shouldShow
    }
    
    /*!
    * Sets the title of the navigation bar
    * \param command The title is at index 0
    */
    @objc(setTitle:)
    func setTitle(command : CDVInvokedUrlCommand) {
        let title = command.arguments[0] as! String
        navBarController.navItem.title = title
    }
}

@objc(DNavigationBarDelegate) public protocol DNavigationBarDelegate {
    func backButtonTapped()
    func homeButtonTapped()
}

@objc(DNavigationBarController) public class DNavigationBarController : UIViewController {
    public var backButton = UIBarButtonItem()
    public var homeButton = UIBarButtonItem()
    public var navItem = UINavigationItem()
    public var delegate:DNavigationBarDelegate?
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.sizeToFit()
    }
}