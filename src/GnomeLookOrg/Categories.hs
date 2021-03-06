module GnomeLookOrg.Categories
( Category(..)
, gtk2
, gtk3
) where

import qualified Data.Text as T

import           GnomeLookOrg.Base

data Category = Category { categoryId :: Int
                         , categoryName :: T.Text
                         } deriving Show

gtk2 :: IO Category
gtk2 = return fallbackGtk2 -- TODO

gtk3 :: IO Category
gtk3 = return fallbackGtk3 -- TODO

categoriesUrl :: String
categoriesUrl = apiBaseUrl ++ "/content/categories"

-- The gtk theme categories at the time of writing
fallbackGtk2 :: Category
fallbackGtk2 = Category 100 "GTK 2.x Theme/Style"

fallbackGtk3 :: Category
fallbackGtk3 = Category 167 "GTK 3.x Theme/Style"
