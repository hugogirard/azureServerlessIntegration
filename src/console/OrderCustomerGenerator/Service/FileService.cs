namespace OrderCustomerGenerator;

public class FileService : IFileService
{
    private readonly Config _config;

    // File size for large file is 1GB
    const long FILESIZE = 1024L;

    public FileService(Config config)
    {
        _config = config;
    }

    public string CreateLargeFile()
    {
        string filename = Guid.NewGuid().ToString();
        string filePath = $"{_config.OutputDirectoryFileUpload}\\{filename}.txt";
        using (var fs = new FileStream(filePath, FileMode.CreateNew))
        {
            fs.Seek(FILESIZE * 1024 * 1024, SeekOrigin.Begin);
            fs.WriteByte(0);
            fs.Close();
        }

        return filePath;
    }
}