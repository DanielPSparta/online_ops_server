import pytest
import calculator as cal


def test_add():
    calculatorObject = cal.CalculatorClass(1, 2)
    assert calculatorObject.add() == 3, "Problem in additon function"

def test_subtract():
    calculatorObject = cal.CalculatorClass(1, 2)
    assert calculatorObject.subtract() == -1, "Problem in subtract function"
    calculatorObject = cal.CalculatorClass(3.8, 2.3)
    assert calculatorObject.subtract() == 1.5, "Problem in subtract function"

def test_multiply():
    calculatorObject = cal.CalculatorClass(1, 2)
    assert calculatorObject.multiply() == 2, "Problem in multiply function"

def test_divide():
    calculatorObject = cal.CalculatorClass(1, 2)
    assert calculatorObject.divide() == 0.5, "Problem in divide function"
    calculatorObject = cal.CalculatorClass(1, 0)
    assert calculatorObject.divide() == None, "Problem in divide function"
