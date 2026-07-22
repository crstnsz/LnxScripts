#:package MongoDB.Driver@2.14.1
#:package Microsoft.Extensions.Configuration@6.0.0
#:package Microsoft.Extensions.Configuration.Ini@6.0.0


using MongoDB.Bson;
using MongoDB.Driver;
using Microsoft.Extensions.Configuration;

await MainAsync();

static async Task MainAsync()
{
    try
    {
        var configBuilder = new ConfigurationBuilder()
            .SetBasePath(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile))
            .AddIniFile("config.ini")
            .Build();

        var user = configBuilder["MONGO_USER"];
        var password = configBuilder["MONGO_PASSWORD"];
        var host = configBuilder["MONGO_HOST"];

        Console.WriteLine($"user={user}");
        Console.WriteLine($"password={(password != null ? "***" : "NULL")}");
        Console.WriteLine($"host={host}");

        Console.WriteLine("🔍 Testando acesso ao MongoDB...");
        var client = new MongoClient($"mongodb://{user}:{password}@{host}?authSource=admin");
        var database = client.GetDatabase("crstnsz");
        var comando = new BsonDocument("ping", 1);
        var resultado = await database.RunCommandAsync<BsonDocument>(comando);
        
        Console.WriteLine(resultado["ok"].AsInt32 == 1 
            ? "✅ MongoDB disponível!" 
            : "❌ Ping falhou");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ Erro: {ex.Message}");
    }
}


