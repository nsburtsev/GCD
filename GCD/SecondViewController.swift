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
        delay(3) {
            self.loginAlert()
        }
    }
    
    //Функция отсроченного выполнения кода
    fileprivate func delay(_ delay: Int, clousure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            clousure()
        }
    }
    
    //Всплывающее окно
    fileprivate func loginAlert() {
        let ac = UIAlertController(title: "Зарегистрированы?", message: "Введите ваш логин и пароль", preferredStyle: .alert)
        //Добавляем кнопки
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        //Добавляем действия в алерт контроллер
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        //Добавляем текстовые поля в алерт контроллер
        ac.addTextField { (usernameTF) in
            usernameTF.placeholder = "Введите логин"
        }
        ac.addTextField { (userPasswordTF) in
            userPasswordTF.placeholder = "Введите пароль"
            userPasswordTF.isSecureTextEntry = true
        }
        //Отображаем алерт контроллер
        self.present(ac, animated: true, completion: nil)
    }
    
    //Загрузка изображения
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

