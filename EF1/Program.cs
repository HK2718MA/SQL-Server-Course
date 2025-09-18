using System;
using System.Linq;
using CompanyEFCore.Models;

class Program
{
    static void Main()
    {
        using var context = new CompanyDbContext();

       
        var employees = context.Employees.ToList();

        foreach (var emp in employees)
        {
            Console.WriteLine($"{emp.EmpId} - {emp.Fname} - {emp.Email}");
        }
    }
}
