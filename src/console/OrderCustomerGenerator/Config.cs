namespace OrderCustomerGenerator;

    
public class Config 
{
    public string StorageConnectionString { get; set; }

    public string LogicAppCustomerUrl { get; set; }

    public string LogicAppOrderUrl { get; set; }

    public string ApimSubscriptionKey { get; set; }

    public string OutputDirectoryFileUpload => @"C:\tmp\largeFileUpload";

    public string StorageContainer { get; set; }
}