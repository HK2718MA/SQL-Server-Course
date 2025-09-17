using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    static class MathUtils
    {
        public static double Average(List<int?> nums)
         => nums.Where(n => n.HasValue).Average(n => n.Value);
    }
}
