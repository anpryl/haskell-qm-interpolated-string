{-# LANGUAGE PackageImports #-}
{-# LANGUAGE QuasiQuotes #-}

module QNS.Spec (spec) where

import "hspec" Test.Hspec (Spec, describe, it, shouldBe)

-- local imports
import "qm-interpolated-string" Text.InterpolatedString.QM (qns)


spec :: Spec
spec = do

  it "Works as expected" $
    [qns|
      foo
      {1+2}
      bar
    |] `shouldBe` "foo {1+2} bar"

  it "Explicitly slicing line-breaks" $ do
    [qns|
      foo\
      {1+2}\
      bar\
      baz
    |] `shouldBe` "foo{1+2}barbaz"
    [qns|
      foo\
      {1+2}\
      bar\
      baz\
    |] `shouldBe` "foo{1+2}barbaz"

  describe "Examples from README" $ do

    it "First (decorative spacing and escaping space symbol)" $
      [qns|   hello world,
            \ what's going on here?  |]
        `shouldBe` "hello world,  what's going on here?"

    it "Second (breaking lines)" $
      [qns|
            it's actual
            ly NOT ignored
         |]
            `shouldBe` "it's actual ly NOT ignored"

    it "Third (explicit line-breaks symbols, line-break plus space)" $
      [qns|  \  You could explicitly escape indentation or\n
                line-breaks when you really need it!  \
          |] `shouldBe` "  You could explicitly escape indentation or\n \
                        \line-breaks when you really need it!  "

    it "Fourth (escaping interpolation blocks to show them as text)" $
      [qns| {1+2} \{3+4} |] `shouldBe` "{1+2} \\{3+4}"

    it "Example of `qns` QuasiQuoter" $
      [qns| foo {1+2} |] `shouldBe` "foo {1+2}"

  it "Type annotation in interpolation block" $
    [qns|{10 :: Float}|] `shouldBe` "{10 :: Float}"

  it "Escaping interpolation symbols inside interpolation block" $ do
    [qns|foo {"b{a{r"} baz|] `shouldBe` "foo {\"b{a{r\"} baz"
    [qns|foo {"b\}a\}r"} baz|] `shouldBe` "foo {\"b\\}a\\}r\"} baz"

  it "Example from generated docs (double-space)" $
    [qns| foo {'b':'a':'r':""}
        \ baz |] `shouldBe` "foo {'b':'a':'r':\"\"}  baz"

  it "Escaping backslashes" $ do [qns| foo\bar |]    `shouldBe` "foo\\bar"
                                 [qns| foo\\bar |]   `shouldBe` "foo\\bar"
                                 [qns| foo\\\bar |]  `shouldBe` "foo\\\\bar"
                                 [qns| foo\\\\bar |] `shouldBe` "foo\\\\bar"

  it "Empty string" $ [qns|  |] `shouldBe` ""

  it "Escaping space by slash at EOL after space (line-break is sliced)" $
    [qns| foo \
          bar |] `shouldBe` "foo bar"

  it "Escaped spaces at the edges" $ do [qns| foo\ |] `shouldBe` "foo "
                                        [qns|\ foo |] `shouldBe` " foo"

  describe "Tabs as indentation" $ do

    it "Tabs is only indentation at left side" $ do
			[qns|
				foo  bar  baz
			|] `shouldBe` "foo  bar  baz"

			[qns|			foo bar baz|] `shouldBe` "foo bar baz"

    it "Tabs also at EOL" $ do
			[qns|
				foo  bar  baz				
			|] `shouldBe` "foo  bar  baz"

			[qns|			foo bar baz				|] `shouldBe` "foo bar baz"

    it "Escaped tabs" $ do
      [qns|		\tfoo|]    `shouldBe` "\tfoo"
      [qns|		\	foo	|]   `shouldBe` "\tfoo"
      [qns|	foo		\	|]   `shouldBe` "foo\t\t\t"
      [qns|	foo	\		|]   `shouldBe` "foo\t\t"
      [qns|	foo\			|] `shouldBe` "foo\t"

  it "Tails" $ do
    [qns|    
           foo   
                 |] `shouldBe` "foo"
    [qns|	 
         	
          foo	 
               
             	
                 |] `shouldBe` "foo"
    [qns|				
            foo			
            				
            				|] `shouldBe` "foo"