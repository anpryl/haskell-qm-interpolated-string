{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE IncoherentInstances #-}
{-# LANGUAGE FlexibleInstances #-}

{-# LANGUAGE PackageImports #-}

module Text.InterpolatedString.QM.ShowQ.Class (ShowQ (..)) where

import "bytestring" Data.ByteString.Char8 as Strict (ByteString, unpack)
import "bytestring" Data.ByteString.Lazy.Char8 as Lazy (ByteString, unpack)
import "text" Data.Text as T (Text, unpack)
import "text" Data.Text.Lazy as LazyT (Text, unpack)


class ShowQ a where
  showQ :: a -> String

instance ShowQ Char where
  showQ = (:[])

instance ShowQ String where
  showQ = id
