#!/bin/sh
cabal exec haskell-gi -- -a Gtk
cabal exec haskell-gi -- -c Gtk
mv GI src/GI
