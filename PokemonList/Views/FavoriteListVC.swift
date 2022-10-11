//
//  FavoriteListVC.swift
//  PokemonList
//
//  Created by user on 05/10/22.
//

import UIKit
import Alamofire

class FavoriteListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pokemonTableView: UITableView!
    var defaults = UserDefaults.standard
    var myPokemons = [String:Int]()
    var listPokemon = [PokemonListData]()
    
    var sendId = 0
    var sendNamed = ""
    var sendIndex = 0
    var tbkIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        if let pokemon = defaults.dictionary(forKey: "PokemonsDictionary") as? [String:Int] {
            self.myPokemons = pokemon
        }
        self.getListPokemon()
        self.pokemonTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pokemonTableView.delegate = self
        self.pokemonTableView.dataSource = self
        
        let nibName = UINib(nibName: "PokeListCell", bundle: nil)
        self.pokemonTableView.register(nibName, forCellReuseIdentifier: "pokeListCell")
        if let pokemon = defaults.dictionary(forKey: "PokemonsDictionary") as? [String:Int] {
            self.myPokemons = pokemon
        }
        self.getListPokemon()
    }
    
    @IBAction func unwindToFav(_ sender: UIStoryboardSegue) {
        
        self.listPokemon.remove(at: self.tbkIndex)
        if let pokemon = defaults.dictionary(forKey: "PokemonsDictionary") as? [String:Int] {
            self.myPokemons = pokemon
        }
        print("zora")

        self.getListPokemon()
        self.pokemonTableView.reloadData()
    }
    
    
    func getListPokemon() {
        self.pokemonTableView.reloadData()
        for (key,value) in self.myPokemons {
        self.getDetailPokemon(id: value, named: key)
        }
        
    }
    
    func getDetailPokemon(id: Int, named: String) {
        let tempUrl = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        AF.request(tempUrl, method: .get, encoding: JSONEncoding.default).responseJSON { [self]response in
            switch response.result {
            case .success(let value):
                var id = 0
                var name = ""
                var frontImg = ""
                if let jsonResult = value as? NSDictionary {
                    name = (jsonResult as AnyObject).object(forKey:"name") as? String ?? ""
                    id = (jsonResult as AnyObject).object(forKey:"id") as? Int ?? 0
                    if let tempResult = jsonResult.object(forKey:"sprites") as? NSDictionary {
                        frontImg = (tempResult as AnyObject).object(forKey:"front_default") as? String ?? ""
                    }
                }
                
                let ld = PokemonListData()
                ld.id = id
                ld.name = name
                ld.named = named
                ld.img = frontImg
                if self.listPokemon.contains(where: {$0.named == named}) {
                    // nothing
                }else{
                    if named != ""{
                        self.listPokemon.append(ld)
                    }
                }
                self.pokemonTableView.reloadData()
            case .failure(let value):
                print("gagal list \(value)")
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeListCell", for: indexPath) as! PokeListCell
//        let id = self.listPokemon[indexPath.row].id ?? 0
        let namedPokemon = self.listPokemon[indexPath.row].named ?? ""
        let image = self.listPokemon[indexPath.row].img ?? ""
        cell.commonInit(image, name: namedPokemon)        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendId = self.listPokemon[indexPath.row].id ?? 0
        self.sendNamed = self.listPokemon[indexPath.row].named ?? ""
        self.sendIndex = indexPath.row
        self.performSegue(withIdentifier: "goToMyPokemonVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToMyPokemonVC" {
            let svc = segue.destination as! MyPokemonVC
            svc.takeId = self.sendId
            svc.takeNamed = self.sendNamed
            svc.takeIndex = self.sendIndex
        }
    }


}
