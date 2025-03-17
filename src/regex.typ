#let patterns = (
  // Match chemical elements with optional numbers (e.g., H2, Na, Fe3)
  element: regex("^\s*?([A-Z][a-z]?)\s?(\d+[a-z]*|[a-z])?"),
  
  // Match numerical coefficients before chemical formulas (e.g., 2H2O)
  coefficient: regex("^2\s*(\d+\.?\d*)"),
  
  // Match brackets [] {} () with optional subscripts
  bracket: regex("^\s*([\(\[\{\}\]\)])\s*(\d*|[a-z]+)?"),
  
  // Match ion charges (e.g., 2+, 3-, +)
  charge: regex("^\(?([0-9]*(\+|\-)+|\+|\-[0-9]*)\)?"),
  
  // Match physical states (s/l/g/aq)
  state: regex("^\((s|l|g|aq|solid|liquid|gas|aqueous)\)"),
  
  // Match various types of reaction arrows with optional conditions in brackets
  arrow: regex("^\s*(?:(<->|<==?>|-->|->|=|⇌|⇒|⇔)(?:\[([^\]]+)\])?|\[\])"),
  
  // Match plus signs between reactants/products
  plus: regex("^\s\+"),
  
  // Match heating conditions (Δ, heat, etc.)
  heating: regex("^\s*(Δ|δ|Delta|delta|heat|fire|hot|heating)\s*"),
  
  // Match temperature specifications (e.g., T = 298K)
  temperature: regex("^s*([Tt])\s*=\s*(\d+\.?\d*)\s*([K°C℃F])?"),
  
  // Match pressure specifications (e.g., P = 1atm)
  pressure: regex("^\s*([Pp])\s*=\s*(\d+\.?\d*)\s*(atm|bar|Pa|kPa|mmHg)?"),
  
  // Match catalyst specifications
  catalyst: regex("^\s*(cat|catalyst)\s*=?\s*([A-Za-z0-9\s]+)"),
  
  // Match general parameter assignments
  parameter: regex("^\s*([A-Za-z0-9]+)\s*=?\s*([A-Za-z0-9\s]+)"),
  
  // Match commas separating conditions
  comma: regex("^\s*,\s*"),
  
  // Match whitespace
  whitespace: regex("^\s+"),
  
  // Match numerical values
  number: regex("^\d+\.?\d*"),
)

// === remove all non-regex related content ===
