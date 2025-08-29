using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Instructor
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Specialization { get; set; }

        public Instructor(int id, string name, string specialization)
        {
            Id = id;
            Name = name;
            Specialization = specialization;
        }

        
        public Exam CreateExam(Course course, string title)
        {
            var exam = new Exam(title, course);
            course.AddExam(exam);
            return exam;
        }

        
        public Exam DuplicateExam(Exam original, Course course)
        {
            var copy = new Exam(original.Title + " (Copy)", course);
            foreach (var q in original.Questions)
            {
                copy.AddQuestion(q, q.Marks);
            }
            course.AddExam(copy);
            return copy;
        }
    }
}
