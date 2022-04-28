using Microsoft.Extensions.DependencyInjection;
using OrderCustomerGenerator;

var bootstrapper = new Bootstrapper();

ServiceProvider provider = bootstrapper.Start();

var logger = provider.GetService<ILogger>();

while (true) 
{
    logger.Information("What you want to do ?");
    logger.Information("[1] - Create a customer ?");
    logger.Information("[2] - Create an order for a customer ?");
    logger.Information("[3] - Upload large file to Azure Storage ?");
    logger.WriteSpace();

    string key = "3";

    switch (key)
    {            
        case "3":
           await UploadLargeFileAsync();
           break;
        default:
            break;
    }
}

async Task UploadLargeFileAsync() 
{
    var fileService = provider.GetService<IFileService>();
    string filePath = fileService.CreateLargeFile();

    string filename = Path.GetFileName(filePath);

    logger.Debug($"File created with name: {filename}");

    var blobService = provider.GetService<IBlobService>();
    var blobStatus = await blobService.UploadAsync(filePath,filename);

    logger.Debug("Upload in progress");
}


