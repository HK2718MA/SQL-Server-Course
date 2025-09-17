using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    static class DateExt
    {
        public static int Age(this DateTime dob) => DateTime.Now.Year - dob.Year;
        public static DateTime StartOfWeek(this DateTime dt) => dt.AddDays(-(int)dt.DayOfWeek);
    }
}
