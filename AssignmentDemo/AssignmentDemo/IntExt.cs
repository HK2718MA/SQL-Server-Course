using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    static class IntExt
    {
        public static bool IsEven(this int n) => n % 2 == 0;
        public static bool IsOdd(this int n) => n % 2 != 0;
        public static int Factorial(this int n) => n <= 1 ? 1 : n * Factorial(n - 1);
    }

}
