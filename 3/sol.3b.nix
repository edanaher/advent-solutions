let strings = import <nixpkgs/lib/strings.nix>;
    update_position = pos: c:
      let x = builtins.head pos;
          y = builtins.elemAt pos 1;
      in
      if c == "<" then [(x - 1) y] else
      if c == ">" then [(x + 1) y] else
      if c == "v" then [x (y + 1)] else
      if c == "^" then [x (y - 1)] else
      [x y];
    input = strings.stringToCharacters (builtins.readFile ./input.3);
    runPath = path: pos: pos2: soFar:
      let pos' = update_position pos (builtins.head path);
          soFar' = if builtins.elem pos soFar then soFar else soFar ++ [pos];
      in
      if path == [] then soFar' else
      runPath (builtins.tail path) pos2 pos' soFar';
    coords = runPath input [0 0] [0 0] [];
in
builtins.length coords
