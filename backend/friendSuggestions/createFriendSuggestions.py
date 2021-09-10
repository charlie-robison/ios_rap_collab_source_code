# Creates a Node object with data and an array of children.
class Node:
    def __init__(self, data):
        self.data = data
        self.children = []

# Class holds an array whihc contains a list of nodes.
# Also contains a function which does BFS Traversal to find the level order of a tree.


class Friends:
    # Array contains list of nodes.
    listOfFriendSuggestions = []
    # Adds all nodes in the tree from a certian level to an array.
    # Time Complexity: O(n)

    def levelOrder(root: Node, level):
        # BASE CASE
        if root is None:
            return
        # BASE CASE: Level is 1.
        if level == 1:
            # Adds node data to list.
            Friends.listOfFriendSuggestions.append(root.data)
        # RERCURSIVE STEP: Level is greater than 1.
        elif level > 1:
            # Loops through each child in node's children.
            for child in root.children:
                # Recursively calls levelOrder with the child as the root, level is decremented.
                Friends.levelOrder(child, level - 1)
