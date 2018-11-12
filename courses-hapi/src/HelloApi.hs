{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}



module HelloApi where

import           Data.Aeson
import           Data.Proxy
import           Data.Text    (Text)
import           GHC.Generics
import           Servant.Api
