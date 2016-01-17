let strings = import <nixpkgs/lib/strings.nix>;
    lists = import <nixpkgs/lib/lists.nix>;
    input = builtins.readFile ./input.2;
    lines = strings.splitString "\n" (strings.removeSuffix "\n" input);
    wrapGift = line:
      let dims = map strings.toInt (strings.splitString "x" line);
          sortedDims = builtins.sort builtins.lessThan dims;
          a = builtins.elemAt sortedDims 0;
          b = builtins.elemAt sortedDims 1;
          c = builtins.elemAt sortedDims 2;
      in
      2 * (a * b +  a * c + b * c) + a * b;
    sizes = map wrapGift lines;
in
lists.fold (a: b: a+b) 0 sizes
