using System;
using System.Drawing;
using Console = Colorful.Console;

namespace OrderCustomerGenerator;

public class Logger : ILogger
{
    public void Debug(string message)
    {
        Console.WriteLine(message, Color.Green);
    }

    public void Information(string message)
    {
        Console.WriteLine(message, Color.Aquamarine);
    }

    public void WriteSpace(int number = 1)
    {
        Console.WriteLine(number);
    }

    public void Error(string message)
    {
        Console.WriteLine(message, Color.Red);
    }
}