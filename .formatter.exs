# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    defclass: 2,
    definst: :*,
    extend: :*
  ],
  export: [
    locals_without_parens: [
      defclass: 2,
      definst: :*,
      extend: :*
    ]
  ]
]
