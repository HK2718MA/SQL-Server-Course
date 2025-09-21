
using Microsoft.AspNetCore.Http;
using System;
using System.Threading.Tasks;

namespace EmployeesApi.Middleware
{
    public class TimeResponseMiddleware : IMiddleware
    {
        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            var startTime = DateTime.UtcNow;
            Console.WriteLine($"[Start Req] Path: {context.Request.Path} Method: {context.Request.Method} Time: {startTime:O}");

            await next(context);

            var endTime = DateTime.UtcNow;
            var duration = endTime - startTime;

            Console.WriteLine($"[End Req]   Path: {context.Request.Path} Status: {context.Response?.StatusCode} Time: {endTime:O}");
            Console.WriteLine($"[Req Duration] {duration.TotalMilliseconds} ms");
        }
    }
}

