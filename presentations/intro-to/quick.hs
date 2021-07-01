quicksort :: Ord a => [a] -> [a] -- take any type that can be ordered
quicksort []     = []
quicksort (p:xs) = quicksort lesser ++ [p] ++ quicksort greater
    where
        lesser  = filter (< p) xs
        greater = filter (>= p) xs
