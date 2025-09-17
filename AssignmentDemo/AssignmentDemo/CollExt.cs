using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    static class CollExt
    {
        public static IEnumerable<IEnumerable<T>> Batch<T>(this IEnumerable<T> src, int size)
        {
            var list = new List<T>();
            foreach (var i in src)
            {
                list.Add(i);
                if (list.Count == size) { yield return list; list = new(); }
            }
            if (list.Any()) yield return list;
        }
    }
    delegate double Operation(double a, double b);
}
