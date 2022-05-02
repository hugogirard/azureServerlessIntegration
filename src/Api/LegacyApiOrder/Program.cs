using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton<IOrderRepository,OrderRepository>();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

// Endpoint to test the API
app.MapGet("/", () => "Hello World!").WithDisplayName("Hello World");

app.MapGet("/all",async (IOrderRepository repository) => await repository.AllAsync()).WithDisplayName("All");

app.MapGet("{id}",async (string id, IOrderRepository repository) => 
{
    return await repository.GetAsync(id) is Order order ? Results.Ok(order)
                                                        : Results.NotFound();
});

app.MapPost("/",async (Order order, IOrderRepository repository) => 
{
    await repository.CreateAsync(order);

    return Results.Created($"{order.Id}",order);
});

app.MapPost("/batch",async (IEnumerable<Order> orders, IOrderRepository repository) => 
{
    foreach (var order in orders)
    {
        await repository.CreateAsync(order);
    }

    return Results.Ok();
});


app.Run();

