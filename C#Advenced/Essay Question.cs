using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class EssayQuestion : Question
    {
        public override bool CheckAnswer(string answer)
        {
           
            return true;
        }
    }
}
