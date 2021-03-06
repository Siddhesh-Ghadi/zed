(*
 * zed_utils.ml
 * -----------
 * Copyright : (c) 2019, ZAN DoYe <zandoye@gmail.com>
 * Licence   : BSD3
 *
 * This file is a part of Zed, an editor engine.
 *)


open CamomileLibraryDefault.Camomile

module Convert(US: UnicodeString.Type)= struct
  let of_list l=
    let buf= US.Buf.create 0 in
    let rec convert l=
      match l with
      | []-> ()
      | c::tl -> US.Buf.add_char buf c; convert tl
    in
    convert l;
    US.Buf.contents buf

  let of_array a=
    let buf= US.Buf.create 0 in
    for i= 0 to Array.length a - 1 do
      US.Buf.add_char buf a.(i)
    done;
    US.Buf.contents buf

  let to_uChars us=
    let first= US.first us
    and last= US.last us in
    let length= US.length us in
    let rec create acc i=
      if US.compare_index us i first >= 0
      then create (US.look us i :: acc) (US.prev us i)
      else acc
    in
    if length > 0 then
      create [] last
    else
      []
end

let array_rev a=
  let len= Array.length a - 1 in
  Array.init len (fun i-> a.(len-i))

let rec list_compare ?(compare=compare) l1 l2=
  match l1, l2 with
  | [], []-> 0
  | [], _-> -1
  | _, []-> 1
  | h1::t1, h2::t2->
    match compare h1 h2 with
    | 0-> list_compare ~compare t1 t2
    | _ as r-> r

let array_compare ?(compare=compare) a1 a2=
  let len1= Array.length a1
  and len2= Array.length a2 in
  let rec compare_aux pos=
    let remain1= len1 - pos
    and remain2= len2 - pos in
    if remain1 <= 0 && remain2 <= 0 then 0
    else if remain1 <= 0 && remain2 > 0 then -1
    else if remain1 > 0 && remain2 <= 0 then 1
    else match compare a1.(pos) a2.(pos) with
      | 0-> compare_aux (pos + 1)
      | _ as r-> r
  in
  compare_aux 0

