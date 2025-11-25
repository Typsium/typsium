#import "parse-formula-intermediate-representation.typ": string-to-reaction
#import "parse-content-intermediate-representation.typ": content-to-reaction
#import "typing.typ": set-arrow, set-element, set-group
#import "model/arrow-element.typ": arrow
#import "model/element-element.typ": element
#import "model/group-element.typ": group
#import "model/molecule-element.typ": molecule
#import "model/reaction-element.typ": reaction

///This is the main function of this package. Draws chemical equations and molecules. You can use both strings and content as input. We will try our best to parse it.
///
/// ```example
/// #ce("H2O") \
/// #ce[H2O]
/// ```
/// -> content
#let ce(
  /// The equation or molecule that should be drawn -> string|content
  formula
  ) = {
  show "*": sym.dot
  if type(formula) == str{
    let result = string-to-reaction(formula)
    if result.len() == 1{
      result.at(0)
    } else {
      reaction(result)
    }
  } else if type(formula) == content{
    let result = content-to-reaction(formula)
    if result.len() == 1{
      result.at(0)
    } else {
      reaction(result)
    }
  }
}
