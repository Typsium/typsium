use std::collections::HashMap;

use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};

use crate::lexer::{Arrow, Token};

#[derive(Clone, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct KnownElement {
    pub atomic_number: u8,
    pub symbol: String,
    pub common_name: String,
    pub group: u8,
    pub period: u8,
    pub block: String,
    pub atomic_weight: f32,
    pub covalent_radius: f32,
    pub van_der_waal_radius: f32,
    pub outshell_electrons: u8,
    pub most_common_isotope: String,
    pub most_common_isotopic_mass: f32,
    pub density: f32,
    pub melting_point: f32,
    pub boiling_point: f32,
    pub electronegativity: f32,
    pub phase: String,
    pub cas: String,
}

pub static ELEMENTS: Lazy<HashMap<String, KnownElement>> = Lazy::new(|| {
    csv::Reader::from_reader(include_str!("../../resources/elements.csv").as_bytes())
        .deserialize()
        .map(|e| {
            let e: KnownElement = e.unwrap();
            (e.symbol.clone(), e)
        })
        .collect::<HashMap<String, KnownElement>>()
        .into_iter()
        .collect::<HashMap<String, KnownElement>>()
});

#[derive(Clone, Debug, Serialize)]
pub struct Element {
    pub symbol: String,
}

impl Element {
    pub fn new(symbol: &str) -> Self {
        Self {
            symbol: symbol.to_string(),
        }
    }

    pub fn try_known(&self) -> Option<KnownElement> {
        ELEMENTS.get(&self.symbol).cloned()
    }
}

#[derive(Clone, Debug, Serialize)]
#[serde(rename_all = "kebab-case")]
#[serde(tag = "type")]
pub enum Grouped {
    Single(Element),
    Parenthesized {
        children: Vec<Box<Component>>,
        bracket: Bracket,
    },
}

#[derive(Clone, Debug, Serialize)]
pub struct Component {
    pub base: Grouped,
    pub charge: Charge,
    pub count: u32,
}

#[derive(Clone, Copy, Debug, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum Bracket {
    Round,
    Square,
    Curly,
}
impl TryFrom<&Token> for Bracket {
    type Error = ();

    fn try_from(value: &Token) -> Result<Self, Self::Error> {
        match value {
            Token::LParen => Ok(Bracket::Round),
            Token::LBracket => Ok(Bracket::Square),
            Token::LBrace => Ok(Bracket::Curly),
            _ => Err(()),
        }
    }
}
impl Bracket {
    pub fn match_closing(&self, token: Token) -> bool {
        match self {
            Bracket::Round => matches!(token, Token::RParen),
            Bracket::Square => matches!(token, Token::RBracket),
            Bracket::Curly => matches!(token, Token::RBrace),
        }
    }
}

#[derive(Clone, Copy, Debug, Serialize)]
pub struct Charge(pub i32);

#[derive(Clone, Debug, Serialize)]
pub struct Formula(pub Vec<FormulaPart>);
#[derive(Clone, Debug, Serialize)]
#[serde(rename_all = "kebab-case")]
#[serde(tag = "type", content = "body")]
pub enum FormulaPart {
    Component(Component),
    Number(u32),
    Arrow(Arrow),
    Plus,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_elements() {
        assert_eq!(ELEMENTS.get("H").unwrap().atomic_number, 1);
    }
}
