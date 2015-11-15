# GTK+ theme manager

*Work in progress*

## Building

Note: You will need ghc and cabal installed.

```sh
cabal sandbox init
cabal install haskell-gi
./genPropsSignals.sh

# These two steps are only necessary
# before gi-gtk-hs is uploaded to hackage.
git clone https://github.com/haskell-gi/gi-gtk-hs.git
cabal install gi-gtk-hs/

cabal install
```
