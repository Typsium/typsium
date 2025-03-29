use std::fmt::Display;

use crate::lexer::Token;

pub enum TypsiumError {
    UnknownError(String),

    MismatchedBrackets,

    UnexpectedToken(Token),
    UnexpectedEndOfInput,
}

impl From<String> for TypsiumError {
    fn from(value: String) -> Self {
        TypsiumError::UnknownError(value)
    }
}

impl Display for TypsiumError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            TypsiumError::UnknownError(err) => write!(f, "Unknown error: {}", err),
            TypsiumError::MismatchedBrackets => write!(f, "Mismatched brackets"),
            TypsiumError::UnexpectedToken(token) => write!(f, "Unexpected token: {:?}", token),
            TypsiumError::UnexpectedEndOfInput => write!(f, "Unexpected end of input"),
        }
    }
}

pub type TypsiumResult<T> = std::result::Result<T, TypsiumError>;
