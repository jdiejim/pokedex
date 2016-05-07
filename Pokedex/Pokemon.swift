//
//  Pokemon.swift
//  Pokedex
//
//  Created by Juan Diego Jimenez on 4/29/16.
//  Copyright © 2016 JDJ. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _evoText: String!
    private var _pokemonUrl: String!
    private var _nextEvoLevel: String!
    private var _nextEvoId: Int!
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var evoText: String {
        if _evoText == nil {
            _evoText = ""
        }
        return _evoText
    }
    
    var pokemonUrl: String {
        return _pokemonUrl
    }
    
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var nextEvoId: Int {
        if _nextEvoId == nil {
            _nextEvoId = 0
        }
        return _nextEvoId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
              
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                        
                        if types.count > 1 {
                            for i in 1..<types.count {
                                if let name = types[i]["name"] {
                                    self._type = self._type + "/\(name.capitalizedString)"
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    print(self._type)
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            self._evoText = to
                            if let nextEvoLevel = evolutions[0]["level"] as? Int {
                                self._nextEvoLevel = "\(nextEvoLevel)"
                              
                            }
                            if let nextEvoId = evolutions[0]["resource_uri"] as? String {
                                let delimiter = "/"
                                let token = nextEvoId.componentsSeparatedByString(delimiter)
                                self._nextEvoId = Int(token[4])
                            }
                            
                        }
                    }
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] where descriptions.count > 0 {
                    if let resource_uri = descriptions[0]["resource_uri"] {
                        let url = NSURL(string: "\(URL_BASE)\(resource_uri)")!
                        Alamofire.request(.GET, url).responseJSON { response in
                            let desResult = response.result
                            if let desDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = desDict["description"] as? String {
                                    self._description = description
                                    
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
            }
        }
    }
}