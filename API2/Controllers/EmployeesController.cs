using EmployeeApi.Models;
using EmployeesApi.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EmployeesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeesController : ControllerBase
    {
        private readonly IEmployeeService _service;

        public EmployeesController(IEmployeeService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var list = await _service.GetAllEmployeesAsync();
            return Ok(list);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var emp = await _service.GetEmployeeByIdAsync(id);
            if (emp == null) return NotFound();
            return Ok(emp);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Employee employee)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var created = await _service.CreateEmployeeAsync(employee);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] Employee employee)
        {
            if (id != employee.Id) return BadRequest("ID in URL and body must match.");

            var existing = await _service.GetEmployeeByIdAsync(id);
            if (existing == null) return NotFound();

            var updated = await _service.UpdateEmployeeAsync(employee);
            return Ok(updated);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var existing = await _service.GetEmployeeByIdAsync(id);
            if (existing == null) return NotFound();

            var deleted = await _service.DeleteEmployeeAsync(id);
            if (!deleted) return StatusCode(500, "Could not delete employee.");
            return NoContent();
        }
    }
}

