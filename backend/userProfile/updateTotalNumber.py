from django.http.request import QueryDict


class UpdateTotalPosts:
    def __init__(self, totalNumber):
        self.totalNumber = totalNumber

    def addToTotal(self):
        self.totalNumber += 1

    def createNewInfo(self):
        newDict = {"totalPosts": self.totalNumber}
        queryDict = QueryDict('', mutable=True)
        queryDict.update(newDict)
        return queryDict
