//
//  Onboarding1.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/5/13.
//

import UIKit

class Onboarding1: UIViewController {
    
    var nextButton = GeneralButton(buttonTitle: "Next", backgroundColor: "F2771F")
    var startButton = GeneralButton(buttonTitle: "Start!", backgroundColor: "F2771F")
    var skipButton = UIButton(type: .system)
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var imageArray = ["onboarding1", "onboarding2", "onboarding3"]
    var titleArray = [onboardingTitle.oneTitle, onboardingTitle.twoTitle, onboardingTitle.threeTitle]
    var descriptionArray = [onboardingDescription.oneDescription, onboardingDescription.twoDescription, onboardingDescription.threeDescription]
    var arrayIndex = 0
    
    let blurOne = UIImageView()
    let blurTwo = UIImageView()
    let blurThree = UIImageView()
    
    var stackView = UIStackView()
    var wordStackView = UIStackView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setUpStackView()
        setUpStack()
        setUpImageView(image: "onboarding1")
        setUpWordStackView(title: onboardingTitle.oneTitle.rawValue, description: onboardingDescription.oneDescription.rawValue)
        setUpSkipButton()
        setUpBlur()
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)


    }
    
    
    func setUpBlur() {
        view.addSubview(blurOne)
        view.addSubview(blurTwo)
        view.addSubview(blurThree)
        
        blurOne.image = UIImage(named: "blurOne")
        blurTwo.image = UIImage(named: "blurTwo")
        blurThree.image = UIImage(named: "blurThree")

        blurOne.translatesAutoresizingMaskIntoConstraints = false
        blurTwo.translatesAutoresizingMaskIntoConstraints = false
        blurThree.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurOne.topAnchor.constraint(equalTo: view.topAnchor),
            blurOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurOne.widthAnchor.constraint(equalToConstant: 402),
            blurOne.heightAnchor.constraint(equalToConstant: 874),
            
            blurTwo.topAnchor.constraint(equalTo: view.topAnchor),
            blurTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurTwo.widthAnchor.constraint(equalToConstant: 402),
            blurTwo.heightAnchor.constraint(equalToConstant: 874),
            
            blurThree.topAnchor.constraint(equalTo: view.topAnchor),
            blurThree.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurThree.widthAnchor.constraint(equalToConstant: 402),
            blurThree.heightAnchor.constraint(equalToConstant: 874),
        ])
        
        addFloatAnimationy(to: blurOne, range: 10, duration: 1.0)
//        addFloatAnimationx(to: blurOne, range: 8, duration: 1.4)
//        addFloatAnimationy(to: blurTwo, range: 6, duration: 1.1)
        addFloatAnimationx(to: blurTwo, range: 12, duration: 1.5)
        addFloatAnimationy(to: blurThree, range: 8, duration: 1.2)

    }
    
    
    // 加入上下飄動動畫
    func addFloatAnimationy(to view: UIView, range: CGFloat, duration: CFTimeInterval) {
        let animationy = CABasicAnimation(keyPath: "transform.translation.y")
        animationy.fromValue = -range
        animationy.toValue = range
        animationy.duration = duration
        animationy.autoreverses = true
        animationy.repeatCount = .infinity
        view.layer.add(animationy, forKey: "float")
    }
    
    func addFloatAnimationx(to view: UIView, range: CGFloat, duration: CFTimeInterval) {
        let animationx = CABasicAnimation(keyPath: "transform.translation.x")
        animationx.fromValue = -range
        animationx.toValue = range
        animationx.duration = duration
        animationx.autoreverses = true
        animationx.repeatCount = .infinity
        view.layer.add(animationx, forKey: "float")
    }
    
    
    // MARK: - Skip button
    @objc func skipButtonTapped() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        let mainVC = UINavigationController(rootViewController: MainVCNew())
        sceneDelegate.window?.rootViewController = mainVC
    }
    
    
    func setUpSkipButton() {
        view.addSubview(skipButton)
        skipButton.setTitle("Skip", for: .normal)
        
        skipButton.setTitleColor(UIColor(hex: "F2771F"), for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        skipButton.backgroundColor = .clear
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            skipButton.widthAnchor.constraint(equalToConstant: 60),
            skipButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    // MARK: - Next button
    @objc func nextButtonTapped() {
        
        if arrayIndex < imageArray.count - 1 {
            arrayIndex += 1
        } else {
//            arrayIndex = 0
            skipButtonTapped()
        }

        UIView.transition(with: imageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.setUpImageView(image: self.imageArray[self.arrayIndex])
        }, completion: nil)
        
        UIView.transition(with: wordStackView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.setUpWordStackView(title: self.titleArray[self.arrayIndex].rawValue,
                                    description: self.descriptionArray[self.arrayIndex].rawValue)
        }, completion: nil)
        
        // 移除原本的按鈕
        self.stackView.removeArrangedSubview(self.nextButton)
        self.nextButton.removeFromSuperview()

        // 判斷加哪一個按鈕
        if arrayIndex == imageArray.count - 1 {
            self.stackView.addArrangedSubview(self.startButton)
        } else {
            self.stackView.addArrangedSubview(self.nextButton)
        }
    }
    
    
    // MARK: - Set up image
    func setUpImageView(image: String) {
        imageView.image = UIImage(named: image)
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 380),
            imageView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    
    // MARK: - Set up word stack
    func setUpWordStackView(title: String, description: String) {
        wordStackView.addArrangedSubview(titleLabel)
        wordStackView.addArrangedSubview(descriptionLabel)
        
        wordStackView.axis = .vertical
        wordStackView.spacing = 2
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            descriptionLabel.widthAnchor.constraint(equalToConstant: 250),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
        
    
    // MARK: - Set up stack
    func setUpStack() {
        view.addSubview(stackView)

        stackView.axis = .vertical
//        stackView.spacing = 80
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            stackView.widthAnchor.constraint(equalToConstant: 600),
            stackView.heightAnchor.constraint(equalToConstant: 600),
        ])
    }
    
    
    func setUpStackView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(wordStackView)
        stackView.addArrangedSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    // MARK: - Set up background
    func setupBackground() {
        // Set background image from Assets
        let backgroundImage = UIImage(named: "onboardingBackground")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        // Pin image view to edges
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
}
