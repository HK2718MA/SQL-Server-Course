using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Pipeline
    {
        public Func<int, int> Process;
        public int Run(int x) => Process(x);
    }
}
