using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Student
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;   
        public string Email { get; set; } = string.Empty;  

        public List<Course> EnrolledCourses { get; set; } = new List<Course>();

        public Student(int id, string name, string email)
        {
            Id = id;
            Name = name;
            Email = email;
        }
    }
}
