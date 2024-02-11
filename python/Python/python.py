class Employee():
    def __init__(self,nm,age):
        self.nm = nm
        self.age = age
    def __call__(self,sal):
        self.sal = sal
e1 = Employee("tanmay", 23)
e2 = Employee(20000)
print(e1.nm)
print(e1.age)
print(e2.sal)
    