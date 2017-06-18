//
//  PokemonDetailsVC.swift
//  Pokedex
//
//  Created by Marco Cotugno on 15/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit

class PokemonDetailsVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexIDLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            
            //Whatever we write here will only be called after the network call is complete!!
            self.updateUI()
        }
        
    }
    
    func updateUI(){
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descLbl.text = pokemon.desc
        
        if pokemon.nextEvolutionID == "" {
            evoLbl.text = "No Evolution"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionID)")
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLVL)"
            evoLbl.text = str
        }
    }// end viewDidLoad
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}// end PokemonDetailsVC
