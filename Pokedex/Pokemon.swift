//
//  Pokemon.swift
//  Pokedex
//
//  Created by Marco Cotugno on 15/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _desc: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLVL: String!
    private var _pokemonUrl: String!
    
    
    var nextEvolutionLVL: String {
        
        if _nextEvolutionLVL == nil {
            _nextEvolutionLVL = ""
        }
        return _nextEvolutionLVL
    }
    
    var nextEvolutionID: String {
        
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var type: String {
        
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        
        if _attack == nil {
            
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        
        if _defense == nil {
            
            _defense = ""
        }
        return _defense
    }
    
    var weight: String {
        
        if _weight == nil {
            
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        
        if _height == nil {
            
            _height = ""
        }
        return _height
    }
    
    var desc: String {
        if _desc == nil {
            _desc = ""
        }
        return _desc
    }
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonUrl).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalized
                    }
                    // if there is more than just one type
                    if types.count > 1 {
                        for x in 1..<types.count{
                            if let name = types[x]["name"] {
                                
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                //getting the description
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>] , descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let descURL = "\(BASE_URL)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._desc = newDescription
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._desc = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID = nextEvoID
                                
                                if let levelExist = evolutions[0]["level"] {
                                    if let lvl = levelExist as? Int {
                                        self._nextEvolutionLVL = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolutionLVL = ""
                                }
                            }
                        }
                    }
                }
                completed()
            }
        }
    }
}
