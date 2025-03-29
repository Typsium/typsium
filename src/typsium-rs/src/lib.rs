mod lexer;
mod model;
mod parser;
mod result;

use lexer::Token;
use logos::Logos;
pub use model::*;
pub use parser::Parse;
pub use result::*;

use typst_wasm_protocol::wasm_export;

impl From<Formula> for Vec<u8> {
    fn from(value: Formula) -> Self {
        serde_json::to_vec(&value).unwrap()
    }
}

#[wasm_export]
pub fn ce(formula: &[u8]) -> Result<Formula, String> {
    let formula = String::from_utf8_lossy(formula);
    let mut lexer = Token::lexer(&formula).peekable();
    Formula::take(&mut lexer).map_err(|err| format!("{}", err))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ce() {
        let formula = b"[Cu(H2O)4]^2+ + 4NH3 -> [Cu(NH3)4]^2+ + 4H2O";
        let result = ce(formula);
        println!("{:?}", result);
        assert!(result.is_ok());
    }
}
