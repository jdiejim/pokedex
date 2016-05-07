//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Juan Diego Jimenez on 5/2/16.
//  Copyright © 2016 JDJ. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var pokemonNameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvo: UIImageView!
    @IBOutlet weak var nextEvo: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentEvoPokeImg = UIImage(named: "\(pokemon.pokedexId)")
        pokemonNameLbl.text = pokemon.name.capitalizedString
        mainImg.image = currentEvoPokeImg
        currentEvo.image = currentEvoPokeImg
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        pokedexIDLbl.text = "\(pokemon.pokedexId)"
        baseAttackLbl.text = pokemon.baseAttack
        if pokemon.evoText != "" {
            evoLbl.text = "Next Evolution: \(pokemon.evoText) in Level \(pokemon.nextEvoLevel)"
            nextEvo.image = UIImage(named: "\(pokemon.nextEvoId)")
            
        } else {
            evoLbl.text = ""
            nextEvo.hidden = true
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
