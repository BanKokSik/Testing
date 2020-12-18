

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      window = UIWindow(frame: UIScreen.main.bounds)
      let viewController = PreviewViewController()
      let navigationController = UINavigationController(rootViewController: viewController)
      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()

      return true
    }


}
extension AppDelegate{
    static var shared: AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: PreviewViewController{
        return window!.rootViewController as! PreviewViewController
    }
    
}
