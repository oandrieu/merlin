(* {{{ COPYING *(

  This file is part of Merlin, an helper for ocaml editors

  Copyright (C) 2013 - 2014  Frédéric Bour  <frederic.bour(_)lakaban.net>
                             Thomas Refis  <refis.thomas(_)gmail.com>
                             Simon Castellan  <simon.castellan(_)iuwt.fr>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.

)* }}} *)

open Std

type node = Browse_node.t

let default_loc = Location.none
let default_env = Env.empty

type t = {
  t_node: node;
  t_loc : Location.t;
  t_env : Env.t;
  t_children: t list lazy_t;
}

let of_node ?(loc=default_loc) ?(env=default_env) node =
  let rec one t_env t_loc t_node =
    let rec t = {t_node; t_env; t_loc; t_children = lazy (aux t)} in
    t
  and aux t =
    Browse_node.fold_node (fun env loc node acc -> one env loc node :: acc)
      t.t_env t.t_loc t.t_node []
  in
  one env loc node

let dummy = {
  t_node = Browse_node.Dummy;
  t_loc = default_loc;
  t_env = default_env;
  t_children = lazy []
}
