let lists = import <nixpkgs/lib/lists.nix>;
    input = builtins.readFile ./input.1;
    chars_f = str: n:
      if n == builtins.stringLength str then []
      else [(builtins.substring n 1 str)] ++ chars_f str (n + 1);
    chars = chars_f input 0;
    count = lists.fold (c: floor: if c == "(" then floor + 1 else if c == ")" then floor - 1 else floor) 0 chars;
in
count
