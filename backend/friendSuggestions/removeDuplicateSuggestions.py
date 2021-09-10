class RemoveDuplicateSuggestions:
    # Removes duplicates from array.
    # Time Complexity: O(n)
    def removeDuplicates(self, arr):
        arr2 = []
        for element in arr:
            if not arr2.__contains__(element):
                arr2.append(element)
        return arr2
