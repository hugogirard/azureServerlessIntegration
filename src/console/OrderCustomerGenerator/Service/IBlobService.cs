namespace OrderCustomerGenerator;

public interface IBlobService
{
    Task<BlobStatus> GetCopyStatus(string filename);
    Task<BlobStatus> UploadAsync(string filePath, string filename);
}
