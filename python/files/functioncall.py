"""
class Input:
    def __init__(self):
        self.num1 = 0
        self.num2 = 0
        self.operator = ""
 
    def get_input(self):
        self.num1 = float(input("Enter the first number: "))
        self.num2 = float(input("Enter the second number: "))
        self.operator = input("Enter the operator (+, -, *, /): ")
 
class Calculator:
    def __init__(self, input_data):
        self.input_data = input_data
        self.result = 0
 
    def calculate(self):
        if self.input_data.operator == "+":
            self.result = self.input_data.num1 + self.input_data.num2
        elif self.input_data.operator == "-":
            self.result = self.input_data.num1 - self.input_data.num2
        elif self.input_data.operator == "*":
            self.result = self.input_data.num1 * self.input_data.num2
        elif self.input_data.operator == "/":
            if self.input_data.num2 == 0:
                print("Error: Division by zero")
                self.result = None
            else:
                self.result = self.input_data.num1 / self.input_data.num2
 
class Result:
    def __init__(self, calculator):
        self.calculator = calculator
 
    def display_result(self):
        if self.calculator.result is not None:
            print(f"Result: {self.calculator.result}")
 
if __name__ == "__main__":
    input_data = Input()
    input_data.get_input()
 
    calculator = Calculator(input_data)
    calculator.calculate()
 
    result_display = Result(calculator)
    result_display.display_result()
    """

class Input(object):
    def __init__(self) -> None:
        self.value = None
    def value(self, x):
        y = 2 * x
        # self.value = y
        return y



class perimeter(x,y):
 
    def perimeter(p):
    p = 2*(x+y)
    return y
    

class area(x,y,p):

    def area(a):
    p(x/2 - x*X)


