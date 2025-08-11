#Ported files for Guile (dayx.sld) and Gambit (X.sld)[these also work with Gauche]

- learned sticking to only most common srfi's is best way to be portable, and that there just because a srfi is widely used and an implementation is popular, doesn't mean that implementation will have that srfi

- Did see a speed up in Gauche when I moved away from simple regexes to just string & char methods

- Guile requires (srfi srfi-x) import format
- Gambit requires (only ...) (prefix ...) etc for name clashes
