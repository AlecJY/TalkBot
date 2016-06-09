{-# LANGUAGE DeriveGeneric, DeriveAnyClass, StandaloneDeriving, FlexibleInstances, DeriveFunctor #-}
import qualified Data.Map.Strict as M
import System.Environment
import System.IO
import Control.DeepSeq
import Data.Monoid
import Data.Char (isAlpha, toLower)
import Data.List
import Data.List.Split
import Debug.Trace
import GHC.Generics (Generic)
type Mean = Double
type SD = Double
type Count = Int
    
data EmoData = EmoData Mean SD deriving (Show, Generic, NFData)

data Emotion a =
    Emotion { happiness :: a
            , anger :: a
            , sadness :: a
            , fear :: a
            , disgust :: a
            } deriving (Show, Generic, NFData, Functor)
data EmoStat = EmoStat Count Double deriving (Generic, NFData)


instance Show EmoStat where
    show (EmoStat count val) = show val
instance Monoid EmoStat where
    mempty = EmoStat 0 0
    mappend (EmoStat count1 val1) (EmoStat count2 val2) = EmoStat (count1 + count2) (val1 + val2)

instance Monoid (Emotion EmoStat) where
    mempty = Emotion mempty mempty mempty mempty mempty
    mappend (Emotion h1 a1 s1 f1 d1) (Emotion h2 a2 s2 f2 d2) = Emotion (h1 <> h2) (a1 <> a2) (s1 <> s2) (f1 <> f2) (d1 <> d2)
punc :: [Char]
punc = ",./<>?';:\"[]{}\\-_=+`~!@#$%^&*()"
toEmoStat :: Emotion EmoData -> Emotion EmoStat
toEmoStat emo = (\x -> case x of
                         EmoData mean sd -> EmoStat 1 mean) <$> emo
                                                                
sepByTab :: String -> [String]
sepByTab = splitWhen ((==) '\t')

parse :: [String] -> M.Map String (Emotion EmoData)
parse = foldl' (\acc x -> force $ case sepByTab x of { word:num:cat:
                                                       hap_mean:hap_sd:hap_sex:
                                                       ang_mean:ang_sd:ang_sex:
                                                       sad_mean:sad_sd:sad_sex:
                                                       fear_mean:fear_sd:fear_sex:
                                                       dis_mean:dis_sd:dis_sex:_ -> M.insert (filter (/= ' ') word) (Emotion { happiness = EmoData (read hap_mean) (read hap_sd)
                                                                                                                             , anger = EmoData (read ang_mean) (read ang_sd)
                                                                                                                             , sadness = EmoData (read sad_mean) (read sad_sd)
                                                                                                                             , fear = EmoData (read fear_mean) (read fear_sd)
                                                                                                                             , disgust = EmoData (read dis_mean) (read dis_sd)
                                                                                                                             }) acc
                                                     ; _ -> error $ "unrecognized data at: " ++ show x
                                                     }) M.empty . filter (/= "")

getEmo :: M.Map String (Emotion EmoData) -> [String] -> Emotion EmoStat
getEmo emodata str = foldl' (\acc x -> case M.lookup x emodata of
                                         Just emo -> (show x ++ " has emodata " ++ show emo)  `trace` toEmoStat emo <> acc 
                                         Nothing -> ("the word " ++ show x ++ " is not in the database") `trace` acc) mempty str 
emoAvg :: Emotion EmoStat -> Emotion EmoStat
emoAvg x = (\x -> case x of
                    EmoStat count val -> case count of
                                           0 -> EmoStat 0 0
                                           c -> EmoStat 1 (val / fromIntegral c)) <$> x
main :: IO ()
main = do
  args <- getArgs
  let file = case args of
               file:_ -> file
               _ -> error "no args"
  content <- fmap force $ readFile file
  let emo = parse $ tail $ lines content
  input <- getLine
  putStr "average: "
  putStrLn $ show $ emoAvg $ getEmo emo $ filter (all isAlpha) $ map (map toLower . filter (\x ->  not $ any (== x) punc)) $ words input
  return ()
