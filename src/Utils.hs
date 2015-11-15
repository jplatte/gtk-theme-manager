module Utils
( laxElementContent
, readContent
) where

import           Control.Arrow ((>>>))
import           Data.Maybe (listToMaybe)
import qualified Data.Text as T
import           Text.XML.Cursor
import           Safe (readMay)

laxElementContent :: T.Text -> Cursor -> [T.Text]
laxElementContent name = laxElement name &/ content

readContent :: Read a => [T.Text] -> Maybe a
readContent = listToMaybe >=> T.unpack >>> readMay
