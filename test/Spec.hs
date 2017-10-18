{-# LANGUAGE PackageImports #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import "hspec" Test.Hspec (hspec, describe)

-- local imports
import qualified QM.Spec
import qualified QN.Spec
import qualified QMB.Spec
import qualified QNB.Spec
import qualified QMS.Spec
import qualified QNS.Spec


main :: IO ()
main = hspec $ do
  describe "QM" QM.Spec.spec
  describe "QN (QM but without interpolation)" QN.Spec.spec
  describe "QMB (interpolated string with line-*B*reaks)" QMB.Spec.spec
  describe "QNB (QMB but without interpolation)" QNB.Spec.spec
  describe "QMS (interpolated string with line-breaks replaced with *S*paces)"
            QMS.Spec.spec
  describe "QNS (QMS but without interpolation)" QNS.Spec.spec
