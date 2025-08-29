using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public abstract class Question
    {
        public string Text { get; set; } = string.Empty;
        public int Marks { get; set; }

        public abstract bool CheckAnswer(string answer);
    }
}
