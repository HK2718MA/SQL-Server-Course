using System;
using ExamSys.Data;
using Microsoft.EntityFrameworkCore;

class Program
{
    static void Main(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<ExaminationDbContext>();
        optionsBuilder.UseSqlServer("Server=.;Database=ExamSysDb;Trusted_Connection=True;TrustServerCertificate=True;");

        using (var context = new ExaminationDbContext(optionsBuilder.Options))
        {
            Console.WriteLine("DB Provider: " + context.Database.ProviderName);
        }

        Console.WriteLine("Ready ✅. اعملي دلوقتي: dotnet ef migrations add InitialCreate  وبعدها dotnet ef database update");
    }
}
