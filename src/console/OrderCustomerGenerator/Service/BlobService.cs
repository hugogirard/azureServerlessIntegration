using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace OrderCustomerGenerator;

public class BlobService : IBlobService
{
    private readonly BlobContainerClient _containerClient;

    public BlobService(Config config)
    {
        var blobServiceClient = new BlobServiceClient(config.StorageConnectionString);
        _containerClient = blobServiceClient.GetBlobContainerClient(config.StorageContainer);
    }

    public async Task<BlobStatus> UploadAsync(string filePath, string filename)
    {
        var blobStatus = new BlobStatus();

        try
        {
            var destinationBlob = _containerClient.GetBlobClient(filename);

            var operation = await destinationBlob.UploadAsync(filePath);
            BlobProperties destProperties = await destinationBlob.GetPropertiesAsync();

            blobStatus.CopyStatus = destProperties.CopyStatus;
            blobStatus.CopyProgress = destProperties.CopyProgress;
            blobStatus.CopyCompletedOn = destProperties.CopyCompletedOn;
            blobStatus.ContentLength = destProperties.ContentLength;
            blobStatus.Filename = filename;
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return blobStatus;
    }

    public async Task<BlobStatus> GetCopyStatus(string filename)
    {
        var destinationBlob = _containerClient.GetBlobClient(filename);

        BlobProperties destProperties = await destinationBlob.GetPropertiesAsync();
        var blobStatus = new BlobStatus();

        blobStatus.CopyStatus = destProperties.CopyStatus;
        blobStatus.CopyProgress = destProperties.CopyProgress;
        blobStatus.CopyCompletedOn = destProperties.CopyCompletedOn;
        blobStatus.ContentLength = destProperties.ContentLength;
        blobStatus.Filename = filename;

        return blobStatus;
    }
}
