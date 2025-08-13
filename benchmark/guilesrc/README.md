# Ported files for Guile (dayX.sld) and Gambit (X.sld)[these also work with Gauche]

- learned sticking to only most common srfi's is best way to be portable, and that there just because a srfi is widely used and an implementation is popular, doesn't mean that implementation will have that srfi

- Did see a speed up in Gauche when I moved away from simple regexes to just string & char methods

- [Guile](https://www.gnu.org/software/guile/manual/html_node/index.html) requires (srfi srfi-x) import format, compiles to bytecode
- [Gambit](https://web.archive.org/web/20250709114707/https://gambitscheme.org/latest/manual/) requires (only ...) (prefix ...) etc for name clashes, libraries in (scheme red) are under there srfi names [eg (srfi 1) instead of (scheme list)], compiles to C
