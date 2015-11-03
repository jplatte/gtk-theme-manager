module GnomeLookOrg.Data
( Content(..)
) where

import           Data.Monoid ((<>))
import           Data.Text (Text)

import           GnomeLookOrg.Base

data ContentMeta = ContentMeta { contentMetaTotalItems :: Int } deriving Show

data Content = Content { contentId :: Int
                       , contentName :: Text
                       , contentVersion :: Text
                       , contentPersonID :: Text
                       , contentScore :: Int
                       , contentDescription :: Text
                       , contentComments :: Int
                       , contentFans :: Int
                       } deriving Show

dataUrl :: Text
dataUrl = apiBaseUrl <> "/content/data"
