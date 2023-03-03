open Printf;;

type qmlProp = 
{ 
  propId : string; 
  propVal : string 
};;

type qmlObj = 
{ 
  title : string; 
  qmlObjs : qmlObj list;
  qmlProps : qmlProp list
} ;;
let rec tab n = 
  match n with
  | 0 -> ""
  | n -> "\t" ^ tab (n - 1) ;; 

let rec propListToString list tp = 
  match list with
  | [] -> ""
  | hd :: tl ->  
    let line = tab tp ^ hd.propId ^ ": " ^ hd.propVal ^ "\n" in 
      line ^ (propListToString tl tp) ;;

let rec qmlObjListToString list tp = (*tp - tabulation parameter*)
  match list with
  | [] -> ""
  | hd :: tl -> 
      tab tp ^ hd.title ^ "\n" 
      ^ tab tp ^ "{" ^ "\n"
      ^ propListToString hd.qmlProps (tp + 1)
      ^ qmlObjListToString hd.qmlObjs (tp + 1)     
      ^ tab tp ^ "}" ^ "\n"
      ^ qmlObjListToString tl (tp) ;;

let textprops = [{propId = "id"; propVal = "text1"}; {propId = "x"; propVal = "40"}; {propId = "y"; propVal = "10"}; {propId = "text"; propVal = "hi"} ] ;;
let text = {title = "Text"; qmlObjs = []; qmlProps = textprops} ;;
let rectangle1props = [{propId = "id"; propVal = "rect1"}] ;;
let rectangle1 = {title = "Rectangle"; qmlObjs = [text]; qmlProps = rectangle1props} ;;
let imageprops = [{propId = "id"; propVal = "image1"}; {propId = "x"; propVal = "60"}; {propId = "y"; propVal = "30"}; {propId = "image"; propVal = "url"}] ;;
let image = {title = "Image"; qmlObjs = []; qmlProps = imageprops } ;;
let rectangle2props = [{propId = "id"; propVal = "rect2"}] ;;
let rectangle2 = {title = "Rectangle"; qmlObjs = [text; rectangle1]; qmlProps = rectangle2props} ;;

let _ = printf "%s" (qmlObjListToString [rectangle2] 0) ;;