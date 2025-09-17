using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Pair<T, U>
    {
        public T First { get; }
        public U Second { get; }
        public Pair(T f, U s) { First = f; Second = s; }
    }

}
