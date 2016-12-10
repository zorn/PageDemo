import UIKit

protocol ImageDetailViewControllerDelegate: class {
    func imageDetailViewControllerDidFinish(sender: ImageDetailViewController)
    func imageDetailViewController(_ sender: ImageDetailViewController, didUpdateCurrentNameIndex imageNameIndex: Int)
}

class ImageDetailViewController: UIViewController {

    weak var delegate: ImageDetailViewControllerDelegate?
    var imageNames = [String]()
    var currentImageNameIndex: Int = 0

    @IBAction func close(_ sender: UIButton) {
        delegate?.imageDetailViewControllerDidFinish(sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPageVC" {
            if let pageVC = segue.destination as? UIPageViewController {
                pageVC.delegate = self
                pageVC.dataSource = self
                let firstImageName = imageNames[currentImageNameIndex]
                let vc = generateImageDisplayViewController(forImageName: firstImageName, atIndex: currentImageNameIndex)
                pageVC.setViewControllers([vc], direction:.forward, animated: true, completion: nil)
            }
        }
    }

}

extension ImageDetailViewController: UIPageViewControllerDataSource {
    
    fileprivate func generateImageDisplayViewController(forImageName imageName: String, atIndex index: Int) -> ImageDisplayViewController {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDisplayViewController") as! ImageDisplayViewController
        vc.imageName = imageName
        vc.index = index
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let displayVC = viewController as? ImageDisplayViewController,
              let index = displayVC.index
            else {
            return nil
        }
        
        let beforeIndex = index - 1
        if beforeIndex < 0 {
            return nil
        }
        return generateImageDisplayViewController(forImageName: imageNames[beforeIndex], atIndex: beforeIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let displayVC = viewController as? ImageDisplayViewController,
            let index = displayVC.index
            else {
                return nil
        }
        
        let afterIndex = index + 1
        if afterIndex >= imageNames.count {
            return nil
        }
        return generateImageDisplayViewController(forImageName: imageNames[afterIndex], atIndex: afterIndex)
        
    }
    
    // A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
    // Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
    
    // The number of items reflected in the page indicator.
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imageNames.count
    }
    
    // The selected item reflected in the page indicator.
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentImageNameIndex;
    }
    
}

extension ImageDetailViewController: UIPageViewControllerDelegate {

    // Sent when a gesture-initiated transition begins.
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // no op
    }
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let displayVC = pageViewController.viewControllers?.first as? ImageDisplayViewController,
            let index = displayVC.index
            else {
                return
        }
        
        delegate?.imageDetailViewController(self, didUpdateCurrentNameIndex: index)
    }
    
}
