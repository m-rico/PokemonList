//
//  DetailPokemonVC.swift
//  PokemonList
//
//  Created by user on 05/10/22.
//

import UIKit
import Alamofire

class DetailPokemonVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var catchButton: UIButton!
    @IBOutlet weak var tryCountLabel: UILabel!
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var loseView: UIView!
    @IBOutlet weak var alertNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var pokename = ""
    var urlImage = ""
    var recId = 0
    var timesTry = 0
    var defaults = UserDefaults.standard
    var myPokemons = [String:Int]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        //nothing
        self.getDetailPokemon(id: recId)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titleLabel.text = pokename.uppercased()
//        self.winView.backgroundColor = UIColor(hex: "#E9F8DB")
//        self.loseView.backgroundColor = UIColor(hex: "ffe700ff")
//        self.backgroundView.backgroundColor = UIColor(hex: "#ffe700ff")
        self.winView.isHidden = true
        self.loseView.isHidden = true
        self.alertNameLabel.isHidden = true
        self.saveButton.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        self.nameTextField.delegate = self
        self.nameTextField.setLeftPaddingPoints(16)
        self.nameTextField.layer.borderColor = UIColor(hexString: "#8EC63F").cgColor
        
        self.checkButton()
        
        if let pokemon = defaults.dictionary(forKey: "PokemonsDictionary") as? [String:Int] {
            self.myPokemons = pokemon
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
    
    func checkButton() {
        if (self.nameTextField.text == "") {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    }
    
    
    @IBAction func catchButtonClicked(_ sender: Any) {
        let randomBool = Bool.random()
        
        
        if randomBool {
            self.loseView.isHidden = true
            self.winView.isHidden = false
            self.catchButton.isEnabled = false
            
        } else {
            self.loseView.isHidden = false
            self.timesTry += 1
            self.tryCountLabel.text = "\(self.timesTry) / 3"
            if self.timesTry >= 3 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.checkButton()
//        self.myPokemons.updateValue(self.recId, forKey: String(self.nameTextField.text) ?? "")
        self.myPokemons[self.nameTextField.text ?? ""] = recId
        self.defaults.set(self.myPokemons, forKey: "PokemonsDictionary")
        self.dismiss(animated: true, completion: nil)
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
//                print("yami \(name)")
                self.pokemonImageView.load(urlString: artwork)
                self.heightLabel.text = String(height)
                self.weightLabel.text = String(weight)
                let temparray = abilites.map{String($0)}.joined(separator: ", ")
                self.abilitiesLabel.text = temparray
                
//                let ld = PokemonListData()
//                ld.id = id
//                ld.name = name
//                ld.img = frontImg
//                if self.listPokemon.contains(where: {$0.name == name}) {
//                    // nothing
//                }else{
//                    if name != ""{
//                        self.listPokemon.append(ld)
//                    }
//                }
//                self.pokeListTableView.reloadData()
            case .failure(let value):
                print("gagal list \(value)")
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
