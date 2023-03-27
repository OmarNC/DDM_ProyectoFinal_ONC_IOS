//
//  LocalidadDetalleViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 20/03/23.
//



import UIKit

class LocalidadDetalleViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    @IBOutlet weak var buscarButton: UIButton!
    
    
    //Obtener el contexto para CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Objeto mostrado
    var localidad : Localidad? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if localidad != nil {
            updateView()
        }
        else { //Si es una nueva tarea, se coloca el cursor en el primer textfield
            nameTextField.becomeFirstResponder()
        }
        
        //Ocultar el teclado cuando se hace un tap fuera del campo de texto
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    
    }
    

    func updateView()
    {
        if localidad != nil{
            nameTextField.text = localidad?.name
            descriptionTextField.text = localidad?.descripcion
            stateTextField.text = localidad?.state
            countryTextField.text = localidad?.country
            latitudeTextField.text = "\(String(describing: localidad?.latitude))"
            longitudeTextField.text = "\(String(describing: localidad?.longitude))"
            
            
        }
    }
    
    func updateData()
    {
        if localidad == nil {
            localidad = Localidad(context: contexto)
        }
        localidad?.name = nameTextField.text ?? ""
        localidad?.descripcion  = descriptionTextField.text ?? ""
        localidad?.state = stateTextField.text ?? ""
        localidad?.country = countryTextField.text ?? ""
        localidad?.latitude = Double(latitudeTextField.text ?? "0.0") ?? 0.0
        localidad?.longitude = Double(longitudeTextField.text ?? "0.0") ?? 0.0
       
    }
    
    
    // MARK: - Navigation
    
    
    //Se agrega esta rutina para verificar si el viewController
    func isModal() -> Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        salir()
    }
    
    
    private func salir()
    {
        
        if self.isModal() {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destino = segue.destination as! TableViewController
        updateData()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var perform = false
        let camposNoEmpty = Helper.validateText(text: nameTextField.text!) &&
                            Helper.validateText(text: latitudeTextField.text!) &&
                            Helper.validateText(text: longitudeTextField.text!)
        let camposNumbers = Helper.validateTextNumeber(text: latitudeTextField.text!) &&
                            Helper.validateTextNumeber(text: longitudeTextField.text!)
        
        if camposNoEmpty == false {
            Helper.AlertMessageOk(title: NSLocalizedString("ALERT_TITLE_VACIO", comment: "ALERT_TITLE_VACIO"), message: NSLocalizedString("ALERT_MENSSAGE_VACIO", comment: "ALERT_MENSSAGE_VACIO"), viewController: self)
        }
        else if camposNumbers == false {
            Helper.AlertMessageOk(title: NSLocalizedString("ALERT_TITLE_NOT_NUMBER", comment: "ALERT_TITLE_NOT_NUMBER"), message: NSLocalizedString("ALERT_MENSSAGE_NOT_NUMBER", comment: "ALERT_MENSSAGE_NOT_NUMBER"), viewController: self)
        }
        else { perform = true }
            
        return perform
    }
    
    
    
    
    

}
