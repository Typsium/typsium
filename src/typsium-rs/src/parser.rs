use crate::{
    Bracket, Charge, Component, Element, Formula, FormulaPart, Grouped, TypsiumError,
    TypsiumResult, lexer::Token,
};

type PeekLexer<'a> = std::iter::Peekable<logos::Lexer<'a, Token>>;

fn next_token(lexer: &mut PeekLexer) -> TypsiumResult<Token> {
    match lexer.next() {
        Some(Ok(token)) => Ok(token),
        Some(Err(err)) => Err(TypsiumError::UnknownError(err)),
        None => Err(TypsiumError::UnexpectedEndOfInput),
    }
}

fn peek_token(lexer: &mut PeekLexer) -> TypsiumResult<Token> {
    match lexer.peek() {
        Some(Ok(token)) => Ok(token.clone()),
        Some(Err(err)) => Err(TypsiumError::UnknownError(err.to_string())),
        None => Err(TypsiumError::UnexpectedEndOfInput),
    }
}

pub trait Parse<T>: Sized {
    fn take(lexer: &mut T) -> TypsiumResult<Self>;
}

impl<'a> Parse<PeekLexer<'a>> for Element {
    fn take(lexer: &mut PeekLexer) -> TypsiumResult<Self> {
        let token = next_token(lexer)?;
        match token {
            Token::Element(ref symbol) => Ok(Element::new(symbol)),
            _ => Err(TypsiumError::UnexpectedToken(token)),
        }
    }
}

impl<'a> Parse<PeekLexer<'a>> for Charge {
    fn take(lexer: &mut PeekLexer) -> TypsiumResult<Self> {
        match lexer.peek() {
            Some(Ok(Token::Hat)) => {}
            _ => return Ok(Charge(0)),
        }
        lexer.next();
        let token = next_token(lexer)?;
        match token {
            Token::Plus => Ok(Charge(1)),
            Token::Minus => Ok(Charge(-1)),
            Token::UInt(c) => {
                if c == 0 {
                    return Err(TypsiumError::UnknownError(
                        "Charge cannot be zero".to_string(),
                    ));
                }
                match next_token(lexer)? {
                    Token::Plus => {
                        return Ok(Charge(c as i32));
                    }
                    Token::Minus => {
                        return Ok(Charge(-(c as i32)));
                    }
                    _ => {
                        return Err(TypsiumError::UnexpectedToken(token));
                    }
                }
            }
            _ => Err(TypsiumError::UnexpectedToken(token)),
        }
    }
}

impl<'a> Parse<PeekLexer<'a>> for Component {
    fn take(lexer: &mut PeekLexer) -> TypsiumResult<Self> {
        let base = Grouped::take(lexer)?;
        let charge = Charge::take(lexer)?;
        let count = match lexer.peek() {
            Some(Ok(Token::UInt(c))) => Some(*c),
            _ => None,
        }
        .map(|c| {
            lexer.next();
            c
        })
        .unwrap_or(1);
        Ok(Component {
            base,
            charge,
            count,
        })
    }
}

impl<'a> Parse<PeekLexer<'a>> for Grouped {
    fn take(lexer: &mut PeekLexer) -> TypsiumResult<Self> {
        let mut bracket = None;
        match peek_token(lexer)? {
            Token::LParen => {
                lexer.next();
                bracket = Some(Bracket::Round);
            }
            Token::LBracket => {
                lexer.next();
                bracket = Some(Bracket::Square);
            }
            Token::Element(_) => {
                return Ok(Grouped::Single(Element::take(lexer)?));
            }
            _ => {}
        }
        let mut children = Vec::new();
        loop {
            if let Some(brkt) = bracket {
                if brkt.match_closing(peek_token(lexer)?) {
                    break;
                }
            } else if lexer.peek().is_none() {
                return Err(TypsiumError::UnexpectedEndOfInput);
            }
            let next = peek_token(lexer)?;
            match next {
                Token::Element(_) | Token::LParen | Token::LBracket => {
                    let child = Component::take(lexer)?;
                    children.push(Box::new(child));
                }
                _ => break,
            }
        }
        if let Some(brkt) = bracket {
            if !brkt.match_closing(peek_token(lexer)?) {
                return Err(TypsiumError::MismatchedBrackets);
            }
            lexer.next();
            Ok(Grouped::Parenthesized {
                children,
                bracket: brkt,
            })
        } else {
            unreachable!()
        }
    }
}

impl<'a> Parse<PeekLexer<'a>> for Formula {
    fn take(lexer: &mut PeekLexer<'a>) -> TypsiumResult<Self> {
        let mut parts = Vec::new();
        while lexer.peek().is_some() {
            match peek_token(lexer)? {
                Token::LParen | Token::LBracket | Token::Element(_) => {
                    let component = Component::take(lexer)?;
                    parts.push(FormulaPart::Component(component));
                }
                Token::UInt(c) => {
                    lexer.next();
                    parts.push(FormulaPart::Number(c));
                }
                Token::Plus => {
                    lexer.next();
                    parts.push(FormulaPart::Plus);
                }
                Token::Arrow(arr) => {
                    lexer.next();
                    parts.push(FormulaPart::Arrow(arr));
                }
                _ => {
                    return Err(TypsiumError::UnexpectedToken(peek_token(lexer)?));
                }
            }
        }
        return Ok(Formula(parts));
    }
}
