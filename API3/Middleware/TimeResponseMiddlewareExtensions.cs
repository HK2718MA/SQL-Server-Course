// Middleware/TimeResponseMiddlewareExtensions.cs
using Microsoft.AspNetCore.Builder;

namespace EmployeesApi.Middleware
{
    public static class TimeResponseMiddlewareExtensions
    {
        public static IApplicationBuilder UseTimeResponse(this IApplicationBuilder app)
        {
            return app.UseMiddleware<TimeResponseMiddleware>();
        }
    }
}
