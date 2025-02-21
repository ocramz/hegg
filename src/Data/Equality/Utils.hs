{-# LANGUAGE StandaloneDeriving #-}
{-|
 Misc utilities used accross modules
 -}
module Data.Equality.Utils where

-- import GHC.Conc
import Data.Foldable
import Data.Bits

-- import qualified Data.Set    as S
-- import qualified Data.IntSet as IS
import Data.Functor.Classes

-- | Fixed point newtype.
--
-- Ideally we should use the data-fix package, but right now we're rolling our
-- own due to an initial idea to avoid dependencies to be easier to upstream
-- into GHC (for improvements to the pattern match checker involving equality
-- graphs). I no longer think we can do that without vendoring in some part of
-- just e-graphs, but until I revert the decision we use this type.
newtype Fix f = Fix { unFix :: f (Fix f) }

instance Eq1 f => Eq (Fix f) where
    (==) (Fix a) (Fix b) = liftEq (==) a b
    {-# INLINE (==) #-}

instance Show1 f => Show (Fix f) where
    showsPrec d (Fix f) = liftShowsPrec showsPrec showList d f
    {-# INLINE showsPrec #-}

-- | Catamorphism
cata :: Functor f => (f a -> a) -> (Fix f -> a)
cata f = f . fmap (cata f) . unFix
{-# INLINE cata #-}

-- | Get the hash of a string.
--
-- This util is currently used to generate an 'Int' used for the internal
-- pattern variable representation from the external pattern variable
-- representation ('String')
hashString :: String -> Int
hashString = foldl' (\h c -> 33*h `xor` fromEnum c) 5381
{-# INLINE hashString #-}

-- -- | We don't have the parallel package, so roll our own simple parMap
-- parMap :: (a -> b) -> [a] -> [b]
-- parMap _ [] = []
-- parMap f (x:xs) = fx `par` (fxs `pseq` (fx : fxs))
--     where fx = f x; fxs = parMap f xs

-- toSet :: (Ord a, Foldable f) => f a -> S.Set a
-- toSet = foldl' (flip S.insert) mempty
-- {-# INLINE toSet #-}

-- toIntSet :: (Foldable f) => f Int -> IS.IntSet
-- toIntSet = foldl' (flip IS.insert) mempty
-- {-# INLINE toIntSet #-}
