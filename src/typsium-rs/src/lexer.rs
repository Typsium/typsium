use logos::Logos;
use serde::Serialize;
use std::str::FromStr;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
#[serde(rename_all = "kebab-case")]
#[serde(tag = "type", content = "data")]
pub enum Arrow {
    /// ⇌
    Special,

    /// --?>, <--?>
    Single { left: bool },

    /// =, <==?>, ==?>
    Double { left: bool, right: bool },
}

impl FromStr for Arrow {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "⇌" => Ok(Arrow::Special),
            "->" | "-->" => Ok(Arrow::Single { left: false }),
            "<->" | "<-->" => Ok(Arrow::Single { left: true }),
            "=" => Ok(Arrow::Double {
                left: false,
                right: false,
            }),
            "=>" | "==>" => Ok(Arrow::Double {
                left: false,
                right: true,
            }),
            "<=>" | "<==>" => Ok(Arrow::Double {
                left: true,
                right: true,
            }),
            _ => Err(format!("Invalid arrow: {}", s)),
        }
    }
}

#[derive(Clone, Debug, PartialEq, Logos)]
#[logos(skip r" ")]
#[logos(error = String)]
pub enum Token {
    #[token("(")]
    LParen,
    #[token(")")]
    RParen,
    #[token("[")]
    LBracket,
    #[token("]")]
    RBracket,
    #[token("{")]
    LBrace,
    #[token("}")]
    RBrace,

    #[token("^")]
    Hat,
    #[token("_")]
    Underscore,

    #[regex("(⇌|--?>|<--?>|=|<==?>|==?>|⇒|⇔)", |lex| lex.slice().parse())]
    Arrow(Arrow),
    #[token("+")]
    Plus,
    #[token("-")]
    Minus,

    #[regex("[1-9][0-9]*", |lex| lex.slice().parse::<u32>().unwrap())]
    UInt(u32),

    #[regex("[A-Z][a-z]{0,2}", |lex| lex.slice().to_owned())]
    Element(String),

    #[regex("(s|l|g|aq|solid|liquid|gas|aqueous)", |lex| lex.slice().to_owned())]
    State(String),
}
