from django.http.request import QueryDict


class UpdatePost:
    # Creates a new UpdatePost object.
    def __init__(self, username, postNumber, postCaption, numberOfLikes, numberOfComments):
        self.username = username
        self.postNumber = postNumber
        self.postCaption = postCaption
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments

    # Increases the postNumber by one.
    def updatePostNumber(self, numberOfPosts):
        self.postNumber = numberOfPosts + 1

    # Updates the caption.
    def updateCaption(self, newCaption: str):
        self.postCaption = newCaption

    # Increments or decrements the number of likes based on the operation.
    def updateLikes(self, operation: str):
        if operation == "add":
            self.numberOfLikes += 1
        elif operation == "delete":
            self.numberOfLikes -= 1

    # Increments or decrements the number of comments based on the operation.
    def updateComments(self, operation: str):
        if operation == "add":
            self.numberOfComments += 1
        elif operation == "delete":
            self.numberOfComments -= 1

    # Creates a new query dictionary with updated info.
    def createNewInfo(self):
        newDict = {"username": self.username, "postNumber": self.postNumber, "postCaption": self.postCaption,
                   "numberOfLikes": self.numberOfLikes, "numberOfComments": self.numberOfComments}
        queryDict = QueryDict('', mutable=True)
        queryDict.update(newDict)
        return queryDict

    def clearAllInfo(self):
        self.username = ""
        self.postNumber = 0
        self.postCaption = ""
        self.numberOfLikes = 0
        self.numberOfComments = 0
