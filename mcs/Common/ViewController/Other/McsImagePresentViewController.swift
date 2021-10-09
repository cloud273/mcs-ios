/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class McsImagePresentViewController: McsViewController {

    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    
    private var image: UIImage?
    private var url: String?
    
    private init(_ image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    private init(_ url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeGesture.direction = .down
        
        scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = image {
            imageView.image = image
        } else {
            imageView.setImageUrl(url, placeholder: nil)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(swipeGesture)
        scrollView.addFixView(imageView)
        view.addFixView(scrollView)
        _ = imageView.addHeightConstraint(view)
        _ = imageView.addWidthConstraint(view)
        
        let closeButton = UIButton.init(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close".localized, for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        view.addSubview(closeButton)
        _ = closeButton.addInnerEdgeConstraint(types: [.leading, .top], offset: 20)
    }
    
    @objc private func didDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    @objc private func didSwipeDown() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public static func show(_ controller: UIViewController?, image: UIImage) {
        let result = McsImagePresentViewController.init(image)
        let vc = controller ?? self.presentedViewController()!
        vc.present(result, animated: true, completion: nil)
    }
    
    public static func show(_ controller: UIViewController?, url: String) {
        let result = McsImagePresentViewController.init(url)
        let vc = controller ?? self.presentedViewController()!
        vc.present(result, animated: true, completion: nil)
    }

}

extension McsImagePresentViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
