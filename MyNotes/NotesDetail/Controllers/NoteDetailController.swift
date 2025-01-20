//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Дмитрий Исаев on 17.08.2024.
//

import UIKit
import Photos

protocol NoteDetailControllerProtocol: AnyObject {
    
    func didChange(text: String)
    func didBeginEditing()
    func didTapAddFileMenuButton(hidden: Bool) //название?
    func didTapAddPhotoOrVideoButton()
    
}

protocol NoteDetailControllerDelegate: AnyObject {
    
    func didEditTextNote(with id: String, newText: String)
    
}

final class NoteDetailController: UIViewController {
    
    private lazy var contentView: NoteDetailViewProtocol = makeContentView()
    
    weak var delegate: NoteDetailControllerDelegate?
    
    private var model: NoteDetailModelProtocol // private?
    
    init(model: NoteDetailModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        setupView()
        
        contentView.setText(text: model.note.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.startTextViewListening()
        
        if model.note.text.isEmpty {
            contentView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.stopTextViewListening()
    }
    
}

// MARK: - Протокол контроллера

extension NoteDetailController: NoteDetailControllerProtocol {
    
    func didChange(text: String) {
        let id = model.note.id
        delegate?.didEditTextNote(with: id, newText: text)
    }
    
    func didBeginEditing() {
        setupNavigationBarItem()
    }
    
    func didTapAddFileMenuButton(hidden: Bool) {//название?. и аргумент hidden?
        if hidden {
            contentView.hideAddFileMenu(value: false)
        } else {
            contentView.hideAddFileMenu(value: true)
        }
    }
    
    func didTapAddPhotoOrVideoButton() { //посмотреть порядок кода и в целом глянуть
        contentView.hideAddFileMenu(value: true)
        showImagePickerController()
        requestPhotoLibraryAccess()
    }
    
}

//MARK: - UIImagePickerController methods

extension NoteDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

// MARK: - UI Elements

private extension NoteDetailController {
    
    func setupView() {
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func makeContentView() -> NoteDetailViewProtocol {
        let view = NoteDetailView(controller: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        navigationItem.titleView?.tintColor = .systemOrange
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

//MARK: - Private methods

private extension NoteDetailController {
    
    func showImagePickerController() { // 1)можно не вызывать отдельной функцией. 2) Как вариант убрать в extention UI Elements
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
    }
    
    func requestPhotoLibraryAccess() { //возможно просто оставить пустые {} requestAuthorization если не надо обрабатывать или break
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { newStatus in
                if newStatus == .authorized {// можно вообще убрать
                    print("Доступ предоставлен.")
                } else {
                    print("Доступ запрещен.")
                }
            }
        case .restricted:
            print("Доступ ограничен.")
        case .denied:
            print("Досуп запрещен.")
        case .authorized:
            print("Доступ уже предоставлен.")//тут можно везде break поставить
        case .limited:
            print("Доступ ограничен.")
        default:
            print("Неизвестный статус авторизации.")
        }
    }
    
}
