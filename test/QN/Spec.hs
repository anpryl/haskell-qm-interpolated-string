{-# LANGUAGE PackageImports #-}
{-# LANGUAGE QuasiQuotes #-}

module QN.Spec (spec) where

import "hspec" Test.Hspec (Spec, describe, it, shouldBe)

-- local imports
import "qm-interpolated-string" Text.InterpolatedString.QM (qn)


spec :: Spec
spec = do

  describe "Examples from README" $ do

    it "First (decorative spacing and escaping space symbol)" $
      [qn|   hello world,
           \ what's going on here?  |]
        `shouldBe` "hello world, what's going on here?"

    it "Second (merging lines without spaces)" $
      [qn|
            it's actual
            ly ignored
         |]
            `shouldBe` "it's actually ignored"

    it "Third (explicit line breaks symbols)" $
      [qn|  \  You could explicitly escape indentation or\n
               line breaks when you really need it!  \
         |] `shouldBe` "  You could explicitly escape indentation or\n\
                       \line breaks when you really need it!  "

    it "Fourth (escaping interpolation blocks to show them as text)" $
      [qn| {1+2} \{3+4} |] `shouldBe` "{1+2} \\{3+4}"

    it "Example of `qn` QuasiQuoter" $
      [qn| foo {1+2} |] `shouldBe` "foo {1+2}"

  it "Type annotation in interpolation block" $
    [qn|{10 :: Float}|] `shouldBe` "{10 :: Float}"

  it "Escaping interpolation symbols inside interpolation block" $ do
    [qn|foo {"b{a{r"} baz|] `shouldBe` "foo {\"b{a{r\"} baz"
    [qn|foo {"b\}a\}r"} baz|] `shouldBe` "foo {\"b\\}a\\}r\"} baz"

  it "Example from generated docs" $
    [qn| foo {'b':'a':'r':""}
       \ baz |] `shouldBe` "foo {'b':'a':'r':\"\"} baz"

  it "Escaping backslashes" $ do [qn| foo\bar |]    `shouldBe` "foo\\bar"
                                 [qn| foo\\bar |]   `shouldBe` "foo\\bar"
                                 [qn| foo\\\bar |]  `shouldBe` "foo\\\\bar"
                                 [qn| foo\\\\bar |] `shouldBe` "foo\\\\bar"

  it "Empty string" $ [qn|  |] `shouldBe` ""

  it "Escaping space by slash at EOL after space" $
    [qn| foo \
         bar |] `shouldBe` "foo bar"

  it "Escaped spaces at the edges" $ do [qn| foo\ |] `shouldBe` "foo "
                                        [qn|\ foo |] `shouldBe` " foo"

  describe "Tabs as indentation" $ do

    it "Tabs is only indentation at left side" $ do
			[qn|
				foo  bar  baz
			|] `shouldBe` "foo  bar  baz"

			[qn|			foo bar baz|] `shouldBe` "foo bar baz"

    it "Tabs also at EOL" $ do
			[qn|
				foo  bar  baz				
			|] `shouldBe` "foo  bar  baz"

			[qn|			foo bar baz				|] `shouldBe` "foo bar baz"

    it "Escaped tabs" $ do
      [qn|		\tfoo|]    `shouldBe` "\tfoo"
      [qn|		\	foo	|]   `shouldBe` "\tfoo"
      [qn|	foo		\	|]   `shouldBe` "foo\t\t\t"
      [qn|	foo	\		|]   `shouldBe` "foo\t\t"
      [qn|	foo\			|] `shouldBe` "foo\t"

  it "Tails" $ do
    [qn|    
           foo   
                 |] `shouldBe` "foo"
    [qn|	 
         	
          foo	 
               
             	
                 |] `shouldBe` "foo"
    [qn|				
            foo			
            				
            				|] `shouldBe` "foo"

  describe "New README examples" $ do

    it "Simple usage example" $ do
      [qn|
        <article>
          <h1>{title}</h1>
          <p>{text}</p>
        </article>
      |] `shouldBe` "<article><h1>{title}</h1><p>{text}</p></article>"

    it "Interpolation" $ [qn| foo {1+2} |] `shouldBe` "foo {1+2}"
