SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		D'Oriocourt, John
-- Create date: 04/04/2014
-- Description:	Data for Percent Cash/Loss
-- Collected by Days report.
-- =============================================
CREATE PROCEDURE [dbo].[procGetPercentCash-LossCollectedReport] 
	-- Add the parameters for the stored procedure here
	@EndDate DATETIME,
    @AttorneyID INT,
    @CompanyID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT c.ID                                            AS CompanyID,
           c.LongName                                      AS CompanyName,
           a.ID                                            AS AttorneyID,
           a.FirstName                                     AS FirstName,
           a.LastName                                      AS LastName,
           i.ID                                            AS InvoiceID,
           i.LossesAmount                                  AS InvoiceLossesAmount,
           (SELECT SUM(p.Amount)
                        FROM   Payments p
                        WHERE  p.Active = 1
                               AND p.PaymentTypeID = 1
                               AND p.InvoiceID = i.ID
                               AND p.DatePaid <= @EndDate) AS InvoiceTotalPrincipal,
           CASE i.InvoiceTypeID
             WHEN 1 THEN [dbo].[f_GetFirstTestDate](i.ID)
             WHEN 2 THEN [dbo].[f_GetFirstSurgeryDate](i.ID)
           END                                             AS InvoiceFirstDate,
           (SELECT SUM(p.Amount)
                        FROM   Payments p
                        WHERE  p.Active = 1
                               AND p.InvoiceID = i.ID
                               AND p.DatePaid <= @EndDate) AS TotalAttorneyPayments,
           -- Payments during each cycle
           (SELECT SUM(p.Amount) 
            FROM   Payments p 
            WHERE  p.Active = 1 
                   AND p.InvoiceID = i.ID 
                   AND ( p.DatePaid <= @EndDate 
                         -- Payments before DateServiceFeeBegins AND Payments no more than 60 days out from EndDate 
                         AND ( ( ( i.InvoiceTypeID = 1 AND p.DatePaid >= DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstTestDate](i.ID)) ) 
                              OR ( i.InvoiceTypeID = 2 AND p.DatePaid >= DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstSurgeryDate](i.ID)) ) ) 
                            OR ( p.DatePaid >= DATEADD(d, -60, @EndDate) 
                                 AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstTestDate](i.ID)) ) 
                                    OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstSurgeryDate](i.ID)) ) ) ) ) )) 
                                                           AS 'Cash_<60',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -120, @EndDate) AND DATEADD(d, -61, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_60-120',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -180, @EndDate) AND DATEADD(d, -121, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_120-180',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -240, @EndDate) AND DATEADD(d, -181, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_180-240',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -300, @EndDate) AND DATEADD(d, -241, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_240-300',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -360, @EndDate) AND DATEADD(d, -301, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_300-360',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -420, @EndDate) AND DATEADD(d, -361, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_360-420',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -480, @EndDate) AND DATEADD(d, -421, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_420-480',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -540, @EndDate) AND DATEADD(d, -481, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_480-540',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -600, @EndDate) AND DATEADD(d, -541, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_540-600',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -660, @EndDate) AND DATEADD(d, -601, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_600-660',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -720, @EndDate) AND DATEADD(d, -661, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_660-720',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -780, @EndDate) AND DATEADD(d, -721, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_720-780',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -840, @EndDate) AND DATEADD(d, -781, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_780-840',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -900, @EndDate) AND DATEADD(d, -841, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_840-900',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid <= DATEADD(d, -901, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_>900'
    FROM   Attorney a
           INNER JOIN InvoiceAttorney ia ON a.ID = ia.AttorneyID
           INNER JOIN Invoice i ON ia.ID = i.InvoiceAttorneyID
           INNER JOIN Company c ON a.CompanyID = c.ID
    WHERE  a.Active = 1
           AND ia.Active = 1
           AND i.Active = 1
           AND a.CompanyID = @CompanyID
           AND (-1 = @AttorneyID
                OR a.ID = @AttorneyID)
           AND ( ( i.InvoiceTypeID = 1 AND [dbo].[f_GetFirstTestDate](i.ID) <= @EndDate ) 
              OR ( i.InvoiceTypeID = 2 AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate ) )
END
GO
