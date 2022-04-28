
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace OrderCustomerGenerator;

public class Bootstrapper 
{    
    public ServiceProvider Start()
    {
        Config config;
        ServiceProvider serviceProvider = null;

        try
        {
            IConfiguration configuration = new ConfigurationBuilder()
                                               .AddJsonFile("appconfig.json")                                        
                                               .Build();

            config = configuration.GetRequiredSection("Settings").Get<Config>();  

            serviceProvider = new ServiceCollection()  
                                      .AddSingleton<Config>(config)
                                      .AddSingleton<IBlobService,BlobService>()
                                      .AddSingleton<IFileService,FileService>()
                                      .AddSingleton<ILogger, Logger>()
                                      .BuildServiceProvider();            
        }
        catch
        {
            throw new Exception("Cannot load the appconfig.json settings");            
        }

        try
        {
            if (!Directory.Exists(config.OutputDirectoryFileUpload))
            {
                Directory.CreateDirectory(config.OutputDirectoryFileUpload);
            }
        }
        catch
        {
            throw new Exception("Cannot create output file directory");            
        }


        return serviceProvider;
    }
}