#import "utils.typ": get-all-children, is-metadata, typst-builtin-styled, typst-builtin-context
#import "parse-formula-intermediate-representation.typ": string-to-ir
#let content-to-ir(body) = {
  if type(body) == str {
    return string-to-ir(body)
  } else if type(body) != content {
    return none
  }
  let children = get-all-children(body)

  // body
  // linebreak()
  // repr(body)
  // linebreak()
  // linebreak()

  let result = ()

  let string = ""
  for child in children {
    if is-metadata(child) {
      if is-kind(child, "molecule") {
        result += child.value.formula
      } else if is-kind(child, "element") {
        result += child.value.symbol
      }
    } else if type(child) == content{
      let func-type = child.func()
      if func-type == text {
        result += string-to-ir(child.at("text"))
        string += child.at("text")
      } else if func-type == typst-builtin-styled{
        let styles = child.at("styles")
        let ir = content-to-ir(child.at("child"))
        if type(ir) == array{
          if ir.len() == 1{
            ir = ir.at(0)
          } else{
            for value in ir {
              value.styles = styles
            }
            result += ir
          }
        }
        if type(ir) == dictionary{
          ir.styles = styles
          result.push(ir)
        }
        // result.push((type:"content", body:child))
      } else if func-type == typst-builtin-context {
        result.push((type:"content", body:child))
      }
      else if func-type  in (
        pad,
        figure,
        quote,
        strong,
        emph,
        highlight,
        overline,
        underline,
        strike,
        smallcaps,
        sub,
        super,
        box,
        block,
        hide,
        move,
        scale,
        circle,
        ellipse,
        rect,
        square,
        typst-builtin-styled
      ) {
        result.push((type:"content", body:child))
      } 
      else if child == [ ] {
      }
      else {
        result.push((type:"content", body:child))
      }

      repr(type(child))
      h(1em)
      repr(child.func())
      h(1em)
      repr(child.fields())
      h(4em)
      linebreak()
      // result += child
    }
  }
  // return result
  
  
  // return string-to-ir(string)
}
