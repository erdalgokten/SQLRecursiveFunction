-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION ufn_get_menu_tree
(	
	@Menu VARCHAR(50) = NULL,
	@TreeLevel INT = 0
)
RETURNS @ResultTable TABLE (DisplayOrder INT IDENTITY, Menu VARCHAR(50), ParentMenu VARCHAR(50), TreeLevel INT)
AS
BEGIN

DECLARE @RowCount		INT
DECLARE @IterationCount INT
DECLARE @IterationMenu	VARCHAR(50)
DECLARE @TempTable		TABLE (i INT IDENTITY, Menu VARCHAR(50), ParentMenu VARCHAR(50), DisplayOrder INT)

INSERT	INTO @TempTable
SELECT	Menu, ParentMenu, DisplayOrder
FROM	MenuDefinitions (NOLOCK)
WHERE	ISNULL(ParentMenu, '') = ISNULL(@Menu, '')
ORDER	BY DisplayOrder ASC

SET @RowCount = @@ROWCOUNT
SET @IterationCount = 1

WHILE (@RowCount > 0 AND @IterationCount <= @RowCount)
BEGIN
	SELECT	@IterationMenu = Menu
	FROM	@TempTable
	WHERE	i = @IterationCount

	INSERT	INTO @ResultTable
	SELECT	Menu, ParentMenu, @TreeLevel
	FROM	@TempTable
	WHERE	Menu = @IterationMenu

	INSERT	INTO @ResultTable
	SELECT	Menu, ParentMenu, TreeLevel
	FROM	ufn_get_menu_tree(@IterationMenu, @TreeLevel + 1)

	SET		@IterationCount = @IterationCount + 1
END

RETURN
END
