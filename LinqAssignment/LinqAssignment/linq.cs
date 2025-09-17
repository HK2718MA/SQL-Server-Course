using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace LinqAssignment
{
    class Program
    {
        static void Main(string[] args)
        {

            var authors = new List<Author>
            {
                new Author { Id = 1, Name = "Robert C. Martin" },
                new Author { Id = 2, Name = "Martin Fowler" },
                new Author { Id = 3, Name = "Jon Skeet" }
            };

            var books = new List<Book>
            {
                new Book { Id = 1, Title = "Clean Code", Genre = "Programming", Price = 45, PublishedYear = 2008, IsAvailable = true, AuthorId = 1 },
                new Book { Id = 2, Title = "Refactoring", Genre = "Programming", Price = 55, PublishedYear = 1999, IsAvailable = false, AuthorId = 2 },
                new Book { Id = 3, Title = "C# in Depth", Genre = "Programming", Price = 35, PublishedYear = 2019, IsAvailable = true, AuthorId = 3 },
                new Book { Id = 4, Title = "Algorithms", Genre = "Computer Science", Price = 25, PublishedYear = 2015, IsAvailable = true, AuthorId = 1 }
            };

            var members = new List<Member>
            {
                new Member { Id = 1, Name = "Alice" },
                new Member { Id = 2, Name = "Bob" }
            };

            var loans = new List<Loan>
            {
                new Loan { Id = 1, BookId = 1, MemberId = 1, LoanDate = DateTime.Now.AddDays(-10), DueDate = DateTime.Now.AddDays(-2), ReturnDate = null },
                new Loan { Id = 2, BookId = 2, MemberId = 2, LoanDate = DateTime.Now.AddDays(-20), DueDate = DateTime.Now.AddDays(-10), ReturnDate = DateTime.Now.AddDays(-5) },
                new Loan { Id = 3, BookId = 1, MemberId = 2, LoanDate = DateTime.Now.AddDays(-50), DueDate = DateTime.Now.AddDays(-40), ReturnDate = DateTime.Now.AddDays(-30) }
            };


            Console.WriteLine("Available Books:");
            foreach (var b in books.Where(b => b.IsAvailable))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\n All Book Titles:");
            foreach (var t in books.Select(b => b.Title))
                Console.WriteLine($"- {t}");


            Console.WriteLine("\n Programming Books:");
            foreach (var b in books.Where(b => b.Genre == "Programming"))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\nSorted Books:");
            foreach (var b in books.OrderBy(b => b.Title))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\nExpensive Books (>30):");
            foreach (var b in books.Where(b => b.Price > 30))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\nUnique Genres:");
            foreach (var g in books.Select(b => b.Genre).Distinct())
                Console.WriteLine($"- {g}");


            Console.WriteLine("\nBooks by Genre:");
            foreach (var g in books.GroupBy(b => b.Genre).Select(g => new { g.Key, Count = g.Count() }))
                Console.WriteLine($"{g.Key}: {g.Count}");


            Console.WriteLine("\nRecent Books (>2010):");
            foreach (var b in books.Where(b => b.PublishedYear > 2010))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\nFirst 5 Books:");
            foreach (var b in books.Take(5))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine($"\nAny book > 50? {books.Any(b => b.Price > 50)}");


            Console.WriteLine("\nBooks with Authors:");
            foreach (var x in books.Join(authors, b => b.AuthorId, a => a.Id,
                            (b, a) => new { b.Title, AuthorName = a.Name, b.Genre }))
                Console.WriteLine($"{x.Title} - {x.AuthorName} - {x.Genre}");


            Console.WriteLine("\nAverage Price by Genre:");
            foreach (var g in books.GroupBy(b => b.Genre)
                                   .Select(g => new { g.Key, Avg = g.Average(b => b.Price) }))
                Console.WriteLine($"{g.Key}: {g.Avg}");


            var mostExpensive = books.OrderByDescending(b => b.Price).FirstOrDefault();
            Console.WriteLine($"\nMost Expensive Book: {mostExpensive?.Title}");


            Console.WriteLine("\nBooks by Decade:");
            foreach (var g in books.GroupBy(b => (b.PublishedYear / 10) * 10))
            {
                Console.WriteLine($"{g.Key}s:");
                foreach (var b in g) Console.WriteLine($"  - {b.Title}");
            }
            Console.WriteLine("\nMembers with Active Loans:");
            foreach (var m in loans.Where(l => l.ReturnDate == null)
                                   .Join(members, l => l.MemberId, m => m.Id, (l, m) => m)
                                   .Distinct())
                Console.WriteLine($"- {m.Name}");


            Console.WriteLine("\nBooks Borrowed More Than Once:");
            foreach (var x in loans.GroupBy(l => l.BookId).Where(g => g.Count() > 1)
                                   .Join(books, g => g.Key, b => b.Id, (g, b) => new { b.Title, LoanCount = g.Count() }))
                Console.WriteLine($"{x.Title}: {x.LoanCount} times");


            Console.WriteLine("\nOverdue Books:");
            foreach (var b in loans.Where(l => l.DueDate < DateTime.Now && l.ReturnDate == null)
                                   .Join(books, l => l.BookId, b => b.Id, (l, b) => b))
                Console.WriteLine($"- {b.Title}");


            Console.WriteLine("\nAuthor Book Counts:");
            foreach (var x in books.GroupBy(b => b.AuthorId)
                                   .Select(g => new { Author = authors.First(a => a.Id == g.Key).Name, Count = g.Count() })
                                   .OrderByDescending(a => a.Count))
                Console.WriteLine($"{x.Author}: {x.Count}");


            Console.WriteLine("\nPrice Range Analysis:");
            foreach (var g in books.GroupBy(b =>
                                b.Price < 20 ? "Cheap" :
                                b.Price <= 40 ? "Medium" : "Expensive")
                                   .Select(g => new { g.Key, Count = g.Count() }))
                Console.WriteLine($"{g.Key}: {g.Count}");


            Console.WriteLine("\nMember Loan Statistics:");

            foreach (var m in members.Select(m => new
            {
                Member = m.Name,
                TotalLoans = loans.Count(l => l.MemberId == m.Id),
                ActiveLoans = loans.Count(l => l.MemberId == m.Id && l.ReturnDate == null),
                AverageDaysBorrowed = loans
        .Where(l => l.MemberId == m.Id && l.ReturnDate != null)
        .Select(l => (l.ReturnDate.Value - l.LoanDate).TotalDays)
        .DefaultIfEmpty(0)
        .Average()
            }))
            {
                Console.WriteLine($"{m.Member}: Total={m.TotalLoans}, Active={m.ActiveLoans}, AvgDays={m.AverageDaysBorrowed:F1}");
            }

        }
    }
}
    
