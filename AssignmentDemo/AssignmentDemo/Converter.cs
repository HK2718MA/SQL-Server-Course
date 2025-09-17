using System;
using System.Collections.Generic;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AssignmentDemo
{
    public static class ConverterUtil
    {
  
        public static List<TTarget> ConvertList<TSource, TTarget>(
            List<TSource> src,
            Func<TSource, TTarget> conv)
        {
            return src.Select(conv).ToList();
        }
    }
}
