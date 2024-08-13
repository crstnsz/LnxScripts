    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
       base.OnConfiguring(optionsBuilder);

       if (Logger.IsDebugEnabled)
       {
           optionsBuilder.EnableDetailedErrors();
           optionsBuilder.EnableSensitiveDataLogging();

           optionsBuilder.LogTo(log => Logger?.Debug(log));
       }
    }