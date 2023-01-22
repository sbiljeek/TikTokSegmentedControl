//
//  ViewController.swift
//  TikTokSegmentedControl
//
//  Created by Salman Biljeek on 1/15/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.setupCollectionView()
        self.setupNavItems()
        self.setupSegmentedControl()
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupNavItems() {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let tvImage = UIImage(systemName: "play.tv")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: tvImage, style: .plain, target: self, action: nil)
    }
    
    var segmentedControlView = UIView()
    lazy var segmentButtons: [UIButton] = [self.followingButton, self.forYouButton]
    var segmentBar = UIView()
    let segmentBarWidth: CGFloat = 28
    var segmentBarLeadingConstraint: NSLayoutConstraint?
    var currentPage: Int = 0
    
    let selectedButtonColor: UIColor = .white
    let unselectedButtonColor: UIColor = .white.withAlphaComponent(0.6)
    
    lazy var followingButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 16, weight: .heavy)
        container.foregroundColor = self.selectedButtonColor
        configuration.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        configuration.attributedTitle = AttributedString("Following", attributes: container)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(self.segmentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var forYouButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 16, weight: .heavy)
        container.foregroundColor = self.unselectedButtonColor
        configuration.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        configuration.attributedTitle = AttributedString("For You", attributes: container)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(self.segmentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let followingViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
        let image = UIImage(named: "TikTok-icon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        viewController.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 125).isActive = true
        return viewController
    }()
    let forYouViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        let image = UIImage(named: "dog-10")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: -180).isActive = true
        imageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        return viewController
    }()
    
    lazy var pageItems: [UIViewController] = [self.followingViewController, self.forYouViewController]
    
    fileprivate func setupSegmentedControl() {
        // 1) Add the buttons in a horizontal stack view with equal width
        let buttonstack = UIStackView(arrangedSubviews: segmentButtons)
        buttonstack.axis = .horizontal
        buttonstack.alignment = .fill
        buttonstack.distribution = .fillEqually
        
        // 2) Add the buttons stack view to the segments control view and pin edges to superview
        segmentedControlView.addSubview(buttonstack)
        buttonstack.translatesAutoresizingMaskIntoConstraints = false
        buttonstack.topAnchor.constraint(equalTo: segmentedControlView.topAnchor).isActive = true
        buttonstack.bottomAnchor.constraint(equalTo: segmentedControlView.bottomAnchor).isActive = true
        buttonstack.leftAnchor.constraint(equalTo: segmentedControlView.leftAnchor).isActive = true
        buttonstack.rightAnchor.constraint(equalTo: segmentedControlView.rightAnchor).isActive = true
        
        // 3) Set the segment bar background color to white and add it to segmented control. Setup it's width and height. Anchor it to the bottom of segmented control and setup it's leading constraint
        segmentBar.backgroundColor = .white
        
        segmentedControlView.addSubview(segmentBar)
        segmentBar.translatesAutoresizingMaskIntoConstraints = false
        segmentBar.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        segmentBar.widthAnchor.constraint(equalToConstant: segmentBarWidth).isActive = true
        segmentBar.bottomAnchor.constraint(equalTo: segmentedControlView.bottomAnchor).isActive = true
        segmentBarLeadingConstraint = segmentBar.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor, constant: 0)
        segmentBarLeadingConstraint?.isActive = true
        
        // 4) Add segmented control to nav bar, set its height constraint and position it in the center
        if let navBar = self.navigationController?.navigationBar {
            navBar.addSubview(segmentedControlView)
            segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
            segmentedControlView.heightAnchor.constraint(equalToConstant: 38).isActive = true
            segmentedControlView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor, constant: 4).isActive = true
            segmentedControlView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 0).isActive = true
        }
        
        // 5) Adjust segment bar inset on page load
        self.collectionView.performBatchUpdates {
            //...
        } completion: { _ in
            self.scrollViewDidScroll(self.collectionView)
        }
    }
    
    @objc fileprivate func segmentButtonTapped(button: UIButton) {
        if let page = segmentButtons.firstIndex(of: button) {
            if currentPage == page {
                // Selected page unchanged, reset selected appearance
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateSelectedSegmentButton(page: page)
                }
            } else {
                // Selected page changed, scroll to new page
                let indexPath = IndexPath(item: page, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    fileprivate func updateSelectedSegmentButton(page: Int) {
        currentPage = page
        // Update the segment buttons appearance with animation
        for (index, _) in self.segmentButtons.enumerated() {
            UIView.transition(with: self.segmentButtons[index], duration: 0.2, options: .transitionCrossDissolve, animations: {
                if index == page {
                    // Highlight selected page button
                    self.segmentButtons[index].titleLabel?.textColor = self.selectedButtonColor
                } else {
                    // Unhighlight all other page buttons
                    self.segmentButtons[index].titleLabel?.textColor = self.unselectedButtonColor
                }
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Get the scrollView content offset x, the segmented control width and segment item width
        let scrollViewContentOffsetX = scrollView.contentOffset.x
        let segmentedControlViewWidth = self.segmentedControlView.frame.width
        let segmentItemWidth = (segmentedControlViewWidth / CGFloat(segmentButtons.count))
        // Calculate the segment item padding, point and the new X inset
        let padding = (segmentItemWidth - segmentBarWidth) / 2
        let point = scrollViewContentOffsetX / (view.frame.width * CGFloat(self.pageItems.count))
        let newX = (segmentedControlViewWidth * point) + padding
        // If new X value is valid, set it to the segment bar leading anchor constant
        if segmentBarLeadingConstraint != nil && !newX.isNaN && newX.isFinite {
            segmentBarLeadingConstraint?.constant = newX
        }
        // Get the current page and update the selected segment button appearance
        var currentPage = Int((scrollViewContentOffsetX + (view.frame.width / 2)) / view.frame.width)
        currentPage = currentPage > (self.pageItems.count - 1) ? self.currentPage : currentPage
        let pageChanged = currentPage != self.currentPage
        if pageChanged {
            updateSelectedSegmentButton(page: currentPage)
        }
        self.currentPage = currentPage
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let menuItemsCount = self.pageItems.count
        return menuItemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Add view controllers to cells
        guard self.pageItems.indices.contains(indexPath.item) else {
            return UICollectionViewCell()
        }
        let pageItem = self.pageItems[indexPath.item]
        switch pageItem {
        case self.followingViewController:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
            if cell.stackView.arrangedSubviews.count < 1 {
                cell.stackView.addArrangedSubview(self.followingViewController.view)
                self.addChild(self.followingViewController)
                self.followingViewController.didMove(toParent: self)
            }
            return cell
        case self.forYouViewController:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
            if cell.stackView.arrangedSubviews.count < 1 {
                cell.stackView.addArrangedSubview(self.forYouViewController.view)
                self.addChild(self.forYouViewController)
                self.forYouViewController.didMove(toParent: self)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Make cells fullscreen
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
