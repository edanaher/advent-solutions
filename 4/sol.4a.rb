require "digest"; h=STDIN.read.chomp; 1000000.times { |x| d = Digest::MD5.hexdigest("#{h}#{x}"); if d[0..4] == "00000"; puts "#{x} #{d}"; exit; end }
