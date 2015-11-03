module GnomeLookOrg.Base
( apiDomain
, apiBaseUrl
) where

import           Data.Monoid ((<>))
import           Data.Text (Text)

apiDomain :: Text
apiDomain = "api.gnome-look.org"

apiBaseUrl :: Text
apiBaseUrl = "https://" <> apiDomain <> "/v1"
