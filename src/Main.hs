import           Control.Monad.IO.Class (liftIO)

import qualified Data.Text as T

import           Data.GI.Gtk hiding (main)
import qualified Data.GI.Gtk as Gtk
import           Data.GI.Base.Attributes
import           Data.GI.Base.Signals
import           GI.Properties
import           GI.Signals
import           GI.GtkAttributes ()
import           GI.GtkSignals ()

import           System.Environment (getArgs, getProgName)

--import qualified GnomeLookOrg as GLO

main :: IO ()
main = do
    args     <- map T.pack <$> getArgs
    progName <- T.pack <$> getProgName

    -- restArgs <-
    Gtk.init (Just $ progName:args)

    builder <- builderNewFromFile "main.ui"
    window  <- buildWithBuilder buildWindow builder

    widgetShowAll window
    Gtk.main

buildWindow :: BuildFn ApplicationWindow
buildWindow = do
    window <- getObject ApplicationWindow "mainWin"
    liftIO $ on window Destroy mainQuit

    mainStack    <- getObject Stack   "mainStack"
    startPage    <- getObject Box     "startPage"
    themeList    <- getObject ListBox "themeList"
    --themeDetails <- getObject Box     "themeDetails"

    -- initialize startpage
    spLocalButton  <- getObject Button "spLocalButton"
    spOnlineButton <- getObject Button "spOnlineButton"

    backButton     <- getObject Button "backButton"

    liftIO $ on spLocalButton Clicked $ do
        set backButton [_sensitive := True]
        set mainStack  [_visibleChild := themeList]

    liftIO $ on spOnlineButton Clicked $ do
        set backButton [_sensitive := True]
        set mainStack  [_visibleChild := themeList]

    liftIO $ on backButton Clicked $ do
        set backButton [_sensitive := False]

        get mainStack _visibleChildName >>= \case
            "themeList"    -> set mainStack [_visibleChild := startPage]
            "themeDetails" -> set mainStack [_visibleChild := themeList]
            _              -> error
                "The back button should not be sensitive on other pages than themeList and themeDetails!"

    return window
