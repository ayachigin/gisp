--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
--import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "music/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/*" $ do
      route idRoute
      compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromRegex ".*\\.(md|markdown|rst)") $ do
      route   $ setExtension "html"
      compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls
{-
    match (fromList ["*.markdown", "*.md", "*.rts"]) $ do
        route   $ setExtension "html"
        compile $
          pandocCompiler >>=
          loadAndApplyTemplate "templates/default.html" defaultContext >>=
          relativizeUrls
-}
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 5) $
                     loadAll "posts/*" >>= recentFirst
            let
              indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    boolField "archive" (\_ -> length posts >= 5) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    -- RSS and Atom
    create ["atom.xml"] $ do
      route idRoute
      compile $ do
        let feedCtx = postCtx
        posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
        renderAtom myFeedConfiguration feedCtx posts

    create ["rss.xml"] $ do
      route idRoute
      compile $ do
        let feedCtx = postCtx
        posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
        renderRss myFeedConfiguration feedCtx posts

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "ゴーストイメソンプロジェクト"
    , feedDescription = "ゴーストをイメージして楽曲を作ろう！って企画のサイト"
    , feedAuthorName  = "あやちぎん"
    , feedAuthorEmail = "ayachigin@gmail.com"
    , feedRoot        = "http://ayachigin.github.io/gisp"
    }

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%Y/%m/%d" `mappend`
    defaultContext
