using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Counter
    {
        private int count;
        private object lockObj = new();
        public void Inc() { lock (lockObj) count++; }
        public int Get() => count;
    }
}
