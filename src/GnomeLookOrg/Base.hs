module GnomeLookOrg.Base
( apiDomain
, apiBaseUrl
) where

apiDomain :: String
apiDomain = "api.gnome-look.org"

apiBaseUrl :: String
apiBaseUrl = "https://" ++ apiDomain ++ "/v1"
