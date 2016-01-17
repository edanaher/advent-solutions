let lists = import <nixpkgs/lib/lists.nix>;
    input = builtins.readFile ./input.1;
    chars_f = str: n:
      if n == builtins.stringLength str then []
      else [(builtins.substring n 1 str)] ++ chars_f str (n + 1);
    chars = chars_f input 0;
    find_neg = n: floor:
      let c = builtins.elemAt chars n;
          dir = if c == "(" then 1 else if c == ")" then -1 else 0;
          floor' = floor + dir;
      in
        if floor' < 0 then 1 + n else
        find_neg (n+1) floor';
in
find_neg 0 0
