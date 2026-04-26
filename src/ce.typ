#import "parse-formula-intermediate-representation.typ": string-to-reaction
#import "parse-content-intermediate-representation.typ": content-to-reaction
#import "model/reaction-element.typ": reaction

#let reaction-localised={
  context{
    if text.lang == "fr"{
      [Réaction]
    } else if text.lang == "de"{
      [Reaktion]
    } else if text.lang == "it"{
      [Reazione]
    }else {
      [Reaction]
    }
  }
}


///This is the main function of this package. Draws chemical equations and molecules. You can use both strings and content as input. We will try our best to parse it.
///
/// ```example
/// #ce("H2O") \
/// #ce[H2O]
/// ```
/// -> content
#let ce(
  /// The equation or molecule that should be drawn -> string|content
  formula,
  /// The supplement to use to reference this chemical equation.
  /// defaults to "Reaction"
  supplement:auto,
  /// any other arguments that can be passed to the math.equation function.
  /// set block to true to reference it in your text
  /// use numbering to configure your numbering
  /// use number-align to configure how numbers align
  /// set alt to provide alt-text for accessibility
  ..args
  ) = {
  /* warning: this is a very expensive function, especially for long formulas. Use with caution.
  we want to show the intermediate representation for debugging purposes, but it can be very expensive to display and may cause OOM problem, so use very carefully and only for small formulas. */
  let is-debug = args.named().at("debug", default: false)
  let is-confirm = args.named().at("confirm", default: false)
  if is-debug {
    if not is-confirm {
      panic("`ce` debug mode may cause serious performance issues. Add `confirm: true` together with `debug: true` to enable debug output.")
    }
    let result = if type(formula) == str {
      string-to-reaction(formula)
    } else if type(formula) == content {
      content-to-reaction(formula)
    }
    return block(raw(repr(result)))
  }

  math.equation(
    if type(formula) == str{
      show "*": sym.dot
      let result = string-to-reaction(formula)
      if result.len() == 1{
        result.at(0)
      } else {
        reaction(result)
      }
    } else if type(formula) == content{
      show "*": sym.dot
      let result = content-to-reaction(formula)
      if result.len() == 1{
        result.at(0)
      } else {
        reaction(result)
      }
    },
    supplement: if supplement == auto {reaction-localised} else {supplement},
    ..args
  )
}