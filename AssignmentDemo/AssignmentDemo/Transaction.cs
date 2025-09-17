using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Transaction
    {
        public void Run(Action act)
        {
            try { act(); }
            catch { Console.WriteLine("Rollback"); }
        }
    }
}
