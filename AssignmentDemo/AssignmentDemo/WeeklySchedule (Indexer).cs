using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class WeeklySchedule
    {
        private Dictionary<string, string> schedule = new();
        public string this[string day]
        {
            get => schedule.ContainsKey(day) ? schedule[day] : "No Schedule";
            set => schedule[day] = value;
        }
    }
}
