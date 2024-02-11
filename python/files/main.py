class A(object):
    def __init__(self, string):
        self.a = string
        

class B(A):
    def __init__(self, string):
        A.__init__(self, string)
    def extract(self, chars):
        self.lst = []
        for i in self.a:
            if i in chars:
                self.lst.append(i)

class C(B):
    def __init__(self, string):
        B.__init__(self, string)
    def count(self, char):
        return self.lst.count(char)

c = C("abcdaefmcmedwmooei")
c.extract("medwmooei")
print(c.count("o"))