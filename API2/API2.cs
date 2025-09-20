using EmployeeApi.Data;
using EmployeesApi.Repositories;
using EmployeesApi.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// قراءة ConnectionString من appsettings.json
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// تسجيل DbContext (Scoped افتراضياً)
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// تسجيل الطبقات (Repository + Service) كـ Scoped
builder.Services.AddScoped<IEmployeeRepository, EmployeeRepository>();
builder.Services.AddScoped<IEmployeeService, EmployeeService>();

// باقي التسجيلات
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
