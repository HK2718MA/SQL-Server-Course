using Microsoft.AspNetCore.Mvc;
using EmployeeAPI.Models;

namespace EmployeeAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeesController : ControllerBase
    {
        private static List<Employee> employees = new List<Employee>();

        [HttpGet]
        public IActionResult GetAll()
        {
            return Ok(employees);
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var emp = employees.FirstOrDefault(e => e.Id == id);
            if (emp == null) return NotFound();
            return Ok(emp);
        }

        [HttpPost]
        public IActionResult Create(Employee employee)
        {
            employees.Add(employee);
            return Ok(employee);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, Employee updated)
        {
            var emp = employees.FirstOrDefault(e => e.Id == id);
            if (emp == null) return NotFound();

            emp.Name = updated.Name;
            emp.Age = updated.Age;
            emp.Salary = updated.Salary;
            return Ok(emp);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var emp = employees.FirstOrDefault(e => e.Id == id);
            if (emp == null) return NotFound();

            employees.Remove(emp);
            return Ok();
        }
    }
}

