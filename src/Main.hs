{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad ((>=>))

import           Data.Maybe
import qualified Data.Text as T

import           GI.Gtk hiding (main)
import qualified GI.Gtk as Gtk
import           GI.GtkAttributes ()
import           GI.GtkSignals ()
import           GI.Utils.Base (castTo)

import           System.Environment (getArgs, getProgName)

main :: IO ()
main = do
    args     <- map T.pack <$> getArgs
    progName <- T.pack <$> getProgName

    -- restArgs <-
    Gtk.init (Just $ progName:args)

    builder <- builderNewFromFile "main.ui"
    window  <- initWindow builder

    widgetShowAll window
    Gtk.main

initWindow :: Builder -> IO Window
initWindow builder = do
    let getObject ctor = builderGetObject builder >=> castTo ctor >=> return . fromJust

    window <- getObject Window "mainWin"
    onWidgetDestroy window mainQuit

    mainStack    <- getObject Stack  "mainStack"
    startPage    <- getObject Widget "startPage" -- TODO: 'Widget' should be 'Box'
    themeList    <- getObject Widget "themeList" -- TODO: 'Widget' should be 'ListBox'
    --themeDetails <- getObject Widget "themeDetails" -- TODO: 'Widget' should be 'Box'

    -- initialize startpage
    spLocalButton  <- getObject Button "spLocalButton"
    spOnlineButton <- getObject Button "spOnlineButton"

    backButton     <- getObject Button "backButton"

    let enableBackButton = widgetSetSensitive backButton

    onButtonClicked spLocalButton $ do
        enableBackButton True
        stackSetVisibleChild mainStack themeList

    onButtonClicked spOnlineButton $ do
        enableBackButton True
        stackSetVisibleChild mainStack themeList

    onButtonClicked backButton $ do
        enableBackButton False

        curVisibleChild <- stackGetVisibleChildName mainStack
        stackSetVisibleChild mainStack $ case curVisibleChild of
            "themeList"    -> startPage
            "themeDetails" -> themeList
            _              -> error
                "The back button should not be sensitive on other pages than themeList and themeDetails!"

    return window
