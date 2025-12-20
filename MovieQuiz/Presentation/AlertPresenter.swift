//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 15.12.2025.
//

import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title, // заголовок всплывающего окна
                                      message: model.message, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
