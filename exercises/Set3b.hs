-- Exercise set 3b
--
-- This is a special exercise set. The exercises are about
-- implementing list functions using recursion and pattern matching,
-- without using any standard library functions. For this reason,
-- you'll be working in a limited environment where almost none of the
-- standard library is available.
--
-- At least the following standard library functions are missing:
--  * (++)
--  * head
--  * tail
--  * map
--  * filter
--  * concat
--  * (!!)
--
-- The (:) operator is available, as is list literal syntax [a,b,c].
--
-- Feel free to use if-then-else, guards, and ordering functions (< and > etc.).
--
-- The tests will check that you haven't added imports :)

{-# LANGUAGE NoImplicitPrelude #-}

module Set3b where

import Mooc.LimitedPrelude
import Mooc.Todo

------------------------------------------------------------------------------
-- Ex 1: given numbers start, count and end, build a list that starts
-- with count copies of start and ends with end.
--
-- Use recursion and the : operator to build the list.
--
-- Examples:
--   buildList 1 5 2 ==> [1,1,1,1,1,2]
--   buildList 7 0 3 ==> [3]

buildList :: Int -> Int -> Int -> [Int]
buildList _ 0 end = [end]
buildList start count end = start:buildList start (count-1) end

------------------------------------------------------------------------------
-- Ex 2: given i, build the list of sums [1, 1+2, 1+2+3, .., 1+2+..+i]
--
-- Use recursion and the : operator to build the list.
--
-- Ps. you'll probably need a recursive helper function

sums :: Int -> [Int]
sums i = 1:(sums' i 1 2)

sums' :: Int -> Int -> Int -> [Int]
sums' i num plus = if plus > i 
                   then [] 
                   else (num+plus):sums' i (num+plus) (plus+1)

------------------------------------------------------------------------------
-- Ex 3: define a function mylast that returns the last value of the
-- given list. For an empty list, a provided default value is
-- returned.
--
-- Use only pattern matching and recursion (and the list constructors : and [])
--
-- Examples:
--   mylast 0 [] ==> 0
--   mylast 0 [1,2,3] ==> 3

mylast :: a -> [a] -> a
mylast def [] = def
mylast def (first:rest) = mylast first rest

------------------------------------------------------------------------------
-- Ex 4: safe list indexing. Define a function indexDefault so that
--   indexDefault xs i def
-- gets the element at index i in the list xs. If i is not a valid
-- index, def is returned.
--
-- Use only pattern matching and recursion (and the list constructors : and [])
--
-- Examples:
--   indexDefault [True] 1 False         ==>  False
--   indexDefault [10,20,30] 0 7         ==>  10
--   indexDefault [10,20,30] 2 7         ==>  30
--   indexDefault [10,20,30] 3 7         ==>  7
--   indexDefault ["a","b","c"] (-1) "d" ==> "d"

indexDefault :: [a] -> Int -> a -> a
indexDefault xs i def = indexDefault' xs i def 0

indexDefault' :: [a] -> Int -> a -> Int -> a
indexDefault' [] _ def _ = def
indexDefault' (s:xs) i def current = 
    if i == current
    then s 
    else indexDefault' xs i def (current+1)

------------------------------------------------------------------------------
-- Ex 5: define a function that checks if the given list is in
-- increasing order.
--
-- Use pattern matching and recursion to iterate through the list.

sorted :: [Int] -> Bool
sorted [] = True
sorted (s:xs) = sorted' xs s

sorted' :: [Int] -> Int -> Bool
sorted' [] _ = True
sorted' (s:xs) prev = if prev > s then False else sorted' xs s

------------------------------------------------------------------------------
-- Ex 6: compute the partial sums of the given list like this:
--
--   sumsOf [a,b,c]  ==>  [a,a+b,a+b+c]
--   sumsOf [a,b]    ==>  [a,a+b]
--   sumsOf []       ==>  []
--
-- Use pattern matching and recursion (and the list constructors : and [])

sumsOf :: [Int] -> [Int]
sumsOf [] = []
sumsOf (s:xs) = sumsOf' xs s

sumsOf' :: [Int] -> Int -> [Int]
sumsOf' [] prev = [prev]
sumsOf' (s:xs) prev = prev:sumsOf' xs (prev+s)

------------------------------------------------------------------------------
-- Ex 7: implement the function merge that merges two sorted lists of
-- Ints into a sorted list
--
-- Use only pattern matching and recursion (and the list constructors : and [])
--
-- Examples:
--   merge [1,3,5] [2,4,6] ==> [1,2,3,4,5,6]
--   merge [1,1,6] [1,2]   ==> [1,1,1,2,6]

merge :: [Int] -> [Int] -> [Int]
merge [] [] = []
merge (x:xs) [] = x:(merge xs [])
merge [] (y:ys) = y:(merge [] ys)
merge (x:xs) (y:ys) = if x <= y
                           then x:(merge xs (y:ys))
                           else y:(merge (x:xs) ys)

------------------------------------------------------------------------------
-- Ex 8: define the function mymaximum that takes a list and a
-- function bigger :: a -> a -> Bool and returns the
-- biggest of the list, according to the comparing function.
--
-- An initial biggest value is provided to give you something to
-- return for empty lists.
--
-- Examples:
--   mymaximum (>) 3 [] ==> 3
--   mymaximum (>) 0 [1,3,2] ==> 3
--   mymaximum (>) 4 [1,3,2] ==> 4    -- initial value was biggest
--   mymaximum (<) 4 [1,3,2] ==> 1    -- note changed biggerThan
--   mymaximum (\xs ys -> length xs > length ys) [] [[1,2],[3]]
--     ==> [1,2]

mymaximum :: (a -> a -> Bool) -> a -> [a] -> a
mymaximum _ initial [] = initial
mymaximum bigger initial (x:xs) = if bigger initial x
                                  then mymaximum bigger initial xs
                                  else mymaximum bigger x xs

------------------------------------------------------------------------------
-- Ex 9: define a version of map that takes a two-argument function
-- and two lists. Example:
--
--   map2 f [x,y,z,w] [a,b,c]  ==> [f x a, f y b, f z c]
--
-- If the lists have differing lengths, ignore the trailing elements
-- of the longer list.
--
-- Use recursion and pattern matching. Do not use any library functions.

map2 :: (a -> b -> c) -> [a] -> [b] -> [c]
map2 _ [] _ = []
map2 _ _ [] = []
map2 f (a:as) (b:bs) = (f a b):(map2 f as bs)

------------------------------------------------------------------------------
-- Ex 10: implement the function maybeMap, which works a bit like a
-- combined map & filter.
---
-- maybeMap is given a list ([a]) and a function of type a -> Maybe b.
-- This function is called for all values in the list. If the function
-- returns Just x, x will be in the result list. If the function
-- returns Nothing, no value gets added to the result list.
--
-- Examples:
--
-- let f x = if x>0 then Just (2*x) else Nothing
-- in maybeMap f [0,1,-1,4,-2,2]
--   ==> [2,8,4]
--
-- maybeMap Just [1,2,3]
--   ==> [1,2,3]
--
-- maybeMap (\x -> Nothing) [1,2,3]
--   ==> []

maybeMap :: (a -> Maybe b) -> [a] -> [b]
maybeMap _ [] = []
maybeMap f (x:xs) = maybeMap' f xs (f x)

maybeMap' :: (a -> Maybe b) -> [a] -> Maybe b -> [b]
maybeMap' f (x:xs) Nothing = maybeMap' f xs (f x)
maybeMap' f (x:xs) (Just v) = v:(maybeMap' f xs (f x))
maybeMap' _ [] (Just v) = [v]
maybeMap' _ [] Nothing = []
