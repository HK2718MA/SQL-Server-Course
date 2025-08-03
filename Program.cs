using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello!");
        Console.WriteLine("Input the first number:");
        double num1 = Convert.ToDouble(Console.ReadLine());
        Console.WriteLine("Input the second number:");
        double num2 = Convert.ToDouble(Console.ReadLine());
        Console.WriteLine("What do you want to do with those numbers?");
        Console.WriteLine("[A]dd");
        Console.WriteLine("[S]ubtract");
        Console.WriteLine("[M]ultiply");

        string choice = Console.ReadLine().ToLower();
        switch (choice)
        {
            case "a":
                Console.WriteLine($"{num1} + {num2} = {num1 + num2}");
                break;

            case "s":
                Console.WriteLine($"{num1} - {num2} = {num1 - num2}");
                break;

            case "m":
                Console.WriteLine($"{num1} * {num2} = {num1 * num2}");
                break;

            default:
                Console.WriteLine("Invalid option");
                break;
        }
        Console.WriteLine("Press any key to close");
        Console.ReadKey();
    }
}