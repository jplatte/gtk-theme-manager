import           Control.Monad ((>=>))

import           Data.Maybe
import qualified Data.Text as T

import           GI.Gtk hiding (main)
import qualified GI.Gtk as Gtk
import           Data.GI.Base (castTo)

import           System.Environment (getArgs, getProgName)

--import qualified GnomeLookOrg as GLO

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

initWindow :: Builder -> IO ApplicationWindow
initWindow builder = do
    let getObject ctor = builderGetObject builder >=> castTo ctor >=> return . fromJust

    window <- getObject ApplicationWindow "mainWin"
    onWidgetDestroy window mainQuit

    mainStack    <- getObject Stack   "mainStack"
    startPage    <- getObject Box     "startPage"
    themeList    <- getObject ListBox "themeList"
    --themeDetails <- getObject Box     "themeDetails"

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

        -- eta reduce not possible because of https://wiki.haskell.org/Monomorphism_restriction
        let goToPage page = stackSetVisibleChild mainStack page
        stackGetVisibleChildName mainStack >>= \case
            "themeList"    -> goToPage startPage
            "themeDetails" -> goToPage themeList
            _              -> error
                "The back button should not be sensitive on other pages than themeList and themeDetails!"

    return window
