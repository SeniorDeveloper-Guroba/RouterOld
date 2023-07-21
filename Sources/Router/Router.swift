import UIKit
import Combine

// MARK: - It is responsible for creating navigation in App
final public class RouterService {
    
    // MARK: - VC
    private var newNavigationVC: UINavigationController?
    private var currentWindow  : UIWindow?
    
    private var currentVC: UIViewController? {
        self.currentWindow?.visibleViewController()
    }
    
    // MARK: - Lazy
    private var navigationViewController: UINavigationController?
    private var tabBarController: UITabBarController?
    
    // MARK: - private properties
    private var anyCancel: Set<AnyCancellable> = []
    
    // MARK: - Логика переключения в навигационном контроллере
    public func pushMainNavigation(
        to viewController: UIViewController,
        animated: Bool = false
    ) {
        guard !self.isEqualTopVC(with: viewController) else { return }
        self.navigationViewController?.pushViewController(viewController, animated: animated)
    }
    
	public func setupNavigationVC(with rootViewController: UIViewController, window: UIWindow? = nil){
		self.navigationViewController = UINavigationController(rootViewController: rootViewController)
		guard let window = window else { return }
		//создаем рутовый контроллер
		window.rootViewController = self.navigationViewController
		window.makeKeyAndVisible()
		currentWindow = window
    }
    
    public func setupTabBarControllerVC(with tabBarController: UITabBarController){
        self.tabBarController = tabBarController
    }
    
    public func switchTabBar(with selectedIndex: Int){
        self.tabBarController?.selectedIndex = selectedIndex
    }
    
    public func popMainNavigation(
        to viewController: UIViewController,
        animated: Bool
    ) {
        self.navigationViewController?.popToViewController(viewController, animated: animated)
    }
    
    public func popMainNavigation(animated: Bool){
        self.navigationViewController?.popViewController(animated: true)
    }
    
    public func setupMainNavigationVC(
        isNavigationBarHidden: Bool = false,
        animatedHidden: Bool = false,
        tintColor: UIColor = .blue,
        backButtonTitle: String,
        title: String
    ) {
        self.navigationViewController?.navigationBar.tintColor        = tintColor
        self.navigationViewController?.navigationBar.backItem?.title  = backButtonTitle
        self.navigationViewController?.navigationBar.isTranslucent    = true
        self.navigationViewController?.title                          = title
        self.navigationViewController?.navigationItem.backButtonTitle = backButtonTitle
        self.navigationViewController?.navigationBar.shadowImage      = UIImage()
        self.navigationViewController?.setNavigationBarHidden(isNavigationBarHidden, animated: animatedHidden)
    }
    
    // MARK: - Логика установки рутового контроллера
    public func setRootViewController(
        window: inout UIWindow?,
        viewController rootViewController: UIViewController
    ) {
        window = UIWindow()
        //создаем рутовый контроллер
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        currentWindow = window
    }
	
	public func setWindow(
		window: UIWindow?
	) {
		currentWindow = window
	}
    
    // MARK: - Логика отображения в контроле другой контроллер
    public func present(
        with presentType: PresentType,
        animation: Bool = false,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        presentationStyle: UIModalPresentationStyle = .fullScreen,
        isSetCurrent: Bool = false,
        completion: @escaping () -> Void = {}
    ) {
        guard !(currentVC == nil) else { return }
        var presentVC: UIViewController?
        switch presentType {
            case .viewController(let viewController):
                presentVC = viewController
            
            case .system(let system):
                systemPush(with: system)
        }
        guard let presentVC = presentVC else { return }
        currentVC?.present(
            with: presentVC,
            with: animation,
            with: transitionStyle,
            with: presentationStyle,
            completion: completion
        )
    }
    
    // MARK: - Логика возврата
    public func dismiss(animated: Bool, completion: @escaping (() -> Void) = {}) {
        self.currentVC?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Проверка
    private func isEqualTopVC(with presentVC: UIViewController) -> Bool {
        guard let topViewController = self.navigationViewController?.topViewController else { return false }
        let viewController  = String(describing: Mirror(reflecting: topViewController).subjectType)
        let presentVCString = String(describing: Mirror(reflecting: presentVC).subjectType)
        let isEqual         = viewController.contains(presentVCString)
        return isEqual
    }
    private func isEqualNextVC(with nextVC: UIViewController) -> Bool {
        guard let currentVC = self.currentVC else { return false }
        let currentController = String(describing: Mirror(reflecting: currentVC).subjectType)
        let nextController    = String(describing: Mirror(reflecting: nextVC).subjectType)
        let isEqual           = currentController.contains(nextController)
        return isEqual
    }
    
    // MARK: - Тип перехода
    public enum PresentType {
        case system(Systems)
        case viewController(UIViewController)
    }
    
    public func systemPush(with systems: Systems){
        switch systems {
            case .setting:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(
                        url,
                        options: [:],
                        completionHandler: nil
                    )
                }
        }
    }
    
    public enum Systems {
        case setting
    }
    
    public init() {}
}

