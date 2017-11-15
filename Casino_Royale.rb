###########Begin Wallet Class
class Wallet
  @@default_wallet = 100

  def add amount
   @@default_wallet += amount
  end

  def sub amount
    @@default_wallet -= amount
  end

  def funds
    @@default_wallet
  end
end
##########End Wallet Class

##########Begin Black Jack Class
class BlackJack
  def deal
    card_delt = rand(1..13)
    if (card_delt > 10) || (card_delt == 1)
      card_delt = card card_delt
    end
    card_delt
  end

  def dealer_results
    rand(17..24)
  end

  def card face
    royals = { 11 => "Jack", 12 => "Queen", 13 => "King", 1 => "Ace" }
    royals[face]
  end

  def card_value face
    cards = { "Jack" => 10, "Queen" => 10, "King" => 10, "Ace" => 11 }
    cards[face]
  end

  def match (var1, var2)
    if var1.is_a?(String)
    var1 = card_value var1
    end
    if var2.is_a?(String)
      var2 = card_value var2
    end
    var1 + var2
  end

  def compare player_score, dealer_score
    if ((dealer_score < player_score) && (player_score < 22)) || ((player_score < 22) && (dealer_score > 21))
      puts "You win $40!"
      40
    elsif (player_score > 22) || ((player_score < dealer_score) && (dealer_score < 22))
      puts "Dealer Wins."
      0
    elsif (player_score < 22) && (dealer_score < 22) && (player_score == dealer_score)
      puts "It's a Draw, you get your money back."
      20
    else
      puts "Dealer Wins."
      0
    end
  end
end
############End Black Jack Class

############Begin Slots Class
class Slots

  def pull
    slot_items = ["bar", "cherry", "sevens", "grapes", "bananas", "diamonds"]
    slot_items.sample
  end



  def slot
    slot1 = pull
    slot2 = pull
    slot3 = pull
    puts slot1 + " - " + slot2 + " - " + slot3
    
    fruit = { "bar" => 11, "diamonds" => 11, "cherry" => 8, "sevens" => 10, "grapes" => 6, "bananas" => 6 }
    if (slot1 == slot2) && (slot1 == slot3)
      p "Jackpot of $" + (fruit[slot1] * 6).to_s + "."
      (fruit[slot1] * 6)
    elsif slot1 == "bar" || slot2 == "bar" || slot3 == "bar"
      puts "You got a bar, you lose!"
      0
    elsif slot1 == slot2 || slot2 == slot3 || slot1 == slot3
      if slot1 == slot2 || slot1 == slot3
        p "You won $" + (fruit[slot1] * 2).to_s + "."
        (fruit[slot1] * 2)
       else
        p "You won $" + (fruit[slot2] * 2).to_s + "."
        (fruit[slot2] * 2)
      end
    else
      puts "YOU LOSE!!"
      0
    end
  end
end
############End Slots Class

############Start main loop
loop do
  wallet = Wallet.new
  puts "What game would you like to play? Options: Slots, BlackJack"
  input = gets.chomp!

  if wallet.funds < 5
    puts "I'm sorry, but we don't work for poor people."
    break
  end

############start slot loop
  if input.downcase == "slots"
    loop do
      wallet.sub(5)
      player = Slots.new
      wallet.add(player.slot)
      puts "Your wallet has $#{wallet.funds}"
      puts "Would you like to keep playing Slots? Yes/No"
      continue_slots = gets.chomp!
      if wallet.funds < 20
        puts "You don't have enough funds to play this game."
      end
      break if ((continue_slots.downcase == "no") || (wallet.funds < 5))
    end
##########end slot loop

##########Begin black jack loop
  elsif input.downcase == "blackjack"
    loop do
      puts "Your funds are $#{wallet.funds}."
      wallet.sub(20)
      ace = 0
      answer = "no"
      cards = []
      player = BlackJack.new
      cards << player.deal
      if cards.last == "Ace"
        ace += 1
      end
      cards << player.deal
      if cards.last == "Ace"
        ace += 1
      end
      puts "Your cards are #{cards[0]} and #{cards[1]}."
      numbers = player.match(cards.pop, cards.pop)
      cards << numbers

      ###Begin Hit loop
      loop do
        puts "Your score is #{numbers}."
        if numbers < 21
          puts "Hit? Yes/No?"
        
          answer = gets.chomp!
          if answer.downcase == "yes"
            cards << player.deal
            puts "You drew a #{cards.last}."
            if cards.last == "Ace"
              ace += 1
            end
            numbers = player.match(cards.pop, cards.pop)
            cards << numbers
          end
        else
          break
        end
        if (numbers > 21) && (ace > 0)
          ace -= 1
          numbers -= 10
          cards.pop
          cards << numbers
        end
        break if (answer.downcase != "yes") || (numbers > 22)
      end
      ###End Hit loop

      puts numbers
      dealer = player.dealer_results
      puts dealer
      wallet.add(player.compare(numbers, dealer))
      puts "Your funds are $#{wallet.funds}."
      puts "Would you like to keep playing BlackJack? Yes/No"
      continue_black = gets.chomp!
      if wallet.funds < 20
        puts "You don't have enough funds to play this game."
      end
      break if ((continue_black.downcase == "no") || (wallet.funds < 20))
    end
  end
#############End of black jack loop

  puts "Would you like to keep playing games? Yes/No"
  continue = gets.chomp!
  break if (continue.downcase == "no")
end
#############End main loop