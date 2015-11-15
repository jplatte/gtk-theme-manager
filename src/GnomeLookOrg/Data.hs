module GnomeLookOrg.Data
( Meta(..)
, Content(..)
, Data(..)
, getData
) where

import           Data.ByteString.Char8 (pack)
import           Data.Maybe (catMaybes, listToMaybe)
import qualified Data.Text as T

import           Network.Connection (TLSSettings(..))
import           Network.HTTP.Conduit

import           Text.XML (parseLBS_, def)
import           Text.XML.Cursor

import           GnomeLookOrg.Base
import           GnomeLookOrg.Categories
import           Utils

data Meta = Meta { contentMetaTotalItems :: Int } deriving Show

data Content = Content { contentId :: Int
                       , contentName :: T.Text
                       , contentVersion :: T.Text
                       , contentDescription :: T.Text
                       , contentPersonId :: T.Text
                       , contentScore :: Int
                       } deriving Show

data Data = Data { meta :: Meta
                 , contents :: [Content]
                 } deriving Show

dataUrl :: String
dataUrl = apiBaseUrl ++ "/content/data"

parseContent :: Cursor -> Maybe Content
parseContent cursor = do
    id' <- readContent (cursor $/ laxElementContent "id")
    name <- listToMaybe (cursor $/ laxElementContent "name")
    version <- listToMaybe (cursor $/ laxElementContent "version")
    description <- listToMaybe (cursor $/ laxElementContent "description")
    personId <- listToMaybe (cursor $/ laxElementContent "personid")
    score <- readContent (cursor $/ laxElementContent "score")

    return Content { contentId = id'
                   , contentName = name
                   , contentVersion = version
                   , contentDescription = description
                   , contentPersonId = personId
                   , contentScore = score }

parseContents :: [Cursor] -> Maybe [Content]
parseContents cursors
    | length cursors == length parsed = Just parsed
    | otherwise                       = Nothing
    where parsed = catMaybes $ fmap parseContent cursors

parseData :: Cursor -> Maybe Data
parseData cursor = do
    totalItems <- readContent
        (cursor $/ laxElement "meta" &/ laxElementContent "totalitems")
    parsedContents <- parseContents (cursor $/ laxElement "data" &/ anyElement)

    return Data { meta = Meta totalItems, contents = parsedContents }

getData :: Category  -- ^ Category
        -> Int       -- ^ Page number, starting from 0
        -> Int       -- ^ Pagesize (amount of entries per page)
        -> IO (Maybe Data)
getData (Category catId _) pageNum pageSize = do
    initReq <- parseUrl dataUrl
    let request = setQueryString [ ("categories", Just (pack $ show catId))
                                 , ("page",       Just (pack $ show pageNum))
                                 , ("pagesize",   Just (pack $ show pageSize))
                                 ] initReq
    -- TODO: As far as I understand, reusing one manager
    --       across the whole application would be better.
    manager <- newManager (mkManagerSettings (TLSSettingsSimple True False False) Nothing)
    reply <- httpLbs request manager

    return . parseData . fromDocument . parseLBS_ def $ responseBody reply
