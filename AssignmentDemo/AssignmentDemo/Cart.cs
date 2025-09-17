using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Cart
    {
        public List<string> Items = new();
        public Dictionary<string, int> Qty = new();
        public HashSet<string> Discounts = new();
    }
}
