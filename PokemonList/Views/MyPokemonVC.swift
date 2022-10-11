//
//  MyPokemonVC.swift
//  PokemonList
//
//  Created by user on 07/10/22.
//

import UIKit
import Alamofire

class MyPokemonVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var namedPokemonLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var imgPokemonImageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var renameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    var takeId = 0
    var takeNamed = ""
    var takeIndex = 0
    var isDelete = false
    var isRename = false
    var defaults = UserDefaults.standard
    var myPokemons = [String:Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getDetailPokemon(id: takeId)
        self.renameView.isHidden = true
        self.nameTextField.delegate = self
        self.nameTextField.setLeftPaddingPoints(16)
        self.hideKeyboardWhenTappedAround()
        self.saveButton.isEnabled = false
        self.alertLabel.isHidden = true
        self.checkButton()
        
        if let pokemon = defaults.dictionary(forKey: "PokemonsDictionary") as? [String:Int] {
            self.myPokemons = pokemon
        }
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        print("zphry4")
////        if isRename {
////            print("zphry1")
//
//            self.performSegue(withIdentifier: "backToFavFromMy", sender: self)
////        }
//
//
//    }
    
    @IBAction func renameButtonClicked(_ sender: Any) {
        self.renameView.isHidden = false
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure to delete ?", message: "", preferredStyle: .alert)
        
        let actionNo = UIAlertAction(title: "Cancel", style: .default) { (actionNo) in
            // what will hapen when user klik yes
            
        }
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (actionYes) in
            // what will hapen when user klik yes
            self.isDelete = true
            self.myPokemons.removeValue(forKey: self.takeNamed)
            
            self.defaults.set(self.myPokemons, forKey: "PokemonsDictionary")
            UserDefaults.standard.synchronize()
//            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "backToFavFromMy", sender: self)
        }
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.checkButton()
        self.renameView.isHidden = true
        self.isRename = true
//        self.myPokemons.changeKey(from: self.takeNamed, to: self.nameTextField.text!)
        self.myPokemons.removeValue(forKey: self.takeNamed)
        self.myPokemons[self.nameTextField.text ?? ""] = takeId
        self.defaults.set(self.myPokemons, forKey: "PokemonsDictionary")
        self.namedPokemonLabel.text = self.nameTextField.text!
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "backToFavFromMy", sender: self)
    }
    
    func checkButton() {
        if (self.nameTextField.text == "") {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    }
    //TextField
    private func configureTextField() {
        self.nameTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkButton()
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkButton()
    }
    
    
    
    
    func getDetailPokemon(id: Int) {
        let tempUrl = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        AF.request(tempUrl, method: .get, encoding: JSONEncoding.default).responseJSON { [self]response in
            switch response.result {
            case .success(let value):
                var id = 0
                var name = ""
                var frontImg = ""
                var artwork = ""
                var height = 0
                var weight = 0
                var abilites = [String]()
                if let jsonResult = value as? NSDictionary {
                    name = (jsonResult as AnyObject).object(forKey:"name") as? String ?? ""
                    id = (jsonResult as AnyObject).object(forKey:"id") as? Int ?? 0
                    height = (jsonResult as AnyObject).object(forKey:"height") as? Int ?? 0
                    weight = (jsonResult as AnyObject).object(forKey:"weight") as? Int ?? 0
                    
                    if let tempAbilites = jsonResult.object(forKey:"abilities") as? NSArray {
                        for load in 0 ..< tempAbilites.count {
                            if let temp2 = tempAbilites[load] as? NSDictionary {
                                
                                if let tempab = temp2.object(forKey:"ability") as? NSDictionary {
                                    let tempName = (tempab as AnyObject).object(forKey:"name") as? String ?? ""
                                    abilites.append(tempName)
                                }
                            }
                        }
                    }
                    
                    if let tempResult = jsonResult.object(forKey:"sprites") as? NSDictionary {
                        frontImg = (tempResult as AnyObject).object(forKey:"front_default") as? String ?? ""
                        if let tempThird = tempResult.object(forKey:"other") as? NSDictionary {
                            
                            if let tempFour = tempThird.object(forKey:"official-artwork") as? NSDictionary {
                                artwork = (tempFour as AnyObject).object(forKey:"front_default") as? String ?? ""
                            }
                        }
                    }
                }
                self.namedPokemonLabel.text = self.takeNamed.uppercased()
                self.pokemonNameLabel.text = name
                self.imgPokemonImageView.load(urlString: artwork)
                self.heightLabel.text = String(height)
                self.weightLabel.text = String(weight)
                let temparray = abilites.map{String($0)}.joined(separator: ", ")
                self.abilitiesLabel.text = temparray
                
            case .failure(let value):
                print("gagal list \(value)")
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
            let favDestVC = segue.destination as! FavoriteListVC
            favDestVC.tbkIndex = self.takeIndex
        
    }
    

}
