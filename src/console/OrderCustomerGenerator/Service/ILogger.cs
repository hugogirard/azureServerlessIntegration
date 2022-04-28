namespace OrderCustomerGenerator;

public interface ILogger
{
    void Debug(string message);

    void Information(string message);

    void WriteSpace(int number = 1);

    void Error(string message);
}
