using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LinqAssignment
{
    public class Book
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Genre { get; set; }
        public double Price { get; set; }
        public int PublishedYear { get; set; }
        public bool IsAvailable { get; set; }
        public int AuthorId { get; set; }
    }
}
