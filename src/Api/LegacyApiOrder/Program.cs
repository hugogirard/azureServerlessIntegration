using System.Text.Json;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton<IOrderRepository,OrderRepository>();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

// Endpoint to test the API
app.MapGet("/", () => "Hello World!").WithName("Hello World");

app.MapGet("/all",async (IOrderRepository repository) => await repository.AllAsync())
   .WithName("Get All Orders");

app.MapGet("{id}",async (string id, IOrderRepository repository) => 
{
    return await repository.GetAsync(id) is Order order ? Results.Ok(order)
                                                        : Results.NotFound();
})
.WithName("Get Order By ID");

app.MapPost("/",async ([FromBody]Order order, IOrderRepository repository) => 
{
    await repository.CreateAsync(order);

    return Results.Created($"{order.Id}",order);
})
.WithName("Create Order");

app.MapPost("/batch",async ([FromBody]IEnumerable<Order> orders, IOrderRepository repository) => 
{
    foreach (var order in orders)
    {
        await repository.CreateAsync(order);
    }

    return Results.Ok();
})
.WithName("Create Orders");

app.MapDelete("/", async (IOrderRepository repository) => 
{
    await repository.DeleteAsync();

    return Results.Ok();
});


app.Run();

