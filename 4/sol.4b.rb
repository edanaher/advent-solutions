require "digest"; h=STDIN.read.chomp; 10000000.times { |x| d = Digest::MD5.hexdigest("#{h}#{x}"); if d[0..5] == "000000"; puts "#{x} #{d}"; exit; end }
