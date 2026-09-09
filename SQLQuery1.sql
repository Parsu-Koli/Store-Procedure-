CREATE DATABASE UserManagementDB;

CREATE TABLE tblUser
(
    UserId INT IDENTITY PRIMARY KEY,
    UserName NVARCHAR(100) UNIQUE NOT NULL,
    EmailId NVARCHAR(150) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    BirthDate DATE NULL,
    Address NVARCHAR(500),
    CreatedDate DATETIME NOT NULL
);

CREATE TABLE tblUserIP
(
    IPId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    AllowedIP NVARCHAR(50),
    FOREIGN KEY (UserId) REFERENCES tblUser(UserId) ON DELETE CASCADE
);


CREATE PROCEDURE sp_RegisterUser
(
    @UserName NVARCHAR(100),
    @EmailId NVARCHAR(150),
    @PasswordHash NVARCHAR(255),
    @BirthDate DATE,
    @Address NVARCHAR(500),
    @AllowedIPs NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @UserId INT;

    INSERT INTO tblUser
    VALUES (@UserName,@EmailId,@PasswordHash,@BirthDate,@Address,GETDATE());

    SET @UserId = SCOPE_IDENTITY();

    INSERT INTO tblUserIP(UserId, AllowedIP)
    SELECT @UserId, value FROM STRING_SPLIT(@AllowedIPs, ',');
END;

CREATE PROCEDURE sp_GetUsers
AS
BEGIN
    SELECT 
        u.UserId,
        u.UserName,
        u.EmailId,
        u.BirthDate,
        u.Address,
        STRING_AGG(ip.AllowedIP, ', ') AS AllowedIPs
    FROM tblUser u
    LEFT JOIN tblUserIP ip ON u.UserId = ip.UserId
    GROUP BY u.UserId, u.UserName, u.EmailId, u.BirthDate, u.Address
END

CREATE PROCEDURE sp_UpdateUser
(
    @UserId INT,
    @BirthDate DATE,
    @Address NVARCHAR(500)
)
AS
BEGIN
    UPDATE tblUser
    SET BirthDate = @BirthDate,
        Address = @Address
    WHERE UserId = @UserId
END

CREATE PROCEDURE sp_DeleteUser
(
    @UserId INT
)
AS
BEGIN
    DELETE FROM tblUser WHERE UserId = @UserId
END


CREATE PROCEDURE sp_GetUserById
    @UserId INT
AS
BEGIN
    SELECT 
        UserId,
        UserName,
        EmailId,
        BirthDate,
        Address
    FROM Users
    WHERE UserId = @UserId
END
DROP PROCEDURE sp_GetUserById;


ALTER PROCEDURE sp_GetUserById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        UserId,
        UserName,
        EmailId,
        BirthDate,
        Address
    FROM dbo.Users   -- 🔥 FIX THIS LINE
    WHERE UserId = @UserId;
END


use UserManagementDB;

SELECT 
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name LIKE '%User%';


select * from tblUser;

DROP PROCEDURE IF EXISTS sp_GetUserById;


CREATE PROCEDURE sp_GetUserById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        UserId,
        UserName,
        EmailId,
        BirthDate,
        Address
    FROM dbo.tblUser     -- ✅ CORRECT TABLE
    WHERE UserId = @UserId;
END;
