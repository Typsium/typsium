#import "../../src/display-intermediate-representation.typ": display-ir
#set page(width: auto, height: auto, margin: 0.5em)

#let reaction1 = (
  (
    type: "molecule",
    charge: 2,
    children: (
      (
        type: "group",
        kind: 1,
        children: (
          (
            type: "element",
            symbol: "Cu",
          ),
          (
            type: "group",
            kind: 0,
            count: 4,
            children: (
              (
                type: "element",
                count: 2,
                symbol: "H",
              ),
              (
                type: "element",
                symbol: "O",
              ),
            ),
          ),
        ),
      ),
    ),
  ),
  (type: "align"),
  (
    type: "arrow",
    kind: 1,
    top: none,
    bottom: none,
  ),
  (
    type: "molecule",
    charge: 2,
    children: (
      (
        type: "group",
        kind: 1,
        children: (
          (
            type: "element",
            symbol: "Cu",
          ),
          (
            type: "group",
            kind: 0,
            count: 4,
            children: (
              (
                type: "element",
                symbol: "N",
              ),
              (
                type: "element",
                count: 3,
                symbol: "H",
              ),
            ),
          ),
        ),
      ),
    ),
  ),
  (type: "+"),
  (
    type: "molecule",
    count: 4,
    children: (
      (
        type: "element",
        count: 2,
        symbol: "H",
      ),
      (
        type: "element",
        symbol: "O",
      ),
    ),
  ),
)

#let reaction2 = (
  (
    type: "molecule",
    charge: 2,
    children: (
      (
        type: "group",
        kind: 1,
        children: (
          (
            type: "element",
            symbol: "Cu",
          ),
          (
            type: "group",
            kind: 0,
            count: 4,
            children: (
              (
                type: "element",
                count: 2,
                symbol: "H",
              ),
              (
                type: "element",
                symbol: "O",
              ),
            ),
          ),
        ),
      ),
    ),
  ),
  (
    type: "+",
  ),
  (
    type: "molecule",
    count: 4,
    children: (
      (
        type: "element",
        symbol: "N",
      ),
      (
        type: "element",
        count: 3,
        symbol: "H",
      ),
    ),
  ),
  (type: "align"),
  (
    type: "arrow",
    kind: 1,
    top: (
      (
        type: "content",
        body: [dissolve in ],
      ),
      (
        type: "molecule",
        children: (
          (
            type: "element",
            count: 2,
            symbol: "H",
          ),
          (
            type: "element",
            symbol: "O",
          ),
        ),
      ),
    ),
    bottom: (
      (
        type: "content",
        body: $Delta H^0$,
      ),
    ),
  ),
  (
    type: "molecule",
    count: 4,
    children: (
      (
        type: "element",
        count: 2,
        symbol: "H",
      ),
      (
        type: "element",
        symbol: "O",
      ),
    ),
  ),
)

$
  #display-ir(reaction1)\
  #display-ir(reaction2)\
$
