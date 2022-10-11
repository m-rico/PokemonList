//
//  ViewController.swift
//  PokemonList
//
//  Created by user on 03/10/22.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        
    @IBOutlet weak var centerText: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pokeListTableView: UITableView!
    
//    var listPokeName = ["charizzard", "bullbasaur", "blastoise", "caterpie", "weedle"]
    var listPokemon = [PokemonListData]()
    var sendId = 0
    var sendPokename = ""
    var defaults = UserDefaults.standard
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.getListPokemon()
//        self.pokeListTableView.reloadData()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.getListPokemon()
        
//        PokeApi().getData() { pokemon in
//            print(pokemon)
//
////            self.apiPokeName = pokemon
//
//            for pokemon in pokemon {
//                print(pokemon.name)
//            }
//        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.backgroundView.backgroundColor = UIColor(hex: "#ffe700ff")
        let name = "Pokemon App"
        centerText.text = name
        
        self.pokeListTableView.delegate = self
        self.pokeListTableView.dataSource = self
        
        let nibName = UINib(nibName: "PokeListCell", bundle: nil)
        self.pokeListTableView.register(nibName, forCellReuseIdentifier: "pokeListCell")
        
        self.getListPokemon()
    }

    
    func getListPokemon() {
//        let urlListPokemon = Constants.urlBase
        let urlListPokemon = "https://pokeapi.co/api/v2/pokemon?limit=30"
        AF.request(urlListPokemon, method: .get, encoding: JSONEncoding.default).responseJSON { [self]response in
            switch response.result {
        case .success(let value):
                if let jsonResult = value as? NSDictionary {
                    if let tempResult = jsonResult.object(forKey:"results") as? NSArray {
                        for load in 0 ..< tempResult.count {
                            if let temp2 = tempResult[load] as? NSDictionary {
                                var url = ""
                                url = (temp2 as AnyObject).object(forKey:"url") as? String ?? ""
                                getDetailPokemon(url: url)
                            }
                        }
                        self.pokeListTableView.reloadData()
                    }
                }
        case .failure(let value) :
                print("gagal list \(value)")
        }
    }
    }
    
    func getDetailPokemon(url: String) {
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { [self]response in
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
                ld.img = frontImg
                if self.listPokemon.contains(where: {$0.name == name}) {
                    // nothing
                }else{
                    if name != ""{
                        self.listPokemon.append(ld)
                    }
                }
                self.pokeListTableView.reloadData()
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
        let pokename = self.listPokemon[indexPath.row].name ?? ""
        let image = self.listPokemon[indexPath.row].img ?? ""
        cell.commonInit(image, name: pokename)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendId = self.listPokemon[indexPath.row].id ?? 0
        self.sendPokename = self.listPokemon[indexPath.row].name ?? ""
        self.performSegue(withIdentifier: "goToDetailPokemon", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailPokemon" {
            let svc = segue.destination as! DetailPokemonVC
            svc.pokename = self.sendPokename
            svc.recId = self.sendId
        }
    }
    

}



