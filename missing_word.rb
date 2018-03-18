require 'bitcoin'
require 'money-tree'
require 'net/http'
require 'json'

words = File.readlines("words.txt").each {|l| l.chomp!}
words.each do |word|
    eleven_words = "mass roof drive crater umbrella sail fever answer taste then depend".split(" ")
    word_pos = 0
    begin
      if (word_pos > 0)
        eleven_words.delete_at(word_pos - 1)
      end
      eleven_words.insert(word_pos, word);
      puts "Trying for #{eleven_words.join(" ")}"     
   
      seed = Bitcoin::Trezor::Mnemonic.to_seed("")
      master = MoneyTree::Master.new(seed_hex: seed)
      node = master.node_for_path("m/0/0")
      key = Bitcoin::Key.new(node.private_key.to_hex)
      url = URI.parse("https://blockexplorer.com/api/addr/#{key.addr}/?noTxList=1")
      uri = URI(url)
      response = Net::HTTP.get(uri)
      bal = JSON.parse(response)
      if (bal["balance"] > 0)
         puts "FOUND !!!!!!!!!!!!! #{key.addr} / #{key.pub} /  #{key.priv} !!!!!!!!!!"
         exit
      end
      word_pos += 1
   end while word_pos < 12
end