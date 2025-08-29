using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class TrueFalseQuestion : Question
    {
        public bool CorrectAnswer { get; set; }

        public override bool CheckAnswer(string answer)
        {
            if (bool.TryParse(answer, out bool userAnswer))
            {
                return userAnswer == CorrectAnswer;
            }
            return false;
        }
    }
}
