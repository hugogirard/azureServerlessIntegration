namespace LegacyApiOrder.Repository;

public interface IOrderRepository
{
    Task<List<Order>> AllAsync();
    Task<Order> CreateAsync(Order order);
    Task<Order?> GetAsync(string id);
}
