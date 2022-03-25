//
//  SecondViewController.swift
//  GCD
//
//  Created by Нюргун on 25.03.2022.
//  Copyright © 2022 Нюргун. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        //Помещаем процесс загрузки в другой поток
        //Создаем очередь
        let queue = DispatchQueue.global(qos: .utility)
        //Добавляем процесс в очередь
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            //Возвращаем в главный поток
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
}

