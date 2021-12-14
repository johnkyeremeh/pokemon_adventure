require_relative '../config/environment'
require_relative '../lib/pokemon'
require_relative '../lib/player'
require_relative '../lib/move'
require_relative '../lib/account_creation'

class Game

    attr_accessor :players, :player 

    @@game_saved = [] #keeps track of all players 
    @@input = nil 

    def initialize(player)
        @@game_saved << player
        @player = player #associate the game with instance of playe 
    end

    def self.all
        @@game_saved
    end

    def displaymenu
        puts "Welcome to the main menu. Please select what you would like to do?".colorize(:green)
        
        puts "1. Catch Pokemon".colorize(:blue)
        puts "2. My Pokemon".colorize(:blue)
        puts "3. My Bag".colorize(:blue)
        puts "4. My Money".colorize(:blue)
        puts "5. Shop".colorize(:blue)
        puts "6. Start Battle".colorize(:blue)
        puts "7. Exit".colorize(:blue)
        puts "8. Log Out".colorize(:blue)
        puts "9. Delete Account".colorize(:red)
     
    end

    #confirms input is valid
    def valid?
        @@input.between?(1,9)
    end

    #user chooses options in the game they want
    def choose_game
        self.displaymenu
        @@input = gets.chomp.to_i
        if !valid?
            self.choose_game
        elsif valid? && @@input == 1
            self.catch_pokemon
        elsif valid? && @@input == 2
            self.my_pokemon
        elsif valid? && @@input == 3
            self.my_bag
        elsif valid? && @@input == 4
            #4. My Money"
            self.my_money
        elsif valid? && @@input == 5
            self.shop
        elsif valid? && @@input == 6
            self.start_battle
        elsif valid? && @@input == 7
            self.exit?
        elsif valid? && @@input == 8 
            self.logout
        elsif valid?  && @@input == 9
           self.delete_account
        end
    end


    def create_the_world
        Pokemon.create_pokemon
        #do something for the loading it is long....
    end

   
    def catch_pokemon
    
        @@random_encounter = Pokemon.all.sample #choose a random element
        puts "You decide to walk into the wildlands where pokemon are....".colorize(:green)
        puts "A wild #{@@random_encounter.name } has APPEARED!!!".colorize(:green)
        action_input = encounter_action
        action_options(action_input)
    end
   
    def action_options(action_input)
        if action_input.between?(1,3) && action_input == 1
                self.throw_pokeball(@@random_encounter)
        elsif action_input.between?(1,3) && action_input  == 2
                self.use_pokedex(@@random_encounter)
        elsif action_input.between?(1,3) && action_input  == 3
            puts "Ran away from the encounter".colorize(:green)
            self.catch_pokemon
        else
            puts "You entered an incorrect input. The pokemon disappeared. Remember to reenter a correct input"
            self.catch_pokemon
        end
    end

    #displays a list of pokemon
    def my_pokemon
        self.player.pokemon_slots 
    end

    def throw_pokeball(random_encounter)
        if self.player.pokeballs > 0 
            puts "Throwing a pokeball".colorize(:purple)
            self.chance_to_catch_pokemon(random_encounter)
        else
            puts "not enough pokeballs".colorize(:green)
            puts "please go to the store".colorize(:green)
            self.choose_game
        end
    end

    def chance_to_catch_pokemon(random_encounter)
        if (rand(1..255)/255.0) > (random_encounter.capture_rate/255.0)   
            puts "you cought the pokemon".colorize(:green)
            self.player.add_pokemon(random_encounter)
            self.player.pokeballs -= 1
            puts "Please give your pokemon a nickname".colorize(:blue)
            nickname_input = gets.chomp 
            random_encounter.nick_name = nickname_input 
            random_encounter.level = rand(1..100)
            choose_game
        else
            puts "You could not capture the pokemon".colorize(:green)
            puts "Pokemon ran away"
            choose_game
        end
    end

    
    def encounter_action
            puts "What would you like to do?".colorize(:green)
            puts "1. Throw a pokeball".colorize(:blue)
            puts "2. Use your pokedex to get more information about this pokemon".colorize(:blue)
            puts "3. Runaway".colorize(:blue)
            action_input = gets.chomp.to_i
            action_input
    end

  

    
    

    def my_bag
        puts " "
        puts "You have #{self.player.pokeballs} pokeballs."
        puts " "  
        choose_game
    end

    ##account for nil class??

    def use_pokedex(pokemon)
        puts "You pull out your pokedex"
        puts ""
        puts "Type of pokemon: #{pokemon.name}".colorize(:green)
        puts "Level: unknown".colorize(:green)
        puts "Description: #{pokemon.description.split("\n").join(" ").split("\f").join(" ")}".colorize(:green)
        action_input = self.encounter_action
        self.action_options(action_input)
    end

    def my_money
        puts " "
        puts "You have ##{self.player.pokedollars} pokedollars"
        puts " "  
        choose_game
    end

    def exit?
      puts "thanks for playing the game"
      exit
    end

    def shop
        puts "We love to collect feedback on your interest"
        puts "Would a advanced be of interest to you?"
        choose_game
    end
    
    def start_battle
        puts "We love to collect feedback on your interest"
        puts "Would a pokemon game be of interest to you?"
        survey = gets.chomp 
        choose_game 
    end

    def delete_account 
        puts "ATTENTION. This will delete this playthrough are you sure you want to do this?"
    end 

    def logout
        puts "Thanks for PokemonWorld CLI".colorize(:green)
        puts "We hope to see you again".colorize(:green)
        puts "."
        puts ".."
        puts "..."
        puts "......................."
        ProjectPokemon::CLI.call 
    end

    def delete_account
        account = Accounts.all.reject {|object| object.game == self}
        ProjectPokemon::CLI.call 
    end 
end 



