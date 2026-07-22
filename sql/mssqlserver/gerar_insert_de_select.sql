DECLARE @TableName NVARCHAR(256) = 'TABELA' -- Coloque o nome da tabela aqui
DECLARE @ColumnList NVARCHAR(MAX) = ''
DECLARE @ValuesList NVARCHAR(MAX) = ''
DECLARE @SQL NVARCHAR(MAX)

-- 1. Monta a lista de colunas para o INSERT e para o SELECT
SELECT 
    @ColumnList += '[' + name + '],',
    @ValuesList += 
        CASE 
            WHEN system_type_id IN (35, 99, 167, 175, 231, 239) THEN 'ISNULL('''''''' + REPLACE([' + name + '], '''''''', '''''''''''') + '''''''', ''NULL'')' -- Strings
            WHEN system_type_id IN (40, 42, 43, 58, 61) THEN 'ISNULL('''''''' + CONVERT(VARCHAR, [' + name + '], 121) + '''''''', ''NULL'')' -- Datas
            ELSE 'ISNULL(CAST([' + name + '] AS VARCHAR), ''NULL'')' -- Números
        END + ' + '','' + '
FROM sys.columns 
WHERE object_id = OBJECT_ID(@TableName)
AND is_identity = 0 -- Ignora colunas auto-incremento

-- Ajusta as strings removendo a última vírgula
SET @ColumnList = LEFT(@ColumnList, LEN(@ColumnList) - 1)
SET @ValuesList = LEFT(@ValuesList, LEN(@ValuesList) - 7)

-- 2. Monta o SQL final que vai gerar os textos de INSERT
SET @SQL = 'SELECT ''INSERT INTO [' + @TableName + '] (' + @ColumnList + ') VALUES ('' + ' + @ValuesList + ' + '');'' FROM [' + @TableName + ']' 

-- 3. Executa e gera o resultado
EXEC sp_executesql @SQL