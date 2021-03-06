require 'bitcoin'
require 'money-tree'
require 'net/http'
require 'json'

Bitcoin.network = :litecoin
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
   
      seed = Bitcoin::Trezor::Mnemonic.to_seed(eleven_words.join(" "))
      master = MoneyTree::Master.new(seed_hex: seed)
      node = master.node_for_path("m/0/0")
      key = Bitcoin::Key.new(node.private_key.to_hex)
      # url = URI.parse("https://chain.so//api/v2/get_address_balance/LTC/#{key.addr}")
      url = URI.parse("https://bchain.info/LTC/addr/#{key.addr}")
      uri = URI(url)
      response = Net::HTTP.get(uri)
      if transactions_count = response.match(/var sum_in = (\d+);/)
        if transactions_count.captures[0].to_i() > 0
          puts "FOUND !!!!!!!!!!!!! #{key.addr} / #{key.pub} /  #{key.priv} !!!!!!!!!!"
          exit
        end
      end
      word_pos += 1
   end while word_pos < 12
end
