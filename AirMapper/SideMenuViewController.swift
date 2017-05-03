//
//  SideMenuViewController.swift
//  AirMapper
//
//  Created by Work on 4/30/17.
//  Copyright © 2017 Work. All rights reserved.
//

import Eureka

class SideMenuViewController: FormViewController, UINavigationControllerDelegate {
    
    var delegate: PrimaryViewControllerDelegate!
    var brushSize:CGFloat!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        form +++ Section("Background")
            <<< PushRow<String>(){
                $0.title = "Choose Image..."
                }.onCellSelection { row in
                    self.picker.allowsEditing = false
                    self.picker.sourceType = .photoLibrary
                    self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.present(self.picker, animated: true, completion: nil)
            }
            
            +++ Section("Toolbox")
            <<< SliderRow(){
                $0.title = "Brush Size"
                $0.value = Float(brushSize!)
                $0.minimumValue = 10
                $0.maximumValue = 100
                }.onChange { row in
                    self.delegate.updateBrush(brushSize: row.value!)
                }.cellSetup() { row in
            }
            <<< ButtonRow(){
                $0.title = "Clear All Fog"
                }.onCellSelection { row in
                    self.delegate.clearFog()
                }

    }
}

extension SideMenuViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate.setMapImage(with: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
