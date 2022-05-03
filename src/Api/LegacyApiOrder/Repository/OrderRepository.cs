namespace LegacyApiOrder.Repository;

public class OrderRepository : IOrderRepository
{
    private List<Order> _orders;

    public OrderRepository()
    {
        _orders = new List<Order>();
    }

    public Task<List<Order>> AllAsync()
    {
        return Task.FromResult(_orders.ToList());
    }

    public Task<Order> CreateAsync(Order order)
    {
        _orders.Add(order);

        return Task.FromResult(order);
    }

    public Task DeleteAsync()
    {
        _orders.Clear();

        return Task.CompletedTask;
    }

    public Task<Order?> GetAsync(string id)
    {
        return Task.FromResult(_orders.SingleOrDefault(o => o.Id == id));
    }
}