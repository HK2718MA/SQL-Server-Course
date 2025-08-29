using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class ExamResult
    {
        public Exam Exam { get; set; }
        public Student Student { get; set; }
        public int Score { get; set; }

        public ExamResult(Exam exam, Student student, int score)
        {
            Exam = exam;
            Student = student;
            Score = score;
        }
    }
}